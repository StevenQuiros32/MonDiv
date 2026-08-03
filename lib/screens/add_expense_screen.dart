import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/common_widgets.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _nameError;
  String? _amountError;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    final editing = state.expenseBeingEdited;
    if (editing != null) {
      _isEditing = true;
      _nameController.text = editing.name;
      _amountController.text = editing.amount.toStringAsFixed(
          editing.amount.truncateToDouble() == editing.amount ? 0 : 2);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    setState(() {
      _nameError = name.isEmpty ? 'Nombre inválido' : null;
      _amountError = (amount == null || amount <= 0) ? 'Monto inválido' : null;
    });

    if (_nameError != null || _amountError != null) return;

    final state = context.read<AppState>();
    if (_isEditing) {
      final editing = state.expenseBeingEdited!;
      state.updateExpense(editing.id, name, amount!);
    } else {
      state.addExpense(name, amount!);
    }
    state.stopEditingExpense();
    Navigator.of(context).pop();
  }

  void _goBack() {
    context.read<AppState>().stopEditingExpense();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackIconButton(onPressed: _goBack),
              ),
              const SizedBox(height: 6),
              Text(
                _isEditing ? 'Editar gasto' : 'Añadir gasto',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.teal,
                ),
              ),
              const SizedBox(height: 22),
              AppTextField(
                controller: _nameController,
                placeholder: 'Nombre del gasto',
                maxLength: 30,
              ),
              FieldError(message: _nameError ?? ''),
              AppTextField(
                controller: _amountController,
                placeholder: 'Monto',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              FieldError(message: _amountError ?? ''),
              const Spacer(),
              PrimaryButton(
                label: _isEditing ? 'Guardar cambios' : 'Guardar',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
