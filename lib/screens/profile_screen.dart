import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return GlassScaffold(
      title: 'Profile & Reputation',
      body: SingleChildScrollView(
        padding: Responsive.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Identity Glass Card (Adaptive Column on Mobile, Row on Desktop)
                GlassContainer(
                  borderRadius: isMobile ? 20 : 24,
                  glowColor: GlassTheme.violetAccent,
                  padding: EdgeInsets.all(isMobile ? 20 : 28),
                  child: isMobile
                      ? Column(
                          children: [
                            _buildAvatar(),
                            const SizedBox(height: 16),
                            _buildUserInfo(isCenter: true),
                          ],
                        )
                      : Row(
                          children: [
                            _buildAvatar(),
                            const SizedBox(width: 24),
                            Expanded(child: _buildUserInfo(isCenter: false)),
                          ],
                        ),
                ),

                const SizedBox(height: 20),

                // Financials & Escrow Overview (Stacked on Mobile, Row on Desktop)
                ResponsiveRowColumn(
                  spacing: 16,
                  forceColumn: isMobile,
                  children: [
                    GlassContainer(
                      borderRadius: 20,
                      glowColor: GlassTheme.emeraldAccent,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Earnings',
                            style: TextStyle(
                              color: GlassTheme.op(Colors.white, 0.6),
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
                            '10% Platform fee auto-deducted',
                            style: TextStyle(
                              color: GlassTheme.op(Colors.white, 0.45),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GlassContainer(
                      borderRadius: 20,
                      glowColor: GlassTheme.cyanAccent,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Funds in Escrow',
                            style: TextStyle(
                              color: GlassTheme.op(Colors.white, 0.6),
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
                              color: GlassTheme.op(Colors.white, 0.45),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Verified Skills & Badges (Wrap for all screen widths)
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
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Flutter Web',
                          'Super Glass UI',
                          'Responsive Architecture',
                          'Dart 3.x',
                          'Escrow Smart Contracts',
                          'Stripe Connect',
                          'Stateful Animations',
                          'Figma to Code',
                        ].map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: GlassTheme.op(Colors.white, 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: GlassTheme.op(Colors.white, 0.18),
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

                const SizedBox(height: 28),

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

  Widget _buildAvatar() {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: GlassTheme.buttonGradient,
        border: Border.all(
          color: GlassTheme.op(Colors.white, 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: GlassTheme.op(GlassTheme.cyanAccent, 0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.person_rounded,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUserInfo({required bool isCenter}) {
    return Column(
      crossAxisAlignment:
          isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: isCenter ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            const Text(
              'Alex Mercer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: GlassTheme.op(GlassTheme.cyanAccent, 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GlassTheme.op(GlassTheme.cyanAccent, 0.4),
                ),
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
          textAlign: isCenter ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: 13,
            color: GlassTheme.op(Colors.white, 0.75),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: isCenter ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded,
                    color: GlassTheme.amberAccent, size: 17),
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
                    color: GlassTheme.op(Colors.white, 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined,
                    color: GlassTheme.op(Colors.white, 0.5), size: 15),
                const SizedBox(width: 4),
                Text(
                  'San Francisco, CA',
                  style: TextStyle(
                    color: GlassTheme.op(Colors.white, 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
