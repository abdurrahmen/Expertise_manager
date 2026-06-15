import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models.dart';

/// A6 — Enter PIN: avatar + dots + numeric keypad + shake animation.
class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> with SingleTickerProviderStateMixin {
  String _pin = '';
  bool _error = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  Member? _member;
  String _nextRoute = '/boss';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _member = args['member'] as Member?;
      _nextRoute = args['nextRoute'] as String? ?? '/boss';
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onKeyTap(String key) {
    if (key == 'delete') {
      if (_pin.isNotEmpty) {
        setState(() {
          _pin = _pin.substring(0, _pin.length - 1);
          _error = false;
        });
      }
      return;
    }

    if (_pin.length >= 4) return;

    setState(() {
      _pin += key;
      _error = false;
    });

    if (_pin.length == 4) {
      // Mock: accept any PIN "1234"
      Future.delayed(const Duration(milliseconds: 200), () {
        if (_pin == '1234') {
          Navigator.of(context).pushReplacementNamed(_nextRoute);
        } else {
          setState(() {
            _error = true;
            _pin = '';
          });
          _shakeController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = _member;
    final bgColor = member != null
        ? AppColors.getCategoryBg(member.avatarColorIndex)
        : AppColors.primaryLight;
    final textColor = member != null
        ? AppColors.getCategoryText(member.avatarColorIndex)
        : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.of(context).pushReplacementNamed('/select-profile'),
              ),
            ),
            const Spacer(),
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  member?.initials ?? '??',
                  style: AppTypography.heading24.copyWith(color: textColor),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              member?.name ?? 'Utilisateur',
              style: AppTypography.heading18.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // PIN dots
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                final offset = _shakeAnimation.value * 12 *
                    ((_shakeController.value * 6).toInt().isEven ? 1 : -1);
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _pin.length;
                  return Container(
                    width: 16,
                    height: 16,
                    margin: EdgeInsets.only(right: i < 3 ? 16 : 0),
                    decoration: BoxDecoration(
                      color: _error
                          ? AppColors.error
                          : filled
                              ? AppColors.primary
                              : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _error
                            ? AppColors.error
                            : filled
                                ? AppColors.primary
                                : AppColors.border,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (_error) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                'Code incorrect',
                style: AppTypography.body13.copyWith(color: AppColors.error),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              'PIN par défaut: 1234',
              style: AppTypography.body12.copyWith(color: AppColors.textMuted),
            ),
            const Spacer(),
            // Keypad
            _buildKeypad(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'delete'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      child: Column(
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                if (key.isEmpty) {
                  return const SizedBox(width: 64, height: 64);
                }
                return _KeypadButton(
                  label: key,
                  onTap: () => _onKeyTap(key),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _KeypadButton extends StatefulWidget {
  const _KeypadButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    final isDelete = widget.label == 'delete';

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressing = true),
      onTapUp: (_) {
        setState(() => _pressing = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressing = false),
      child: AnimatedScale(
        scale: _pressing ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _pressing ? AppColors.primarySubtle : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: isDelete
                ? const Icon(Icons.backspace_outlined, size: 22, color: AppColors.textSecondary)
                : Text(
                    widget.label,
                    style: AppTypography.heading20.copyWith(color: AppColors.textPrimary),
                  ),
          ),
        ),
      ),
    );
  }
}
