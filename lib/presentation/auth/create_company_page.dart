import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/ps_app_bar.dart';
import '../../core/widgets/ps_button.dart';
import '../../core/widgets/ps_card.dart';
import '../../core/widgets/ps_input.dart';

/// A3 — Create Company: company name, your name, PIN setup.
class CreateCompanyPage extends StatefulWidget {
  const CreateCompanyPage({super.key});

  @override
  State<CreateCompanyPage> createState() => _CreateCompanyPageState();
}

class _CreateCompanyPageState extends State<CreateCompanyPage> {
  final _companyCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final List<TextEditingController> _pinCtrls = List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> _confirmCtrls = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmFocusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    _companyCtrl.dispose();
    _nameCtrl.dispose();
    for (final c in _pinCtrls) { c.dispose(); }
    for (final c in _confirmCtrls) { c.dispose(); }
    for (final f in _pinFocusNodes) { f.dispose(); }
    for (final f in _confirmFocusNodes) { f.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PSAppBar(title: 'Créer mon entreprise', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: PSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PSInput(
                    controller: _companyCtrl,
                    label: 'Nom de l\'entreprise',
                    hint: 'Ex: PortLog Algérie',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PSInput(
                    controller: _nameCtrl,
                    label: 'Votre nom',
                    hint: 'Prénom et nom',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Code PIN', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPinRow(_pinCtrls, _pinFocusNodes),
                  const SizedBox(height: AppSpacing.base),
                  Text('Confirmer le code PIN', style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  _buildPinRow(_confirmCtrls, _confirmFocusNodes),
                  const SizedBox(height: AppSpacing.xxl),
                  PSButton(
                    label: 'Créer',
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/select-profile');
                    },
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinRow(List<TextEditingController> controllers, List<FocusNode> focusNodes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Container(
          width: 56,
          height: 56,
          margin: EdgeInsets.only(right: i < 3 ? AppSpacing.md : 0),
          child: TextField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            obscureText: true,
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            style: AppTypography.heading20.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
            onChanged: (val) {
              if (val.isNotEmpty && i < 3) {
                focusNodes[i + 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
