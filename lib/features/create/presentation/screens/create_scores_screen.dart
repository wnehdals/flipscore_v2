import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flipscore/core/utils/responsive.dart';
import 'package:flipscore/shared/widgets/prrimary_button.dart';
import 'package:flipscore/shared/widgets/second_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/widgets/horizontal_divider.dart';
import '../../../../shared/widgets/step_bar.dart';
import '../providers/create_flow_provider.dart';

class CreateScoresScreen extends ConsumerWidget {
  const CreateScoresScreen({super.key});

  // 탭 클릭: 즉시 모드 전환 (파일 피커 없음)
  void _switchToImage(WidgetRef ref, ScoreType? current) {
    if (current == ScoreType.image) return;
    ref.read(createFlowNotifierProvider.notifier).setScoreType(ScoreType.image);
  }

  void _switchToPdf(WidgetRef ref, ScoreType? current) {
    if (current == ScoreType.pdf) return;
    ref.read(createFlowNotifierProvider.notifier).setScoreType(ScoreType.pdf);
  }

  // 파일 추가: 빈 화면 버튼 or 그리드 타일에서 호출
  Future<void> _pickImages(WidgetRef ref) async {
    final notifier = ref.read(createFlowNotifierProvider.notifier);
    final images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return;
    notifier.setScorePaths(images.map((e) => e.path).toList());
  }

  Future<void> _addImages(WidgetRef ref, List<String> existing) async {
    final notifier = ref.read(createFlowNotifierProvider.notifier);
    final images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return;
    notifier.setScorePaths([...existing, ...images.map((e) => e.path)]);
  }

  Future<void> _pickPdf(WidgetRef ref) async {
    final notifier = ref.read(createFlowNotifierProvider.notifier);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;
    notifier.setScorePaths([result.files.single.path!]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createFlowNotifierProvider);
    final isImage = state.scoreType == ScoreType.image;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22, color: AppColors.dark),
          onPressed: () {
            ref.read(createFlowNotifierProvider.notifier).reset();
            context.go('/');
          },
        ),
        title: Text('악보뷰어 만들기', style: AppTextStyles.subtitle),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: StepBar(step: 1, total: 3),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.background,
          child: Column(
            children: [
              _TitleInput(
                initialValue: state.title,
                onChanged: (v) =>
                    ref.read(createFlowNotifierProvider.notifier).setTitle(v),
              ),
              const HorizontalDivider(),
              _FileTypeToggle(
                selectedType: state.scoreType,
                onSelectImage: () => _switchToImage(ref, state.scoreType),
                onSelectPdf: () => _switchToPdf(ref, state.scoreType),
              ),
              const HorizontalDivider(),
              if (state.scorePaths.isNotEmpty && isImage) const _HintText(),
              Expanded(
                child: _ScoreGrid(
                  paths: state.scorePaths,
                  scoreType: state.scoreType,
                  onPickFiles: () {
                    if (isImage) {
                      _pickImages(ref);
                    } else {
                      _pickPdf(ref);
                    }
                  },
                  onAddImages: () => _addImages(ref, state.scorePaths),
                  onReorder: (oldIdx, newIdx) {
                    final list = [...state.scorePaths];
                    final item = list.removeAt(oldIdx);
                    list.insert(newIdx, item);
                    ref
                        .read(createFlowNotifierProvider.notifier)
                        .setScorePaths(list);
                  },
                ),
              ),
              _BottomBar(
                count: state.scorePaths.length,
                scoreType: state.scoreType,
                onCancel: () {
                  ref.read(createFlowNotifierProvider.notifier).reset();
                  context.go('/');
                },
                onNext: () {
                  if (state.title.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('악보뷰어 이름을 입력해주세요')),
                    );
                    return;
                  }
                  if (state.scorePaths.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('악보 파일을 한 장 이상 선택해주세요')),
                    );
                    return;
                  }
                  context.push('/create/mode');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step Indicator ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});
  final int currentStep;

  static const _steps = ['악보', '전환방식', '저장'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _steps.length; i++) ...[
                  _StepItem(
                    number: i + 1,
                    label: _steps[i],
                    isActive: i == currentStep,
                  ),
                  if (i < _steps.length - 1)
                    _StepConnector(isActive: i < currentStep),
                ],
              ],
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.label,
    required this.isActive,
  });
  final int number;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.primary : const Color(0xFFCFD1D4),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: AppTextStyles.micro.copyWith(
              fontSize: 11,
              color: isActive ? Colors.white : const Color(0xFFB0B4B8),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            fontSize: 11,
            color: isActive ? AppColors.textSecondary : const Color(0xFFB1B5BA),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: 36,
        height: 1,
        color: isActive ? AppColors.primary : const Color(0xFFE0E1E4),
      ),
    );
  }
}

// ── Title Input ──────────────────────────────────────────────────────────────

