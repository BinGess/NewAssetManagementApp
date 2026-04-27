import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A single option for [BottomSheetPicker].
class PickerOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;

  const PickerOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
  });
}

/// Tappable field that opens a glass bottom-sheet with a scrollable
/// option list — a full replacement for [DropdownButtonFormField].
///
/// Usage:
/// ```dart
/// BottomSheetPicker<int>(
///   label: '资产类型 *',
///   selectedValue: _selectedTypeId,
///   options: types.map((t) => PickerOption(value: t.id, label: t.label)).toList(),
///   onChanged: (v) => setState(() => _selectedTypeId = v),
///   validator: (v) => v == null ? '请选择资产类型' : null,
/// )
/// ```
class BottomSheetPicker<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<PickerOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool clearable;
  final String emptyHint;
  final String sheetTitle;

  const BottomSheetPicker({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.validator,
    this.clearable = false,
    this.emptyHint = '请选择',
    String? sheetTitle,
  }) : sheetTitle = sheetTitle ?? label;

  String? get _displayText {
    if (selectedValue == null) return null;
    try {
      return options.firstWhere((o) => o.value == selectedValue).label;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: selectedValue,
      validator: validator,
      builder: (state) {
        return GestureDetector(
          onTap: () => _openSheet(context, state),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  border: Border.all(
                    color: state.hasError
                        ? AppColors.error
                        : state.value != null
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : AppColors.glassDivider,
                    width: state.hasError || state.value != null ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              color: state.hasError
                                  ? AppColors.error
                                  : state.value != null
                                      ? AppColors.primary.withValues(alpha: 0.9)
                                      : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_displayText != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              _displayText!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ] else
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                emptyHint,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (clearable && selectedValue != null)
                          GestureDetector(
                            onTap: () {
                              state.didChange(null);
                              onChanged(null);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close,
                                  size: 16, color: AppColors.textMuted),
                            ),
                          ),
                        const Icon(Icons.expand_more_rounded,
                            size: 20, color: AppColors.textSecondary),
                      ],
                    ),
                  ],
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Text(
                    state.errorText!,
                    style: const TextStyle(
                        color: AppColors.error, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openSheet(BuildContext context, FormFieldState<T> state) async {
    final result = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PickerSheet<T>(
        title: sheetTitle,
        options: options,
        selectedValue: state.value,
        clearable: clearable,
      ),
    );

    // result == null means sheet dismissed without selection, don't change
    // result == const _Clear() means user tapped "clear"
    if (result != null) {
      state.didChange(result);
      onChanged(result);
    }
  }
}

// ─── Bottom sheet widget ──────────────────────────────────────────────────────

class _PickerSheet<T> extends StatelessWidget {
  final String title;
  final List<PickerOption<T>> options;
  final T? selectedValue;
  final bool clearable;

  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.clearable,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2540).withValues(alpha: 0.97),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            border: const Border(
              top: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassDivider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.glassDivider),

              // Options list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs),
                  itemCount: options.length,
                  itemBuilder: (ctx, i) {
                    final option = options[i];
                    final isSelected = option.value == selectedValue;
                    return InkWell(
                      onTap: () => Navigator.of(ctx).pop(option.value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            if (option.leading != null) ...[
                              option.leading!,
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (option.subtitle != null)
                                    Text(
                                      option.subtitle!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_rounded,
                                  color: AppColors.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                  height: MediaQuery.of(context).padding.bottom +
                      AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
