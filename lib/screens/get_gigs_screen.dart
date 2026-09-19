import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../models/gig_model.dart';
import '../services/gig_store.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/glass_scaffold.dart';
import '../widgets/create_gig_dialog.dart';
import '../utils/responsive.dart';

class GetGigsScreen extends StatefulWidget {
  const GetGigsScreen({super.key});

  @override
  State<GetGigsScreen> createState() => _GetGigsScreenState();
}

class _GetGigsScreenState extends State<GetGigsScreen> {
  final GigStore _store = GigStore();
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  void _showNegotiateDialog(Gig gig) {
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
                        hintText: 'Enter counter offer',
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
                        'Reason / Proposal Note',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassTextField(
                        controller: noteController,
                        hintText:
                            'Explain why this price reflects the scope, quality, or speed...',
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
                                _store.negotiateGig(
                                  gig.id,
                                  counterAmt,
                                  noteController.text.trim(),
                                );
                                Navigator.of(ctx).pop();
                                _showToast(
                                  'Counter-offer of \$${counterAmt.toStringAsFixed(0)} sent to ${gig.posterName}!',
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
    final isMobile = Responsive.isMobile(context);

    return GlassScaffold(
      title: 'Get Gigs / Marketplace',
      actions: [
        IconButton(
          tooltip: 'Post a Gig',
          icon: const Icon(Icons.add_circle_outline_rounded,
              color: GlassTheme.cyanAccent, size: 22),
          onPressed: () => CreateGigDialog.show(context),
        ),
      ],
      body: SingleChildScrollView(
        padding: Responsive.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search & Filter Header (Responsive)
                if (isMobile) ...[
                  GlassTextField(
                    controller: _searchController,
                    hintText: 'Search gigs by skill, title, or client...',
                    prefixIcon: Icons.search_rounded,
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                  const SizedBox(height: 10),
                  GlassButton(
                    text: '+ Post a New Gig',
                    icon: Icons.add_rounded,
                    height: 44,
                    onPressed: () => CreateGigDialog.show(context),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: GlassTextField(
                          controller: _searchController,
                          hintText:
                              'Search marketplace gigs by skill, title, or client...',
                          prefixIcon: Icons.search_rounded,
                          onChanged: (v) => setState(() => _searchQuery = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GlassButton(
                        text: '+ Post Gig',
                        icon: Icons.add_rounded,
                        height: 48,
                        onPressed: () => CreateGigDialog.show(context),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final isSel = _selectedCategory == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _selectedCategory = f),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? GlassTheme.op(GlassTheme.cyanAccent, 0.22)
                                  : GlassTheme.op(Colors.white, 0.06),
                              borderRadius: BorderRadius.circular(20),
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
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Gigs Listing from Store
                ListenableBuilder(
                  listenable: _store,
                  builder: (context, _) {
                    final filtered = _store.gigs.where((g) {
                      final matchCat = _selectedCategory == 'All' ||
                          g.category == _selectedCategory;
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
                        padding: const EdgeInsets.all(36),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.inbox_outlined,
                                  size: 44, color: Colors.white38),
                              const SizedBox(height: 10),
                              const Text('No gigs matching this search.',
                                  style: TextStyle(color: Colors.white70)),
                              const SizedBox(height: 14),
                              GlassButton(
                                text: 'Post a New Gig',
                                icon: Icons.add_rounded,
                                onPressed: () => CreateGigDialog.show(context),
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
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        return _buildGigCard(filtered[idx]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGigCard(Gig gig) {
    final isMobile = Responsive.isMobile(context);

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
          // Row 1: Category, Client, Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  const SizedBox(width: 10),
                  Text(
                    'by ${gig.posterName}',
                    style: TextStyle(
                      color: GlassTheme.op(Colors.white, 0.7),
                      fontSize: 13,
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
                ],
              ),
              _buildStatusPill(gig),
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

          const SizedBox(height: 8),

          // Description
          Text(
            gig.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: GlassTheme.op(Colors.white, 0.75),
            ),
          ),

          const SizedBox(height: 16),

          // Price & Fee Breakdown Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: GlassTheme.op(Colors.white, 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: GlassTheme.op(Colors.white, 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gig Setter Budget',
                      style: TextStyle(
                        fontSize: 11,
                        color: GlassTheme.op(Colors.white, 0.5),
                      ),
                    ),
                    Text(
                      '\$${gig.budget.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Platform Fee (10%)',
                      style: TextStyle(
                        fontSize: 11,
                        color: GlassTheme.op(Colors.white, 0.5),
                      ),
                    ),
                    Text(
                      '-\$${gig.platformFee.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: GlassTheme.amberAccent,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Your Net Payout',
                      style: TextStyle(
                        fontSize: 11,
                        color: GlassTheme.op(Colors.white, 0.5),
                      ),
                    ),
                    Text(
                      '\$${gig.netPayout.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: GlassTheme.emeraldAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Action Buttons: Accept / Negotiate / Reject
          if (gig.status == 'open') ...[
            ResponsiveRowColumn(
              spacing: 8,
              forceColumn: isMobile,
              children: [
                GlassButton(
                  text: 'Accept (\$${gig.budget.toStringAsFixed(0)})',
                  icon: Icons.check_rounded,
                  height: 42,
                  gradient: GlassTheme.emeraldGradient,
                  onPressed: () {
                    _store.acceptGig(gig.id);
                    _showToast(
                      'Accepted! \$${gig.budget.toStringAsFixed(0)} secured in Escrow.',
                      GlassTheme.emeraldAccent,
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: GlassButton(
                        text: 'Negotiate',
                        icon: Icons.handshake_outlined,
                        height: 42,
                        isPrimary: false,
                        textColor: GlassTheme.cyanAccent,
                        onPressed: () => _showNegotiateDialog(gig),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Decline Gig',
                      icon: Icon(Icons.close_rounded,
                          color: Colors.redAccent.withValues(alpha: 0.8),
                          size: 20),
                      onPressed: () {
                        _store.declineGig(gig.id);
                        _showToast('Gig declined.', Colors.redAccent);
                      },
                    ),
                  ],
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
                  'Counter-offer of \$${gig.counterAmount?.toStringAsFixed(0)} submitted. Awaiting client review.',
                  style: const TextStyle(
                    color: GlassTheme.cyanAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ] else if (gig.status == 'accepted') ...[
            Row(
              children: [
                const Icon(Icons.verified_rounded,
                    color: GlassTheme.emeraldAccent, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Contract Active! Funds locked in Escrow.',
                  style: TextStyle(
                    color: GlassTheme.emeraldAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Declined by you',
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

  Widget _buildStatusPill(Gig gig) {
    Color color;
    String label;

    switch (gig.status) {
      case 'accepted':
        color = GlassTheme.emeraldAccent;
        label = 'Accepted';
        break;
      case 'countered':
        color = GlassTheme.cyanAccent;
        label = 'Countered';
        break;
      case 'declined':
        color = Colors.redAccent;
        label = 'Declined';
        break;
      default:
        color = GlassTheme.amberAccent;
        label = 'Open for Apply';
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
