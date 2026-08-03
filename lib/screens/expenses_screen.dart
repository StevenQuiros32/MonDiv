import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../state/app_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/wave_background.dart';
import 'add_expense_screen.dart';
import 'calculation_screen.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: WaveBackground(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 12, 26, 26),
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
                  'Gastos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AddPillButton(
                    label: 'Añadir gastos',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ink, width: 2),
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: state.expenses.isEmpty
                        ? const Center(
                            child: Text(
                              'Aún no has añadido gastos.',
                              style: TextStyle(
                                color: AppColors.grayPlaceholder,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: state.expenses.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1, color: Color(0xFFCCCCCC)),
                            itemBuilder: (context, index) {
                              final expense = state.expenses[index];
                              return _ExpenseLine(expense: expense);
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Calcular',
                  icon: Icons.calculate_outlined,
                  onPressed: state.canCalculate
                      ? () {
                          context.read<AppState>().calculate();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CalculationScreen()),
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseLine extends StatelessWidget {
  final Expense expense;
  const _ExpenseLine({required this.expense});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.teal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long, color: AppColors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      expense.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    if (expense.qty > 1)
                      Text(
                        '${AppState.formatMoney(expense.amount)} c/u',
                        style: const TextStyle(
                          color: AppColors.grayPlaceholder,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppState.formatMoney(expense.lineTotal),
                style: const TextStyle(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.grayBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onPressed: expense.qty > 1
                          ? () => state.changeExpenseQty(expense.id, -1)
                          : null,
                    ),
                    SizedBox(
                      width: 26,
                      child: Text(
                        '${expense.qty}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onPressed: () => state.changeExpenseQty(expense.id, 1),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.edit_outlined, size: 19, color: AppColors.ink),
                    onPressed: () {
                      state.startEditingExpense(expense.id);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete_outline,
                        size: 19, color: AppColors.dangerInk),
                    onPressed: () => state.removeExpense(expense.id),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.teal.withValues(alpha: enabled ? 1 : 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.white),
      ),
    );
  }
}
