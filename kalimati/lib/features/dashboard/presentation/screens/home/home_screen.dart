import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalimati/core/navigations/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.primaryContainer.withOpacity(.35), color.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- Logo + Title ---
                    const SizedBox(height: 24),
                    _AppLogo(),
                    const SizedBox(height: 16),
                    Text(
                      'Kalimati',
                      textAlign: TextAlign.center,
                      //nice fonts: coiny, gluten, aleo, barlow, comforter, battambang
                      style: GoogleFonts.crushed(
                        fontSize: 50,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .5,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Language Made Simple and Fun!🐰',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- Role cards ---
                    LayoutBuilder(
                      builder: (ctx, c) {
                        // final isWide = c.maxWidth > 700;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _RoleCard(
                              title: 'Student',
                              subtitle: 'Browse & practice learning packages',
                              icon: Icons.school_outlined,
                              color: color.primary,
                              onTap: () {
                                context.goNamed(Routes.studentHomePage);
                              },
                            ),
                            _RoleCard(
                              title: 'Teacher',
                              subtitle: 'Create, edit, and publish packages',
                              icon: Icons.person_outline,
                              color: color.tertiary,
                              onTap: () {
                                context.goNamed(Routes.teacherLogin);
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final color = Theme.of(context).colorScheme;
    // If you later add a real logo asset, swap this Container with Image.asset('assets/logo.png', height: 84)
    return Container(
      height: 150, // make it a bit larger
      width: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 205, 168, 232),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBB86FC).withOpacity(0.4), // lavender glow
            blurRadius: 10,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(
          'assets/images/kalimati_logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 400, //////////////////////////////////////////////////
        height: 100,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withOpacity(.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: scheme.outlineVariant.withOpacity(.6)),
        ),
        child: Row(
          children: [
            Container(
              height:
                  50, //////ICON CONTAINER SIZE////////////////////////////////////////////
              width: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ), //////////////////////////////////////////////////
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize:
                          25, //////////////////////////////////////////////////
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize:
                          15.5, //////////////////////////////////////////////
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 26),
          ],
        ),
      ),
    );
  }
}
