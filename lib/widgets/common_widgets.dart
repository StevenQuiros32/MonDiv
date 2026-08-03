import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Equivalente a .btn-primary
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.teal.withValues(alpha: 0.5),
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.9),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

/// Equivalente a .pill-btn-outline (botón "Añadir persona" / "Añadir gastos")
class AddPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddPillButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 20, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.grayBg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.teal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Equivalente a .field
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextInputType keyboardType;
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 17,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: placeholder,
        hintStyle: const TextStyle(color: AppColors.grayPlaceholder),
        filled: true,
        fillColor: AppColors.grayBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
      ),
    );
  }
}

/// Texto de error bajo un campo (equivalente a .field-error)
class FieldError extends StatelessWidget {
  final String message;
  const FieldError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 14, left: 6),
      child: SizedBox(
        height: 18,
        child: Text(
          message,
          style: const TextStyle(
            color: AppColors.dangerInk,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Equivalente a .back-btn
class BackIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  const BackIconButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.ink),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
