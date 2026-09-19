import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../services/gig_store.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/glass_scaffold.dart';

class PostGigsScreen extends StatefulWidget {
  const PostGigsScreen({super.key});

  @override
  State<PostGigsScreen> createState() => _PostGigsScreenState();
}

class _PostGigsScreenState extends State<PostGigsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _budgetController =
      TextEditingController(text: '350');

  String _selectedCategory = 'Flutter Development';
  String _selectedTimeline = '3-5 Days';

  final List<String> _categories = [
    'Flutter Development',
    'Glass UI Design',
    'Full Stack Web',
    'Mobile Apps',
    'AI & Automation',
    'Video Editing',
  ];

  final List<String> _timelines = [
    '24 Hours',
    '3-5 Days',
    '1-2 Weeks',
    '1 Month',
  ];

  double get _budget => double.tryParse(_budgetController.text) ?? 0.0;
  double get _platformFee => _budget * 0.10; // 10% platform fee
  double get _freelancerPayout => _budget - _platformFee;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _publishGig() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a gig title')),
      );
      return;
    }

    GigStore().addGig(
      title: title,
      category: _selectedCategory,
      budget: _budget,
      deliveryTime: _selectedTimeline,
      description: _descController.text.trim().isEmpty
          ? 'No detailed description provided.'
          : _descController.text.trim(),
      tags: [_selectedCategory, 'Posted Gig'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: GlassContainer(
          borderRadius: 16,
          glowColor: GlassTheme.emeraldAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: GlassTheme.emeraldAccent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gig "$title" posted successfully! Added to live marketplace.',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      title: 'Post a Gig',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Card
                GlassContainer(
                  borderRadius: 22,
                  glowColor: GlassTheme.cyanAccent,
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlassTheme.buttonGradient,
                        ),
                        child: const Icon(Icons.add_task_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Create Service / Gig Listing',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Specify what you need done, set the proposed budget amount, and receive applications.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form Container
                GlassContainer(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gig Title
                      const Text(
                        'Gig Title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassTextField(
                        controller: _titleController,
                        hintText: 'e.g. Build Super Glass UI landing page in Flutter Web',
                        prefixIcon: Icons.title_rounded,
                      ),

                      const SizedBox(height: 22),

                      // Category Selector
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return InkWell(
                            onTap: () => setState(() => _selectedCategory = cat),
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? GlassTheme.cyanAccent.withOpacity(0.25)
                                    : Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? GlassTheme.cyanAccent
                                      : Colors.white.withOpacity(0.15),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 22),

                      // Budget & Delivery Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Budget Field
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gig Amount (\$ USD)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GlassTextField(
                                  controller: _budgetController,
                                  hintText: '350',
                                  prefixIcon: Icons.attach_money_rounded,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Expected Timeline
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Delivery Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedTimeline,
                                      dropdownColor: const Color(0xFF131B2E),
                                      icon: const Icon(Icons.arrow_drop_down,
                                          color: Colors.white70),
                                      isExpanded: true,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      items: _timelines.map((t) {
                                        return DropdownMenuItem(
                                          value: t,
                                          child: Text(t),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) {
                                          setState(() => _selectedTimeline = v);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Platform Fee Transparency Breakdown Card
                      GlassContainer(
                        borderRadius: 18,
                        glowColor: GlassTheme.violetAccent,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline_rounded,
                                        color: GlassTheme.violetAccent,
                                        size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Platform Fee Transparency (10%)',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: GlassTheme.violetAccent
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Standard Tier',
                                    style: TextStyle(
                                      color: GlassTheme.violetAccent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Divider(
                                color: Colors.white.withOpacity(0.1), height: 1),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Set Gig Amount:',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7))),
                                Text('\$${_budget.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('SideGigs Platform Fee (10%):',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7))),
                                Text('-\$${_platformFee.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: GlassTheme.amberAccent,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Net Freelancer Payout:',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                                Text('\$${_freelancerPayout.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: GlassTheme.emeraldAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Description
                      const Text(
                        'Detailed Requirements & Deliverables',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassTextField(
                        controller: _descController,
                        hintText:
                            'Describe what you are looking for, expected milestones, acceptance criteria, etc...',
                        maxLines: 5,
                      ),

                      const SizedBox(height: 30),

                      // Submit & Cancel Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GlassButton(
                              text: 'Publish Gig Listing',
                              icon: Icons.rocket_launch_rounded,
                              onPressed: _publishGig,
                            ),
                          ),
                          const SizedBox(width: 14),
                          GlassButton(
                            text: 'Back to Home',
                            isPrimary: false,
                            icon: Icons.arrow_back_rounded,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ],
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
