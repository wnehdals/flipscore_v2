import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdfx/pdfx.dart';
import '../models/enums.dart';
import '../models/score_viewer_timeline.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';

/// 타임라인 편집에 필요한 단일 페이지 정보.
/// image: localPath 각각 별도 파일
/// pdf: localPath 가 PDF 파일 경로 (한 항목만 전달)
class TimelineEditorPage {
  const TimelineEditorPage({required this.localPath, required this.type});
  final String localPath;
  final ScoreType type;
}

/// 오디오 재생, PDF 렌더링, 페이지 뷰, 타임라인 추가/편집 UI를 담당하는 공통 바디.
/// 데이터 로딩과 저장 로직은 부모 화면이 담당한다.
class TimelineEditorBody extends StatefulWidget {
  const TimelineEditorBody({
    super.key,
    required this.pages,
    this.songPath,
    required this.entries,
    required this.onAddEntry,
    required this.onRemoveEntry,
    this.onTotalPagesChanged,
  });

  /// 표시할 악보 페이지 목록.
  final List<TimelineEditorPage> pages;

  /// 재생할 오디오 파일 경로 (없으면 null).
  final String? songPath;

  /// 현재 타임라인 항목 목록 (부모가 관리).
  final List<TimelineEntry> entries;

  /// 타임라인 추가 버튼 탭 시 호출. 부모가 pageIndex를 계산해 항목 추가.
  final void Function(Duration position) onAddEntry;

  /// 특정 인덱스 항목 삭제 시 호출.
  final void Function(int index) onRemoveEntry;

  /// 전체 페이지 수가 확정될 때 호출 (부모 유효성 검사용).
  final void Function(int totalPages)? onTotalPagesChanged;

  @override
  State<TimelineEditorBody> createState() => _TimelineEditorBodyState();
}

class _TimelineEditorBodyState extends State<TimelineEditorBody> {
  final _player = AudioPlayer();
  final _pageController = PageController();
  int _currentPage = 0;

  PdfDocument? _pdfDocument;
  int _pdfPageCount = 0;
  final Map<int, Future<PdfPageImage?>> _pageFutures = {};

  bool get _isPdf =>
      widget.pages.isNotEmpty && widget.pages.first.type == ScoreType.pdf;

  int get _totalPages => _isPdf ? _pdfPageCount : widget.pages.length;

  bool get _canAdd =>
      _totalPages > 1 && widget.entries.length < _totalPages - 1;

