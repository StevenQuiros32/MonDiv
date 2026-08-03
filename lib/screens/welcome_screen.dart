import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/app_colors.dart';
import '../widgets/common_widgets.dart';
import '../widgets/wave_background.dart';
import 'add_person_screen.dart';
import 'expenses_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                const SizedBox(height: 78), // espacio para no chocar con la ola
                const Text(
                  '¡Bienvenido!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AddPillButton(
                    label: 'Añadir persona',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddPersonScreen()),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: state.people.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Aún no has añadido a nadie. Toca "Añadir persona" para empezar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.grayPlaceholder,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: state.people.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final person = state.people[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.ink, width: 2),
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColors.ink,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person,
                                        color: AppColors.white, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      person.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        context.read<AppState>().removePerson(person.id),
                                    icon: const Icon(Icons.delete_outline,
                                        color: AppColors.ink),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: 'Siguiente',
                  onPressed: state.canGoToExpenses
                      ? () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                          )
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
