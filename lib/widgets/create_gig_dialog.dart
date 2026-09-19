import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_text_field.dart';
import '../services/gig_store.dart';

class CreateGigDialog extends StatefulWidget {
  const CreateGigDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => const CreateGigDialog(),
    );
  }

  @override
  State<CreateGigDialog> createState() => _CreateGigDialogState();
}

class _CreateGigDialogState extends State<CreateGigDialog> {
  final _titleController = TextEditingController();
  final _budgetController = TextEditingController(text: '400');
  final _descController = TextEditingController();

  String _selectedCategory = 'Flutter Development';
  String _selectedDelivery = '3-5 Days';

  final List<String> _categories = [
    'Flutter Development',
    'Glass UI Design',
    'Mobile Apps',
    'AI Services',
    'Backend & Security',
  ];

  final List<String> _timelines = [
    '24 Hours',
    '3-5 Days',
    '1 Week',
    '2-3 Weeks',
  ];

  double get _budget => double.tryParse(_budgetController.text) ?? 0.0;
  double get _fee => _budget * 0.10;
  double get _netPayout => _budget - _fee;

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitGig() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a gig title')),
      );
      return;
    }

    GigStore().addGig(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      budget: _budget,
      deliveryTime: _selectedDelivery,
      description: _descController.text.trim().isEmpty
          ? 'No description provided.'
          : _descController.text.trim(),
      tags: [_selectedCategory, 'Verified Gig'],
    );

    Navigator.of(context).pop();

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
                  'Gig "${_titleController.text.trim()}" posted successfully!',
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: GlassContainer(
          borderRadius: 28,
          glowColor: GlassTheme.cyanAccent,
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: GlassTheme.buttonGradient,
                          ),
                          child: const Icon(Icons.add_task_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Post a New Gig',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Gig Title / Service Name',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                GlassTextField(
                  controller: _titleController,
                  hintText: 'e.g., Build responsive glassmorphic portfolio',
                  prefixIcon: Icons.title_rounded,
                ),

                const SizedBox(height: 16),

                // Category Selection
                const Text(
                  'Category',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((c) {
                    final isSel = _selectedCategory == c;
                    return InkWell(
                      onTap: () => setState(() => _selectedCategory = c),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSel
                              ? GlassTheme.op(GlassTheme.cyanAccent, 0.22)
                              : GlassTheme.op(Colors.white, 0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSel
                                ? GlassTheme.cyanAccent
                                : GlassTheme.op(Colors.white, 0.15),
                          ),
                        ),
                        child: Text(
                          c,
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
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Budget & Timeline
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Budget Amount (\$)',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          GlassTextField(
                            controller: _budgetController,
                            hintText: '400',
                            prefixIcon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Time',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: GlassTheme.op(Colors.white, 0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: GlassTheme.op(Colors.white, 0.18),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedDelivery,
                                dropdownColor: const Color(0xFF131B2E),
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white70),
                                isExpanded: true,
                                style: const TextStyle(color: Colors.white),
                                items: _timelines
                                    .map((t) => DropdownMenuItem(
                                        value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => _selectedDelivery = v);
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

                const SizedBox(height: 16),

                // Platform Fee Preview Strip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: GlassTheme.op(GlassTheme.violetAccent, 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: GlassTheme.op(GlassTheme.violetAccent, 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '10% Platform Fee: -\$${_fee.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: GlassTheme.op(Colors.white, 0.75),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Freelancer Payout: \$${_netPayout.toStringAsFixed(1)}',
                        style: const TextStyle(
                          color: GlassTheme.emeraldAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  'Gig Description & Requirements',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                GlassTextField(
                  controller: _descController,
                  hintText: 'Briefly explain what you need delivered...',
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                // Submit Button
                GlassButton(
                  text: 'Publish Gig Listing',
                  icon: Icons.rocket_launch_rounded,
                  onPressed: _submitGig,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
