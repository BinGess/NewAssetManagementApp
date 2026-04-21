import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/assets')) return 1;
    if (location.startsWith('/liabilities')) return 2;
    if (location.startsWith('/expenses')) return 3;
    if (location.startsWith('/types') || location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/');
      case 1: context.go('/assets');
      case 2: context.go('/liabilities');
      case 3: context.go('/expenses');
      case 4: context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Global gradient background
      body: Stack(
        children: [
          // ── Gradient canvas ────────────────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A), // slate-900
                    Color(0xFF0D1B3E), // deep midnight
                    Color(0xFF1E1B4B), // indigo-950
                    Color(0xFF0F172A), // slate-900
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // ── Ambient glow blobs ─────────────────────────────────────────────
          Positioned(
            top: -120,
            left: -80,
            child: _GlowBlob(
              color: AppColors.primary.withValues(alpha: 0.12),
              size: 320,
            ),
          ),
          Positioned(
            top: 200,
            right: -100,
            child: _GlowBlob(
              color: AppColors.bgPurple.withValues(alpha: 0.25),
              size: 280,
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: _GlowBlob(
              color: AppColors.assetColor.withValues(alpha: 0.06),
              size: 200,
            ),
          ),

          // ── Screen content ─────────────────────────────────────────────────
          child,
        ],
      ),

      // ── Glass bottom navigation bar ────────────────────────────────────────
      bottomNavigationBar: _GlassNavBar(
        currentIndex: currentIndex,
        onTap: (i) => _onItemTapped(context, i),
      ),
    );
  }
}

// ─── Glass bottom navigation bar ─────────────────────────────────────────────
class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GlassNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.75),
            border: const Border(
              top: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  _NavItem(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard_rounded, label: '总览', index: 0, currentIndex: currentIndex, onTap: onTap),
                  _NavItem(icon: Icons.account_balance_wallet_outlined, selectedIcon: Icons.account_balance_wallet_rounded, label: '资产', index: 1, currentIndex: currentIndex, onTap: onTap),
                  _NavItem(icon: Icons.credit_card_outlined, selectedIcon: Icons.credit_card_rounded, label: '负债', index: 2, currentIndex: currentIndex, onTap: onTap),
                  _NavItem(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long_rounded, label: '支出', index: 3, currentIndex: currentIndex, onTap: onTap),
                  _NavItem(icon: Icons.menu_rounded, selectedIcon: Icons.menu_rounded, label: '更多', index: 4, currentIndex: currentIndex, onTap: onTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ambient glow blob ────────────────────────────────────────────────────────
class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.8,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}