class _TitleInput extends StatefulWidget {
  const _TitleInput({required this.initialValue, required this.onChanged});

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<_TitleInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: AppTextStyles.subtitle,
        decoration: InputDecoration(
          hintText: '악보뷰어 이름을 입력하세요',
          hintStyle: AppTextStyles.subtitle.copyWith(
            color: AppColors.textTertiary,
          ),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── File Type Toggle ─────────────────────────────────────────────────────────

class _FileTypeToggle extends StatelessWidget {
  const _FileTypeToggle({
    required this.selectedType,
    required this.onSelectImage,
    required this.onSelectPdf,
  });
  final ScoreType? selectedType;
  final VoidCallback onSelectImage;
  final VoidCallback onSelectPdf;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAEBEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypeTab(
                  icon: Icons.image_outlined,
                  label: '사진',
                  isSelected: selectedType == ScoreType.image,
                  onTap: onSelectImage,
                ),
                _TypeTab(
                  icon: Icons.picture_as_pdf_outlined,
                  label: 'PDF',
                  isSelected: selectedType == ScoreType.pdf,
                  onTap: onSelectPdf,
                ),
              ],
            ),
          ),
          const Spacer(),
          if (selectedType != null)
            Text(
              selectedType == ScoreType.image ? 'JPG, PNG' : 'PDF',
              style: AppTextStyles.badge.copyWith(
                color: const Color(0xFFB4B9BD),
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: isSelected
                  ? const Color(0xFF5D5D5F)
                  : const Color(0xFF9DA1A6),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected
                    ? const Color(0xFF5D5D5F)
                    : const Color(0xFF9DA1A6),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hint Text ────────────────────────────────────────────────────────────────

class _HintText extends StatelessWidget {
  const _HintText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Pretendard Variable',
              fontSize: 12,
              letterSpacing: 0,
            ),
            children: [
              TextSpan(
                text: '사진을 선택하고 ',
                style: TextStyle(color: Color(0xFFA1A4A8)),
              ),
              TextSpan(
                text: '드래그하여 순서',
                style: TextStyle(
                  color: Color(0xFF888DE0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: '를 변경할 수 있습니다.',
                style: TextStyle(color: Color(0xFFA2A4A9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Score Grid ───────────────────────────────────────────────────────────────

class _ScoreGrid extends StatelessWidget {
  const _ScoreGrid({
    required this.paths,
    required this.scoreType,
    required this.onPickFiles,
    required this.onAddImages,
    required this.onReorder,
  });
  final List<String> paths;
  final ScoreType? scoreType;
  final VoidCallback onPickFiles;
  final VoidCallback onAddImages;
  final void Function(int, int) onReorder;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.isTablet(context) ? 3 : 2;

    if (paths.isEmpty) {
      return _EmptyState(scoreType: scoreType, onAdd: onPickFiles);
    }

    if (scoreType == ScoreType.pdf) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3 / 2,
        ),
        itemCount: paths.length,
        itemBuilder: (_, i) => _PageTile(path: paths[i], index: i),
      );
    }

    return ReorderableGridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 3 / 2,
      onReorder: (oldIdx, newIdx) {
        if (oldIdx >= paths.length) return;
        final clamped = newIdx.clamp(0, paths.length - 1);
        if (oldIdx == clamped) return;
        onReorder(oldIdx, clamped);
      },
      children: [
        for (var i = 0; i < paths.length; i++)
          _PageTile(key: ValueKey(paths[i]), path: paths[i], index: i),
        _AddMoreTile(key: const ValueKey('__add__'), onTap: onAddImages),
      ],
    );
  }
}

class _PageTile extends StatelessWidget {
  const _PageTile({super.key, required this.path, required this.index});
  final String path;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isPdf = path.toLowerCase().endsWith('.pdf');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFF0F1F2), width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!isPdf)
              Image.file(File(path), fit: BoxFit.cover)
            else
              Container(
                color: const Color(0xFFFAFAFB),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.dark.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: AppTextStyles.micro.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  const _AddMoreTile({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFB),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xFFE9EBED)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              size: 22,
              color: Color(0xFFB1B6BA),
            ),
            const SizedBox(height: 6),
            Text(
              '사진 추가',
              style: AppTextStyles.badge.copyWith(
                color: const Color(0xFFB1B6BA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.scoreType, this.onAdd});
  final ScoreType? scoreType;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    if (scoreType == null) {
      return Center(
        child: Text(
          '위 탭에서 파일 형식을 선택해주세요',
          style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
        ),
      );
    }

    final isImage = scoreType == ScoreType.image;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isImage
                ? Icons.add_photo_alternate_outlined
                : Icons.picture_as_pdf_outlined,
            size: 52,
            color: AppColors.border,
          ),
          const SizedBox(height: 12),
          Text(
            isImage ? '사진을 추가해주세요' : 'PDF를 추가해주세요',
            style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: isImage ? '사진 선택' : 'PDF 선택' , onPressed: onAdd),
        ],
      ),
    );
  }
}

// ── Bottom Bar ───────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.count,
    required this.scoreType,
    required this.onCancel,
    required this.onNext,
  });
  final int count;
  final ScoreType? scoreType;
  final VoidCallback onCancel;
  final VoidCallback onNext;

  String get _countText {
    if (count == 0) return '';
    if (scoreType == ScoreType.image) return '사진 $count장 선택됨';
    return 'PDF 1개 선택됨';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Row(
        children: [
          if (count > 0)
            Text(
              _countText,
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFB8BCC0),
              ),
            ),
          const Spacer(),
          PrimaryButton(label: '다음', onPressed: onNext),
        ],
      ),
    );
  }
}
