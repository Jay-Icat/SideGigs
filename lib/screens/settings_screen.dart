import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_scaffold.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _ambientGlow = true;
  bool _emailNotifications = true;
  bool _offerAlerts = true;
  double _platformFeePercentage = 10.0;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'Settings & Preferences',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Platform Commission Rules Section
                GlassContainer(
                  borderRadius: 22,
                  glowColor: GlassTheme.violetAccent,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: GlassTheme.accentGradient,
                            ),
                            child: const Icon(Icons.percent_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Platform Fee & Revenue Share',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Transparent commission charged upon contract settlement',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Current Platform Commission:',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: GlassTheme.violetAccent.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: GlassTheme.violetAccent.withOpacity(0.5)),
                            ),
                            child: Text(
                              '${_platformFeePercentage.toStringAsFixed(0)}% Platform Fee',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: GlassTheme.cyanAccent,
                          inactiveTrackColor: Colors.white12,
                          thumbColor: GlassTheme.cyanAccent,
                        ),
                        child: Slider(
                          value: _platformFeePercentage,
                          min: 5.0,
                          max: 20.0,
                          divisions: 15,
                          label: '${_platformFeePercentage.toStringAsFixed(0)}%',
                          onChanged: (v) =>
                              setState(() => _platformFeePercentage = v),
                        ),
                      ),
                      Text(
                        'This percentage is automatically deducted from gig payouts to support marketplace escrow security and maintenance.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Super Glass UI Aesthetics Section
                GlassContainer(
                  borderRadius: 22,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: GlassTheme.buttonGradient,
                            ),
                            child: const Icon(Icons.blur_on_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Super Glass UI Effects',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Configure ambient luminescence & blur performance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Dynamic Ambient Mesh Orbs',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text('Animate glowing light blobs behind glass',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12)),
                        value: _ambientGlow,
                        activeColor: GlassTheme.cyanAccent,
                        onChanged: (v) => setState(() => _ambientGlow = v),
                      ),
                      Divider(color: Colors.white.withOpacity(0.1)),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Real-Time Offer Push Notifications',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            'Receive instant pings when an offer is countered or accepted',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12)),
                        value: _offerAlerts,
                        activeColor: GlassTheme.cyanAccent,
                        onChanged: (v) => setState(() => _offerAlerts = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Account & Session
                GlassContainer(
                  borderRadius: 22,
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Session & Security',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Logged in as alex.creator@sidegigs.dev',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      GlassButton(
                        text: 'Sign Out',
                        icon: Icons.logout_rounded,
                        isPrimary: false,
                        textColor: Colors.redAccent,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Back to Home
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: GlassButton(
                      text: 'Back to Home',
                      icon: Icons.arrow_back_rounded,
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
