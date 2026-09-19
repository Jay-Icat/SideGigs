import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'Profile & Reputation',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Identity Glass Card
                GlassContainer(
                  borderRadius: 24,
                  glowColor: GlassTheme.violetAccent,
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlassTheme.buttonGradient,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: GlassTheme.cyanAccent.withOpacity(0.4),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Alex Mercer',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: GlassTheme.cyanAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: GlassTheme.cyanAccent
                                            .withOpacity(0.4)),
                                  ),
                                  child: const Text(
                                    'Verified Pro',
                                    style: TextStyle(
                                      color: GlassTheme.cyanAccent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Full Stack & Flutter Glass UI Specialist • Top Rated',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: GlassTheme.amberAccent, size: 18),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.98',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ' (64 reviews)',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(Icons.location_on_outlined,
                                    color: Colors.white54, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'San Francisco, CA (Remote)',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Financials & Escrow Overview
                Row(
                  children: [
                    Expanded(
                      child: GlassContainer(
                        borderRadius: 20,
                        glowColor: GlassTheme.emeraldAccent,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Earnings',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '\$3,840.00',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: GlassTheme.emeraldAccent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Platform fee auto-deducted',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GlassContainer(
                        borderRadius: 20,
                        glowColor: GlassTheme.cyanAccent,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Funds in Escrow',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '\$1,250.00',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: GlassTheme.cyanAccent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '2 milestones currently in progress',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Skills & Badges
                GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified Skills & Badges',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          'Flutter Web',
                          'Super Glass UI',
                          'Dart 3.x',
                          'Escrow Smart Contracts',
                          'Stripe Connect',
                          'Stateful Animations',
                          'Figma to Code',
                        ].map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                              ),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Return to Home CTA
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: GlassButton(
                      text: 'Return to Home',
                      icon: Icons.home_rounded,
                      isPrimary: false,
                      onPressed: () => Navigator.of(context).pop(),
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