  @override
  void initState() {
    super.initState();
    _initAudio();
    if (_isPdf) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initPdf(widget.pages.first.localPath);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTotalPagesChanged?.call(widget.pages.length);
      });
    }
  }

  Future<void> _initAudio() async {
    final path = widget.songPath;
    if (path == null || path.isEmpty) return;
    try {
      await _player.setFilePath(path);
    } catch (e) {
      appLogger.e('[TimelineEditor] 음악 로드 실패', error: e);
    }
  }

  Future<void> _initPdf(String path) async {
    appLogger.i('[TimelineEditor] PDF path=$path');
    try {
      final doc = await PdfDocument.openFile(path);
      if (!mounted) return;
      setState(() {
        _pdfDocument = doc;
        _pdfPageCount = doc.pagesCount;
      });
      widget.onTotalPagesChanged?.call(doc.pagesCount);
    } catch (e, st) {
      appLogger.e('[TimelineEditor] PDF 실패', error: e, stackTrace: st);
    }
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
      _pageFutures.putIfAbsent(n, () => _renderPdfPage(n));

  @override
  void dispose() {
    _pageFutures.clear();
    _pdfDocument?.close();
    _player.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _handleAdd() {
    if (!_canAdd) return;
    widget.onAddEntry(_player.position);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => _TimelineSheet(
        entries: widget.entries,
        fmt: _fmt,
        onRemove: widget.onRemoveEntry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = _totalPages;

    return Column(
      children: [
        // 페이지 카운터
        if (count > 0)
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              '${_currentPage + 1} / $count',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          )
        else if (_isPdf)
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'PDF 불러오는 중...',
              style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
            ),
          ),

        // 악보 PageView
        Expanded(
          child: count == 0
              ? Center(
                  child: _isPdf
                      ? const CircularProgressIndicator(
                          color: AppColors.primary)
                      : Text('악보가 없습니다',
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.textTertiary)),
                )
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: count,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, i) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _isPdf
                          ? FutureBuilder<PdfPageImage?>(
                              future: _pdfFuture(i + 1),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.done) {
                                  if (snap.data == null) {
                                    return Center(
                                      child: Text(
                                        'PDF 페이지를 불러올 수 없습니다',
                                        style: AppTextStyles.body.copyWith(
                                            color: AppColors.textTertiary),
                                      ),
                                    );
                                  }
                                  return Image.memory(snap.data!.bytes,
                                      fit: BoxFit.contain);
                                }
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.primary));
                              },
                            )
                          : Image.file(
                              File(widget.pages[i].localPath),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
        ),

        // 뮤직 프로그레스 바
        _ProgressBar(player: _player, fmt: _fmt),

        // 액션 버튼
        Padding(
          padding: EdgeInsets.fromLTRB(
              20, 4, 20, 20),
          child: StreamBuilder<PlayerState>(
            stream: _player.playerStateStream,
            builder: (_, snap) {
              final playing = snap.data?.playing ?? false;
              return Row(
                children: [
                  Expanded(
                    child: _Btn(
                      icon: Icons.list_alt_rounded,
                      label: '타임라인 편집',
                      onTap: _showSheet,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _Btn(
                      icon: playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      label: playing ? '정지' : '재생',
                      isPrimary: true,
                      onTap: () =>
                          playing ? _player.pause() : _player.play(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _Btn(
                      icon: Icons.flag_rounded,
                      label: '타임라인 추가',
                      onTap: _canAdd ? _handleAdd : null,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── 프로그레스 바 ───────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.player, required this.fmt});
  final AudioPlayer player;
  final String Function(Duration) fmt;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (_, dSnap) {
        final total = dSnap.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: player.positionStream,
          initialData: Duration.zero,
          builder: (_, pSnap) {
            final pos = pSnap.data ?? Duration.zero;
            final clamped = total == Duration.zero
                ? Duration.zero
                : (pos > total ? total : pos);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(fmt(clamped),
                          style: AppTextStyles.playerTime
                              .copyWith(color: AppColors.textSecondary)),
                      Text(fmt(total),
                          style: AppTextStyles.playerTime
                              .copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12),
                    ),
                    child: Slider(
                      value: clamped.inMilliseconds.toDouble(),
                      max: total.inMilliseconds > 0
                          ? total.inMilliseconds.toDouble()
                          : 1,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.border,
                      onChanged: total == Duration.zero
                          ? null
                          : (v) =>
                              player.seek(Duration(milliseconds: v.round())),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── 타임라인 목록 바텀시트 ─────────────────────────────────────────────────

class _TimelineSheet extends StatelessWidget {
  const _TimelineSheet(
      {required this.entries,
      required this.fmt,
      required this.onRemove});
  final List<TimelineEntry> entries;
  final String Function(Duration) fmt;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('타임라인 목록', style: AppTextStyles.subtitle),
              const Spacer(),
              Text('${entries.length}개',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          SizedBox(height: 16),
          if (entries.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('추가된 타임라인이 없습니다',
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.textTertiary)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (_, _) => SizedBox(height: 8),
              itemBuilder: (_, i) {
                final e = entries[i];
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag_rounded,
                          size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('페이지 ${e.pageIndex + 1}',
                          style: AppTextStyles.bodyMedium),
                      const Spacer(),
                      Text(fmt(Duration(milliseconds: e.timestampMs)),
                          style: AppTextStyles.playerTime
                              .copyWith(color: AppColors.textSecondary)),
                      SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: AppColors.error),
                        onPressed: () => onRemove(i),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// ─── 액션 버튼 ───────────────────────────────────────────────────────────────

class _Btn extends StatelessWidget {
  const _Btn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isPrimary ? AppColors.surface : AppColors.dark,
        backgroundColor: isPrimary
            ? (disabled ? AppColors.border : AppColors.primary)
            : null,
        side: BorderSide(
            color: isPrimary
                ? (disabled ? AppColors.border : AppColors.primary)
                : AppColors.border),
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        disabledForegroundColor: AppColors.textTertiary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: disabled
                  ? AppColors.textTertiary
                  : (isPrimary ? AppColors.surface : AppColors.dark),
            ),
          ),
        ],
      ),
    );
  }
}
