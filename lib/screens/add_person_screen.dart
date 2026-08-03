import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/common_widgets.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _nameController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Nombre inválido');
      return;
    }
    context.read<AppState>().addPerson(name);
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
                child: BackIconButton(onPressed: () => Navigator.of(context).pop()),
              ),
              const SizedBox(height: 6),
              const Text(
                'Añadir persona',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.teal,
                ),
              ),
              const SizedBox(height: 22),
              AppTextField(
                controller: _nameController,
                placeholder: 'Nombre',
                maxLength: 30,
              ),
              FieldError(message: _error ?? ''),
              const Spacer(),
              PrimaryButton(label: 'Guardar', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
