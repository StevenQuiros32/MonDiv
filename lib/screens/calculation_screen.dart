import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/wave_background.dart';

class CalculationScreen extends StatelessWidget {
  const CalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: WaveBackground(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    BackIconButton(onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: 56),
                const Text(
                  'Cálculo Exacto',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const Text(
                  'Cálculo exacto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grayPlaceholder,
                    fontFamily: 'monospace',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.people.length,
                    itemBuilder: (context, index) {
                      final person = state.people[index];
                      return _CalcCard(
                        name: person.name,
                        amount: person.amount,
                        canAdjust: state.people.length >= 2,
                        onPlus: () =>
                            context.read<AppState>().adjustPerson(person.id, 1),
                        onMinus: person.amount > 0
                            ? () =>
                                context.read<AppState>().adjustPerson(person.id, -1)
                            : null,
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.tealDark,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Total repartido: ${AppState.formatMoney(state.totalRepartido)}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalcCard extends StatelessWidget {
  final String name;
  final double amount;
  final bool canAdjust;
  final VoidCallback? onPlus;
  final VoidCallback? onMinus;

  const _CalcCard({
    required this.name,
    required this.amount,
    required this.canAdjust,
    required this.onPlus,
    required this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 1),
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grayBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              AppState.formatMoney(amount),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CalcButton(
                icon: Icons.add,
                background: AppColors.successBg,
                foreground: AppColors.successInk,
                onPressed: canAdjust ? onPlus : null,
              ),
              const SizedBox(height: 6),
              _CalcButton(
                icon: Icons.remove,
                background: AppColors.dangerBg,
                foreground: AppColors.dangerInk,
                onPressed: canAdjust ? onMinus : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalcButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  const _CalcButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 30,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background.withValues(alpha: enabled ? 1 : 0.4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: foreground),
      ),
    );
  }
}
