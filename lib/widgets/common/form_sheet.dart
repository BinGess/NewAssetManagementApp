import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Standard bottom-sheet container for all forms.
///
/// Provides:
///  - Dark glass background consistent with [_PickerSheet]
///  - Rounded top corners + handle bar
///  - Keyboard-aware bottom padding via [MediaQuery.viewInsetsOf]
///
/// Usage — place this as the root widget returned by any form:
/// ```dart
/// return FormSheet(
///   child: Column(children: [ ... form fields ... ]),
/// );
/// ```
///
/// Call sites must use:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => MyForm(),
/// );
/// ```
class FormSheet extends StatelessWidget {
  final Widget child;

  /// Extra bottom padding added on top of the keyboard inset.
  final double extraBottomPadding;

  const FormSheet({
    super.key,
    required this.child,
    this.extraBottomPadding = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = keyboardInset + extraBottomPadding;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xF71A2540), // ~97 % opaque dark blue
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.sm,
                bottom: bottomPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.glassDivider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
