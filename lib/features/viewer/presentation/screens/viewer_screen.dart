import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdfx/pdfx.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';
import '../../../../shared/models/usage_time.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../create/presentation/providers/create_flow_provider.dart';
import '../../../usage_time/presentation/providers/subscription_provider.dart';
import '../../../usage_time/presentation/providers/usage_time_provider.dart';

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

  // 이용시간
  String? _docId;
  UsageTime? _usageTime;
  int _remainingSeconds = 0;
  bool _isSubscribed = false;
  Timer? _usageTimer;
  Timer? _firestoreTimer;
  bool _timeExpired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _usageTimer?.cancel();
    _firestoreTimer?.cancel();
    _positionSub?.cancel();
    _audioPlayer?.dispose();
    _pageController.dispose();
    _pdfPageFutures.clear();
    _pdfDocument?.close();
    unawaited(_saveUsageTime());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _usageTimer?.cancel();
      _firestoreTimer?.cancel();
      _audioPlayer?.pause();
      unawaited(_saveUsageTime());
    } else if (state == AppLifecycleState.resumed) {
      if (!_isSubscribed && _remainingSeconds > 0 && !_timeExpired) {
        _startUsageTimer();
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

    // 이용시간 초기화
    await _initUsageTime();

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

  Future<void> _initUsageTime() async {
    final authAsync = ref.read(authStateProvider);
    _docId = authAsync.valueOrNull?.docId;

    final sub = ref.read(currentSubscriptionProvider).valueOrNull;
    _isSubscribed = sub?.isActive ?? false;

    if (_docId != null) {
      final repo = ref.read(usageTimeRepositoryProvider);
      _usageTime = await repo.getUsageTime(_docId!);
      _remainingSeconds = _usageTime?.remainingSeconds ?? 0;
    }

    if (_isSubscribed) return;

    if (_remainingSeconds <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showNoTimeDialog();
      });
    } else {
      _startUsageTimer();
    }
  }

  void _startUsageTimer() {
    _usageTimer?.cancel();
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds = (_remainingSeconds - 1).clamp(0, 999999);
      });
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _timeExpired = true;
        _audioPlayer?.pause();
        unawaited(_saveUsageTime());
        _showNoTimeDialog();
      }
    });

    // 30초마다 Firestore 저장
    _firestoreTimer?.cancel();
    _firestoreTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_saveUsageTime());
    });
  }

  Future<void> _saveUsageTime() async {
    final time = _usageTime;
    final docId = _docId;
    if (time == null || docId == null || _isSubscribed) return;
    try {
      final repo = ref.read(usageTimeRepositoryProvider);
      final updated = time.copyWith(
        remainingSeconds: _remainingSeconds,
        updatedAt: DateTime.now(),
      );
      await repo.updateUsageTime(docId, updated);
      _usageTime = updated;
    } catch (_) {}
  }

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

  void _showNoTimeDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(Responsive.getDp(context, 16)),
        ),
        title: Text('이용시간 종료', style: AppTextStyles.subtitle),
        content: Text(
          '이용시간이 모두 소진되었습니다.\n광고 시청 또는 구독으로 이용시간을 획득해주세요.',
          style: AppTextStyles.body
              .copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/usage-time');
            },
            child: const Text('이용시간 획득'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/');
            },
            child: Text('홈으로',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatSeconds(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final dp = Responsive.getDp;

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
              SizedBox(height: dp(context, 16)),
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
    final show5MinWarning = !_isSubscribed &&
        _remainingSeconds > 0 &&
        _remainingSeconds <= 300;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 악보 PageView (전체 화면)
          PageView.builder(
            controller: _pageController,
            itemCount: _pageCount,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) => _isPdf
                ? _PdfPageView(future: _pdfFuture(i + 1))
                : _ScorePageWidget(page: viewer.pages[i]),
          ),

          // 상단 오버레이
          _buildTopBar(context, viewer, isSongMode, dp),

          // 5분 이하 카운트다운 오버레이
          if (show5MinWarning) _buildCountdownOverlay(context, dp),

          // 제스처 모드 안내 배지
          if (isGestureMode) _buildGestureBadge(context, viewer, dp),

          // 하단 플레이어 바 (노래 모드)
          if (isSongMode)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildPlayerBar(context, viewer, dp),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    ScoreViewer viewer,
    bool isSongMode,
    double Function(BuildContext, double) dp,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: dp(context, 12), vertical: dp(context, 8)),
          child: Row(
            children: [
              // 닫기 버튼
              IconButton(
                onPressed: () {
                  unawaited(_saveUsageTime());
                  context.go('/');
                },
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black45,
                  padding: EdgeInsets.all(dp(context, 8)),
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

              // 이용시간 / 구독 표시
              _buildUsageTimeBadge(context, dp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageTimeBadge(
      BuildContext context, double Function(BuildContext, double) dp) {
    if (_isSubscribed) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: dp(context, 10), vertical: dp(context, 5)),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(dp(context, 20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.all_inclusive,
                size: dp(context, 13), color: Colors.white),
            SizedBox(width: dp(context, 4)),
            Text('구독중',
                style: AppTextStyles.micro.copyWith(color: Colors.white)),
          ],
        ),
      );
    }

    final isLow = _remainingSeconds <= 300;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: dp(context, 10), vertical: dp(context, 5)),
      decoration: BoxDecoration(
        color: isLow
            ? Colors.red.withValues(alpha: 0.85)
            : Colors.black54,
        borderRadius: BorderRadius.circular(dp(context, 20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined,
              size: dp(context, 13), color: Colors.white),
          SizedBox(width: dp(context, 4)),
          Text(_formatSeconds(_remainingSeconds),
              style: AppTextStyles.micro.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildCountdownOverlay(
      BuildContext context, double Function(BuildContext, double) dp) {
    return Positioned(
      top: dp(context, 80),
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: dp(context, 16), vertical: dp(context, 10)),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(dp(context, 12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.white, size: dp(context, 16)),
              SizedBox(width: dp(context, 6)),
              Text(
                '이용시간 ${_formatSeconds(_remainingSeconds)} 남음',
                style: AppTextStyles.label.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGestureBadge(
    BuildContext context,
    ScoreViewer viewer,
    double Function(BuildContext, double) dp,
  ) {
    final gestureLabel = switch (viewer.gestureType) {
      GestureType.rightWink => '오른쪽 눈 윙크',
      GestureType.leftWink => '왼쪽 눈 윙크',
      GestureType.blink => '눈 두 번 깜빡임',
      GestureType.smile => '미소',
      null => '제스처',
    };

    return Positioned(
      bottom: dp(context, 24),
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: dp(context, 14), vertical: dp(context, 8)),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(dp(context, 24)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.remove_red_eye_outlined,
                  color: Colors.white70, size: dp(context, 14)),
              SizedBox(width: dp(context, 6)),
              Text('$gestureLabel → 다음 페이지',
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
    double Function(BuildContext, double) dp,
  ) {
    final player = _audioPlayer;
    if (player == null) return const SizedBox.shrink();

    return Container(
      color: AppColors.playerBg,
      padding: EdgeInsets.fromLTRB(
          dp(context, 16), dp(context, 10), dp(context, 16), dp(context, 16)),
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
                            trackHeight: dp(context, 3),
                            activeTrackColor: AppColors.playerAccent,
                            inactiveTrackColor:
                                Colors.white.withValues(alpha: 0.2),
                            thumbColor: AppColors.playerAccent,
                            thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: dp(context, 5)),
                            overlayShape: RoundSliderOverlayShape(
                                overlayRadius: dp(context, 10)),
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

            SizedBox(height: dp(context, 4)),

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
                          color: AppColors.playerText, size: dp(context, 22)),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                          minWidth: dp(context, 40),
                          minHeight: dp(context, 40)),
                    ),

                    SizedBox(width: dp(context, 4)),

                    // 재생/정지
                    GestureDetector(
                      onTap: () =>
                          playing ? player.pause() : player.play(),
                      child: Container(
                        width: dp(context, 44),
                        height: dp(context, 44),
                        decoration: const BoxDecoration(
                          color: AppColors.playerAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: dp(context, 24),
                        ),
                      ),
                    ),

                    SizedBox(width: dp(context, 4)),

                    // 타임라인 재설정
                    IconButton(
                      onPressed: () {
                        player.pause();
                        context.go(
                            '/viewer/${widget.viewerId}/timeline');
                      },
                      icon: Icon(Icons.tune_rounded,
                          color: AppColors.playerText, size: dp(context, 22)),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                          minWidth: dp(context, 40),
                          minHeight: dp(context, 40)),
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
