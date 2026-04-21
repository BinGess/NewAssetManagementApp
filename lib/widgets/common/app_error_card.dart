import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

/// A centered error widget with an optional retry button.
///
/// Usage:
/// ```dart
/// ref.watch(myProvider).when(
///   data: (d) => ...,
///   loading: () => const AppLoading(),
///   error: (e, _) => AppErrorCard(
///     message: e.toString(),
///     onRetry: () => ref.invalidate(myProvider),
///   ),
/// );
/// ```
class AppErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorCard({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: colorScheme.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              '加载失败',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
