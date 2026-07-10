import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdfx/pdfx.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';
import '../../../create/presentation/providers/create_flow_provider.dart';
import '../../../settings/presentation/providers/gesture_sensitivity_provider.dart';
import '../controllers/gesture_camera_controller.dart';

class ViewerScreen extends ConsumerStatefulWidget {
  const ViewerScreen({super.key, required this.viewerId});
  final String viewerId;

  @override
  ConsumerState<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends ConsumerState<ViewerScreen>
    with WidgetsBindingObserver {
  // 뷰어 데이터
  ScoreViewer? _viewer;
  ScoreViewerTimeline? _timeline;
  bool _loading = true;

  // PDF
  PdfDocument? _pdfDocument;
  int _pdfPageCount = 0;
  final Map<int, Future<PdfPageImage?>> _pdfPageFutures = {};

  bool get _isPdf =>
      _viewer != null &&
      _viewer!.pages.isNotEmpty &&
      _viewer!.pages.first.type == ScoreType.pdf;

  int get _pageCount => _isPdf ? _pdfPageCount : (_viewer?.pages.length ?? 0);

  // 페이지
  final _pageController = PageController();
  int _currentPage = 0;

  // 오디오 (노래 모드)
  AudioPlayer? _audioPlayer;
  StreamSubscription<Duration>? _positionSub;
  bool _isTurningPage = false;

  // 제스처 모드
  GestureCameraController? _gestureController;
  bool _gestureCameraFailed = false;
  bool _gestureWarningShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _positionSub?.cancel();
    _audioPlayer?.dispose();
    _pageController.dispose();
    _pdfPageFutures.clear();
    _pdfDocument?.close();
    unawaited(_gestureController?.dispose());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _audioPlayer?.pause();
      // inactive는 통화/제어센터 등으로 순간 발생할 수 있어 카메라는
      // 실제 백그라운드 전환(paused)일 때만 정지한다.
      if (state == AppLifecycleState.paused) {
        unawaited(_gestureController?.stop());
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_viewer?.transitionMode == TransitionMode.gesture) {
        unawaited(_startGestureDetection());
      }
    }
  }

  Future<void> _initialize() async {
    final repo = ref.read(localScoreViewerRepositoryProvider);
    final all = await repo.loadAll();
    _viewer = all.where((v) => v.id == widget.viewerId).firstOrNull;

    if (!mounted) return;

    if (_viewer == null) {
      setState(() => _loading = false);
      return;
    }

    // 타임라인 로드
    if (_viewer!.hasTimeline) {
      _timeline = await repo.loadTimeline(widget.viewerId);
    }

    // PDF 로드
    if (_viewer!.pages.isNotEmpty &&
        _viewer!.pages.first.type == ScoreType.pdf) {
      await _initPdf(_viewer!.pages.first.localPath);
    }

    // 노래 모드 초기화
    if (_viewer!.transitionMode == TransitionMode.song) {
      _audioPlayer = AudioPlayer();
      final songPath = _viewer!.songId;
      if (songPath != null && songPath.isNotEmpty) {
        try {
          await _audioPlayer!.setFilePath(songPath);
        } catch (_) {}
      }
      _setupAutoPageTurn();
    }

    // 제스처 모드 초기화 (카메라 준비는 화면 로딩을 막지 않도록 병행 실행)
    if (_viewer!.transitionMode == TransitionMode.gesture) {
      unawaited(_startGestureDetection());
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _initPdf(String path) async {
    try {
      final doc = await PdfDocument.openFile(path);
      if (!mounted) return;
      setState(() {
        _pdfDocument = doc;
        _pdfPageCount = doc.pagesCount;
      });
    } catch (_) {}
  }

  Future<PdfPageImage?> _renderPdfPage(int n) async {
    final doc = _pdfDocument;
    if (doc == null) return null;
    try {
      final page = await doc.getPage(n);
      final img = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.jpeg,
      );
      await page.close();
      return img;
    } catch (_) {
      return null;
    }
  }

  Future<PdfPageImage?> _pdfFuture(int n) =>
      _pdfPageFutures.putIfAbsent(n, () => _renderPdfPage(n));

  void _setupAutoPageTurn() {
    _positionSub = _audioPlayer?.positionStream.listen((position) {
      if (_timeline == null || _isTurningPage) return;
      for (final entry in _timeline!.entries) {
        final ts = Duration(milliseconds: entry.timestampMs);
        if (position >= ts && _currentPage < entry.pageIndex) {
          _isTurningPage = true;
          _pageController
              .animateToPage(
                entry.pageIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )
              .then((_) => _isTurningPage = false);
          break;
        }
      }
    });
  }

  Future<void> _startGestureDetection() async {
    final sensitivity = ref
            .read(gestureSensitivityControllerProvider)
            .valueOrNull ??
        GestureSensitivity.medium;
    appLogger.i('[ViewerScreen] 제스처 감지 시작 요청 (sensitivity=${sensitivity.name})');
    final controller = _gestureController ??= GestureCameraController(
      onGesture: _onGestureDetected,
      sensitivity: sensitivity,
    );
    final started = await controller.start();
    if (!mounted) return;
    setState(() => _gestureCameraFailed = !started);
    if (!started) {
      appLogger.w('[ViewerScreen] 제스처 카메라 시작 실패');
      if (!_gestureWarningShown) {
        _gestureWarningShown = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카메라를 사용할 수 없어 제스처 인식이 꺼져 있습니다. 카메라 권한을 확인해주세요.'),
          ),
        );
      }
    }
  }

  void _onGestureDetected(GestureType gesture) {
    if (!mounted || _isTurningPage) return;
    final expected = _viewer?.gestureType;
    if (expected == null || gesture != expected) {
      appLogger.d(
        '[ViewerScreen] 제스처($gesture) 감지됐지만 설정된 제스처($expected)와 달라 무시',
      );
      return;
    }
    if (_currentPage >= _pageCount - 1) {
      appLogger.i('[ViewerScreen] 마지막 페이지라 제스처($gesture) 무시');
      return;
    }
    appLogger.i(
      '[ViewerScreen] 제스처($gesture)로 페이지 전환: $_currentPage -> ${_currentPage + 1}',
    );
    _isTurningPage = true;
    _pageController
        .nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then((_) => _isTurningPage = false);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_viewer == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('악보뷰어를 찾을 수 없습니다',
                  style:
                      AppTextStyles.body.copyWith(color: Colors.white)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('홈으로',
                    style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
        ),
      );
    }

    final viewer = _viewer!;
    final isSongMode = viewer.transitionMode == TransitionMode.song;
    final isGestureMode = viewer.transitionMode == TransitionMode.gesture;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 상단 바 (고정 영역, 악보와 겹치지 않음)
          _buildTopBar(context, viewer, isSongMode),

          // 악보 PageView (남은 영역 전체)
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _pageCount,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, i) => _isPdf
                      ? _PdfPageView(future: _pdfFuture(i + 1))
                      : _ScorePageWidget(page: viewer.pages[i]),
                ),

                // 제스처 모드 안내 배지 (악보 영역 내부에만 표시)
                if (isGestureMode) _buildGestureBadge(context, viewer),
              ],
            ),
          ),

          // 하단 플레이어 바 (노래 모드, 고정 영역)
          if (isSongMode) _buildPlayerBar(context, viewer),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    ScoreViewer viewer,
    bool isSongMode,
  ) {
    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // 닫기 버튼
              IconButton(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black45,
                  padding: const EdgeInsets.all(8),
                ),
              ),

              // 제목
              Expanded(
                child: Center(
                  child: Text(
                    viewer.title,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGestureBadge(
    BuildContext context,
    ScoreViewer viewer,
  ) {
    final gestureLabel = switch (viewer.gestureType) {
      GestureType.rightWink => '오른쪽 눈 윙크',
      GestureType.leftWink => '왼쪽 눈 윙크',
      GestureType.blink => '눈 두 번 깜빡임',
      null => '제스처',
    };

    final label = _gestureCameraFailed ? '카메라 꺼짐' : '$gestureLabel → 다음 페이지';
    final icon =
        _gestureCameraFailed ? Icons.videocam_off_outlined : Icons.remove_red_eye_outlined;

    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white70, size: 14),
              SizedBox(width: 6),
              Text(label,
                  style: AppTextStyles.caption
                      .copyWith(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerBar(
    BuildContext context,
    ScoreViewer viewer,
  ) {
    final player = _audioPlayer;
    if (player == null) return const SizedBox.shrink();

    return Container(
      color: AppColors.playerBg,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 프로그레스 바
            StreamBuilder<Duration?>(
              stream: player.durationStream,
              builder: (context, durationSnap) {
                final total = durationSnap.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: player.positionStream,
                  initialData: Duration.zero,
                  builder: (context, positionSnap) {
                    final pos = positionSnap.data ?? Duration.zero;
                    final clamped =
                        total == Duration.zero ? Duration.zero : (pos > total ? total : pos);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(clamped),
                              style: AppTextStyles.playerTime
                                  .copyWith(color: AppColors.playerText),
                            ),
                            Text(
                              _formatDuration(total),
                              style: AppTextStyles.playerTime
                                  .copyWith(color: AppColors.playerTextDim),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            activeTrackColor: AppColors.playerAccent,
                            inactiveTrackColor:
                                Colors.white.withValues(alpha: 0.2),
                            thumbColor: AppColors.playerAccent,
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 5),
                            overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 10),
                          ),
                          child: Slider(
                            value: clamped.inMilliseconds.toDouble(),
                            max: total.inMilliseconds > 0
                                ? total.inMilliseconds.toDouble()
                                : 1,
                            onChanged: total == Duration.zero
                                ? null
                                : (v) => player.seek(
                                    Duration(milliseconds: v.round())),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            SizedBox(height: 4),

            // 컨트롤 버튼
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snap) {
                final playing = snap.data?.playing ?? false;
                return Row(
                  children: [
                    // 곡명
                    Expanded(
                      child: Text(
                        viewer.songTitle ?? '재생 중',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.playerText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // 처음부터
                    IconButton(
                      onPressed: () => player.seek(Duration.zero),
                      icon: Icon(Icons.skip_previous_rounded,
                          color: AppColors.playerText, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40),
                    ),

                    SizedBox(width: 4),

                    // 재생/정지
                    GestureDetector(
                      onTap: () =>
                          playing ? player.pause() : player.play(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.playerAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    SizedBox(width: 4),

                    // 타임라인 재설정
                    IconButton(
                      onPressed: () {
                        player.pause();
                        context.go(
                            '/viewer/${widget.viewerId}/timeline');
                      },
                      icon: Icon(Icons.tune_rounded,
                          color: AppColors.playerText, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40),
                      tooltip: '타임라인',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ScorePageWidget extends StatelessWidget {
  const _ScorePageWidget({required this.page});
  final ScorePage page;

  @override
  Widget build(BuildContext context) {
    final file = File(page.localPath);
    return Image.file(
      file,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_not_supported,
                color: Colors.white38, size: 48),
            const SizedBox(height: 8),
            Text('페이지 ${page.order + 1}',
                style: const TextStyle(color: Colors.white38, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _PdfPageView extends StatelessWidget {
  const _PdfPageView({required this.future});
  final Future<PdfPageImage?> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PdfPageImage?>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (snap.data == null) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.white38, size: 48),
          );
        }
        return Image.memory(snap.data!.bytes, fit: BoxFit.contain);
      },
    );
  }
}
