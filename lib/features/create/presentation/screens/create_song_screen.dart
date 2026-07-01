import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/step_bar.dart';
import '../providers/create_flow_provider.dart';

class CreateSongScreen extends ConsumerWidget {
  const CreateSongScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createFlowNotifierProvider);
    final notifier = ref.read(createFlowNotifierProvider.notifier);

    Future<void> pickSong() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['mp3', 'm4a', 'wav'],
        );
        if (result == null || result.files.single.path == null) return;
        notifier.setSong(
          path: result.files.single.path!,
          title: result.files.single.name,
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('파일을 선택하지 못했습니다: $e')),
        );
      }
    }

    void goNext() {
      if (state.songPath == null || state.songPath!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('노래 파일을 선택해주세요')),
        );
        return;
      }
      context.push('/create/timeline');
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => context.pop(),
        ),
        title: Text('노래 선택', style: AppTextStyles.subtitle),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: StepBar(step: 3, total: 3),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.badgeSong,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.music_note_rounded,
                            size: 36, color: AppColors.badgeSongText),
                      ),
                      const SizedBox(height: 20),
                      Text('노래 파일 선택', style: AppTextStyles.title),
                      const SizedBox(height: 8),
                      Text(
                        '노래가 재생되면 타임라인에 맞춰\n자동으로 악보 페이지가 넘어갑니다.',
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textSecondary, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),
                      if (state.songPath != null && state.songPath!.isNotEmpty)
                        _SelectedFileRow(
                          name: state.songTitle ?? '',
                          onClear: () => notifier.setSong(path: '', title: ''),
                          onReselect: pickSong,
                        )
                      else
                        OutlinedButton.icon(
                          onPressed: pickSong,
                          icon: const Icon(Icons.folder_open_outlined, size: 20),
                          label: const Text('파일 선택'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _BottomBar(
            onNext: goNext,
            nextLabel: '다음',
          ),
        ],
      ),
    );
  }
}

class _SelectedFileRow extends StatelessWidget {
  const _SelectedFileRow({
    required this.name,
    required this.onClear,
    required this.onReselect,
  });
  final String name;
  final VoidCallback onClear;
  final VoidCallback onReselect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: [
              const Icon(Icons.audio_file_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: AppColors.primary),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onReselect,
          child: Text('다른 파일 선택',
              style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onNext, required this.nextLabel});
  final VoidCallback onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(nextLabel,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
