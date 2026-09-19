import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../models/gig_model.dart';
import '../services/gig_store.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/glass_scaffold.dart';
import '../widgets/create_gig_dialog.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'post_gigs_screen.dart';
import 'get_gigs_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GigStore _gigStore = GigStore();
  String _activeFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All',
    'Glass UI Design',
    'Flutter Development',
    'AI Services',
    'Mobile & Web Apps',
    'Backend & Security',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _nav(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _showNegotiateModal(Gig gig) {
    final counterController =
        TextEditingController(text: (gig.budget + 50).toStringAsFixed(0));
    final noteController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final counterAmt =
                double.tryParse(counterController.text) ?? gig.budget;
            final fee = counterAmt * 0.10;
            final payout = counterAmt - fee;

            return Dialog(
              backgroundColor: Colors.transparent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: GlassContainer(
                  borderRadius: 26,
                  glowColor: GlassTheme.cyanAccent,
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: GlassTheme.accentGradient,
                            ),
                            child: const Icon(Icons.handshake_outlined,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              'Negotiate Gig Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Original Budget Set by Poster: \$${gig.budget.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: GlassTheme.op(Colors.white, 0.7),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Your Proposed Counter Amount (\$)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassTextField(
                        controller: counterController,
                        hintText: 'Enter counter amount',
                        prefixIcon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 12),
                      // Fee breakdown
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: GlassTheme.op(Colors.white, 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: GlassTheme.op(Colors.white, 0.12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Platform Fee (10%): -\$${fee.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: GlassTheme.op(Colors.white, 0.65),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Your Payout: \$${payout.toStringAsFixed(1)}',
                              style: const TextStyle(
                                color: GlassTheme.emeraldAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Negotiation Note / Scope Justification',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassTextField(
                        controller: noteController,
                        hintText: 'Why this counter-offer fits the requirements...',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: GlassButton(
                              text: 'Submit Counter-Offer',
                              icon: Icons.send_rounded,
                              onPressed: () {
                                _gigStore.negotiateGig(
                                  gig.id,
                                  counterAmt,
                                  noteController.text.trim(),
                                );
                                Navigator.of(ctx).pop();
                                _showToast(
                                  'Counter-offer of \$${counterAmt.toStringAsFixed(0)} submitted to ${gig.posterName}!',
                                  GlassTheme.cyanAccent,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          GlassButton(
                            text: 'Cancel',
                            isPrimary: false,
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showToast(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassContainer(
          borderRadius: 16,
          glowColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      showBackButton: false,
      body: Column(
        children: [
          // 1. Top Glass Navigation Bar
          _buildProperNavBar(context),

          // 2. Main Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Basic Gig Poster Banner CTA
                      _buildGigPosterBanner(context),

                      const SizedBox(height: 24),

                      // Platform Metrics Glass Ribbon
                      _buildMetricsRibbon(),

                      const SizedBox(height: 28),

                      // Marketplace Demo Gigs Header & Filters
                      _buildDemoGigsHeader(),

                      const SizedBox(height: 18),

                      // Live Demo Gigs List
                      ListenableBuilder(
                        listenable: _gigStore,
                        builder: (context, _) {
                          final filtered = _gigStore.gigs.where((g) {
                            final matchCat = _activeFilter == 'All' ||
                                g.category == _activeFilter;
                            final matchQuery = _searchQuery.isEmpty ||
                                g.title
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) ||
                                g.description
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase());
                            return matchCat && matchQuery;
                          }).toList();

                          if (filtered.isEmpty) {
                            return GlassContainer(
                              borderRadius: 20,
                              padding: const EdgeInsets.all(40),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(Icons.inbox_outlined,
                                        size: 48, color: Colors.white38),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'No gigs found for this filter',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 16),
                                    GlassButton(
                                      text: 'Post the First One',
                                      icon: Icons.add_rounded,
                                      onPressed: () =>
                                          CreateGigDialog.show(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 18),
                            itemBuilder: (context, idx) {
                              return _buildDemoGigCard(filtered[idx]);
                            },
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
        ],
      ),
    );
  }

  // Proper Glass Navigation Bar
  Widget _buildProperNavBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: GlassTheme.op(Colors.white, 0.07),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: GlassTheme.op(Colors.white, 0.16),
          width: 1.2,
        ),
        boxShadow: GlassTheme.glassShadow(),
      ),
      child: Row(
        children: [
          // Logo & Brand
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: GlassTheme.buttonGradient,
                  ),
                  child: const Icon(Icons.work_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'SideGigs',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Center Navigation Tabs
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildNavTab(
                    label: 'Feed',
                    icon: Icons.home_rounded,
                    isActive: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 6),
                  _buildNavTab(
                    label: 'Get Gigs',
                    icon: Icons.explore_outlined,
                    isActive: false,
                    onTap: () => _nav(context, const GetGigsScreen()),
                  ),
                  const SizedBox(width: 6),
                  _buildNavTab(
                    label: 'Post Gigs',
                    icon: Icons.add_circle_outline_rounded,
                    isActive: false,
                    onTap: () => _nav(context, const PostGigsScreen()),
                  ),
                  const SizedBox(width: 6),
                  _buildNavTab(
                    label: 'Profile',
                    icon: Icons.person_outline_rounded,
                    isActive: false,
                    onTap: () => _nav(context, const ProfileScreen()),
                  ),
                  const SizedBox(width: 6),
                  _buildNavTab(
                    label: 'Settings',
                    icon: Icons.tune_rounded,
                    isActive: false,
                    onTap: () => _nav(context, const SettingsScreen()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // "+ Post Gig" CTA Button in Navigation
          GlassButton(
            text: 'Post a Gig',
            icon: Icons.add_rounded,
            height: 40,
            borderRadius: 14,
            onPressed: () => CreateGigDialog.show(context),
          ),

          const SizedBox(width: 10),

          // User Profile Pill & Sign Out
          PopupMenuButton<String>(
            tooltip: 'User Menu',
            color: const Color(0xFF131B2E),
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: GlassTheme.op(Colors.white, 0.15)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: GlassTheme.op(Colors.white, 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GlassTheme.op(Colors.white, 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: GlassTheme.accentGradient,
                    ),
                    child: const Center(
                      child: Text('A',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Alex',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70, size: 16),
                ],
              ),
            ),
            onSelected: (val) {
              if (val == 'profile') _nav(context, const ProfileScreen());
              if (val == 'settings') _nav(context, const SettingsScreen());
              if (val == 'logout') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.white70, size: 18),
                    SizedBox(width: 10),
                    Text('My Profile & Wallet'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined,
                        color: Colors.white70, size: 18),
                    SizedBox(width: 10),
                    Text('Platform Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded,
                        color: Colors.redAccent, size: 18),
                    SizedBox(width: 10),
                    Text('Log Out', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? GlassTheme.op(GlassTheme.cyanAccent, 0.20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? GlassTheme.op(GlassTheme.cyanAccent, 0.5)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? GlassTheme.cyanAccent
                  : GlassTheme.op(Colors.white, 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : GlassTheme.op(Colors.white, 0.7),
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Basic Gig Poster Banner
  Widget _buildGigPosterBanner(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      glowColor: GlassTheme.cyanAccent,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: GlassTheme.buttonGradient,
              boxShadow: [
                BoxShadow(
                  color: GlassTheme.op(GlassTheme.cyanAccent, 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.flash_on_rounded,
                color: Colors.white, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Post a Gig or Offer a Service',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set your budget amount. Applicants can accept, propose counter-offers, or reject. SideGigs takes a 10% platform fee on settlement.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: GlassTheme.op(Colors.white, 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GlassButton(
            text: 'Create Gig Listing',
            icon: Icons.rocket_launch_rounded,
            onPressed: () => CreateGigDialog.show(context),
          ),
        ],
      ),
    );
  }

  // Metrics Ribbon
  Widget _buildMetricsRibbon() {
    return ListenableBuilder(
      listenable: _gigStore,
      builder: (context, _) {
        return GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Active Marketplace Gigs',
                  '${_gigStore.totalGigsCount}', GlassTheme.cyanAccent),
              _buildDivider(),
              _buildMetricItem(
                  'Under Negotiation',
                  '${_gigStore.activeNegotiationsCount}',
                  GlassTheme.amberAccent),
              _buildDivider(),
              _buildMetricItem('Platform Fee', '10%', GlassTheme.violetAccent),
              _buildDivider(),
              _buildMetricItem(
                  'Protected Escrow',
                  '\$${_gigStore.totalEscrowAmount.toStringAsFixed(0)}',
                  GlassTheme.emeraldAccent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: GlassTheme.op(Colors.white, 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 34,
      color: GlassTheme.op(Colors.white, 0.12),
    );
  }

  // Demo Gigs Header & Filters
  Widget _buildDemoGigsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Demo Gigs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Test accepting, negotiating counter-offers, and posting real-time gigs below',
                  style: TextStyle(
                    fontSize: 13,
                    color: GlassTheme.op(Colors.white, 0.65),
                  ),
                ),
              ],
            ),
            // Search field
            SizedBox(
              width: 260,
              child: GlassTextField(
                controller: _searchController,
                hintText: 'Search gigs...',
                prefixIcon: Icons.search_rounded,
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _filters.map((f) {
              final isSel = _activeFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _activeFilter = f),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSel
                          ? GlassTheme.op(GlassTheme.cyanAccent, 0.22)
                          : GlassTheme.op(Colors.white, 0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSel
                            ? GlassTheme.cyanAccent
                            : GlassTheme.op(Colors.white, 0.15),
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: isSel
                            ? Colors.white
                            : GlassTheme.op(Colors.white, 0.7),
                        fontWeight:
                            isSel ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Demo Gig Card
  Widget _buildDemoGigCard(Gig gig) {
    return GlassContainer(
      borderRadius: 22,
      glowColor: gig.status == 'accepted'
          ? GlassTheme.emeraldAccent
          : gig.status == 'countered'
              ? GlassTheme.cyanAccent
              : null,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Poster info + Category + Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: GlassTheme.buttonGradient,
                    ),
                    child: Center(
                      child: Text(
                        gig.posterAvatar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    gig.posterName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    gig.posterRating,
                    style: const TextStyle(
                      color: GlassTheme.amberAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: GlassTheme.op(GlassTheme.violetAccent, 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      gig.category,
                      style: const TextStyle(
                        color: GlassTheme.violetAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              _buildStatusTag(gig),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            gig.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          // Description
          Text(
            gig.description,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: GlassTheme.op(Colors.white, 0.75),
            ),
          ),

          const SizedBox(height: 12),

          // Tags & Timeline
          Row(
            children: [
              Icon(Icons.timer_outlined,
                  size: 15, color: GlassTheme.op(Colors.white, 0.5)),
              const SizedBox(width: 4),
              Text(
                'Delivery: ${gig.deliveryTime}',
                style: TextStyle(
                  fontSize: 12,
                  color: GlassTheme.op(Colors.white, 0.6),
                ),
              ),
              const SizedBox(width: 16),
              ...gig.tags.take(3).map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: GlassTheme.op(Colors.white, 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        color: GlassTheme.op(Colors.white, 0.55),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Budget & Platform Fee Transparency Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: GlassTheme.op(Colors.white, 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: GlassTheme.op(Colors.white, 0.12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Set Amount',
                        style: TextStyle(
                            fontSize: 11,
                            color: GlassTheme.op(Colors.white, 0.5))),
                    Text('\$${gig.budget.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Platform Fee (10%)',
                        style: TextStyle(
                            fontSize: 11,
                            color: GlassTheme.op(Colors.white, 0.5))),
                    Text('-\$${gig.platformFee.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: GlassTheme.amberAccent)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Net Freelancer Payout',
                        style: TextStyle(
                            fontSize: 11,
                            color: GlassTheme.op(Colors.white, 0.5))),
                    Text('\$${gig.netPayout.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: GlassTheme.emeraldAccent)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3 Primary Actions: Accept / Negotiate / Decline
          if (gig.status == 'open') ...[
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    text: 'Accept (\$${gig.budget.toStringAsFixed(0)})',
                    icon: Icons.check_rounded,
                    height: 42,
                    gradient: GlassTheme.emeraldGradient,
                    onPressed: () {
                      _gigStore.acceptGig(gig.id);
                      _showToast(
                        'Gig accepted! \$${gig.budget.toStringAsFixed(0)} funded into escrow.',
                        GlassTheme.emeraldAccent,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GlassButton(
                    text: 'Negotiate Amount',
                    icon: Icons.handshake_outlined,
                    height: 42,
                    isPrimary: false,
                    textColor: GlassTheme.cyanAccent,
                    onPressed: () => _showNegotiateModal(gig),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  tooltip: 'Decline Gig',
                  icon: Icon(Icons.close_rounded,
                      color: Colors.redAccent.withValues(alpha: 0.8),
                      size: 20),
                  onPressed: () {
                    _gigStore.declineGig(gig.id);
                    _showToast('Gig declined.', Colors.redAccent);
                  },
                ),
              ],
            ),
          ] else if (gig.status == 'countered') ...[
            Row(
              children: [
                const Icon(Icons.hourglass_top_rounded,
                    color: GlassTheme.cyanAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Counter-offer of \$${gig.counterAmount?.toStringAsFixed(0)} proposed (Net: \$${gig.counterNetPayout.toStringAsFixed(0)}). Awaiting response.',
                  style: const TextStyle(
                    color: GlassTheme.cyanAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ] else if (gig.status == 'accepted') ...[
            Row(
              children: [
                const Icon(Icons.verified_user_rounded,
                    color: GlassTheme.emeraldAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Escrow Protected: \$${gig.budget.toStringAsFixed(0)} locked. 10% fee applied on payout.',
                  style: const TextStyle(
                    color: GlassTheme.emeraldAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Declined',
              style: TextStyle(
                color: GlassTheme.op(Colors.white, 0.4),
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusTag(Gig gig) {
    Color color;
    String label;

    switch (gig.status) {
      case 'accepted':
        color = GlassTheme.emeraldAccent;
        label = 'Escrow Funded';
        break;
      case 'countered':
        color = GlassTheme.cyanAccent;
        label = 'In Negotiation';
        break;
      case 'declined':
        color = Colors.redAccent;
        label = 'Declined';
        break;
      default:
        color = GlassTheme.amberAccent;
        label = 'Open for Offers';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: GlassTheme.op(color, 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GlassTheme.op(color, 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
