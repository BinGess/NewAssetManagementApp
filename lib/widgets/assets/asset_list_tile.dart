import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/person_color.dart';
import '../../data/models/asset.dart';
import '../common/app_card.dart';

class AssetListTile extends StatelessWidget {
  final Asset asset;
  final String typeName;
  final String? personName;  // optional — shown as a coloured tag
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssetListTile({
    super.key,
    required this.asset,
    required this.typeName,
    this.personName,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final personColor = PersonColors.forId(asset.personId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: EdgeInsets.zero,
        // Subtle left-border glow in the person's color when assigned
        borderColor: asset.personId != null
            ? PersonColors.borderForId(asset.personId)
            : null,
        onTap: onTap,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon badge — tinted in person color when assigned
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: asset.personId != null
                        ? PersonColors.bgForId(asset.personId)
                        : AppColors.primaryGlow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: asset.personId != null
                          ? personColor.withValues(alpha: 0.3)
                          : AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: asset.personId != null
                        ? personColor
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Name + meta row
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Wrap(
                        spacing: 5,
                        runSpacing: 3,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Type chip
                          _Tag(label: typeName),
                          // Date
                          Text(
                            formatDate(asset.valuationDate),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          // Person chip (coloured)
                          if (personName != null)
                            _Tag(
                              label: personName!,
                              color: personColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount + annual rate
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCNY(asset.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.assetColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (asset.annualRate != null)
                      Text(
                        '年化 ${formatRate(asset.annualRate!)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.accent.withValues(alpha: 0.9),
                        ),
                      ),
                  ],
                ),

                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        size: 18, color: AppColors.textMuted),
                    onSelected: (value) {
                      if (value == 'edit') onEdit?.call();
                      if (value == 'delete') onDelete?.call();
                    },
                    itemBuilder: (_) => [
                      if (onEdit != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [
                            Icon(Icons.edit_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('编辑'),
                          ]),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline,
                                size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('删除',
                                style: TextStyle(color: Colors.red)),
                          ]),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color? color; // when null uses default glass style

  const _Tag({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: c != null ? c.withValues(alpha: 0.12) : AppColors.glass,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: c != null ? c.withValues(alpha: 0.4) : AppColors.glassBorder,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: c ?? AppColors.textSecondary,
          fontWeight: c != null ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
