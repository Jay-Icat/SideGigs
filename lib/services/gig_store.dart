import 'package:flutter/material.dart';
import '../models/gig_model.dart';

class GigStore extends ChangeNotifier {
  static final GigStore _instance = GigStore._internal();
  factory GigStore() => _instance;

  GigStore._internal() {
    _loadInitialDemoGigs();
  }

  final List<Gig> _gigs = [];

  List<Gig> get gigs => List.unmodifiable(_gigs);

  int get totalGigsCount => _gigs.length;
  int get activeNegotiationsCount =>
      _gigs.where((g) => g.status == 'countered').length;
  double get totalEscrowAmount => _gigs
      .where((g) => g.status == 'accepted')
      .fold(0.0, (sum, g) => sum + g.budget);

  void _loadInitialDemoGigs() {
    _gigs.addAll([
      Gig(
        id: 'GIG-201',
        title: 'Craft Ultra Glass UI Dashboard for Web3 Crypto Portfolio',
        category: 'Glass UI Design',
        posterName: 'Elena Vance',
        posterAvatar: 'EV',
        posterRating: '4.95 ★',
        budget: 550.0,
        deliveryTime: '3 Days',
        description:
            'Need a master of Flutter & Figma glassmorphism to design a sleek, translucent dark dashboard with ambient glowing orbs and live price tickers.',
        tags: ['Flutter Web', 'Glassmorphism', 'Figma', 'Fintech'],
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        applicantsCount: 6,
      ),
      Gig(
        id: 'GIG-202',
        title: 'Full Stack Flutter Web App Deployment on Vercel with Escrow',
        category: 'Flutter Development',
        posterName: 'Devon Miles',
        posterAvatar: 'DM',
        posterRating: '5.0 ★',
        budget: 800.0,
        deliveryTime: '5 Days',
        description:
            'Set up responsive canvas/html rendering, configure SPA routing for Vercel/Render, and test secure transaction payouts with 10% platform fee.',
        tags: ['Flutter', 'Vercel', 'Render', 'Backend'],
        createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        applicantsCount: 11,
      ),
      Gig(
        id: 'GIG-203',
        title: 'AI Smart Match Algorithm for Freelance Service Marketplace',
        category: 'AI Services',
        posterName: 'Sarah Sterling',
        posterAvatar: 'SS',
        posterRating: '4.8 ★',
        budget: 650.0,
        deliveryTime: '4 Days',
        description:
            'Develop intelligent semantic matching to pair gig posters with freelancers based on counter-offer history, ratings, and tag affinity.',
        tags: ['AI/ML', 'Python', 'Dart API', 'Algorithms'],
        createdAt: DateTime.now().subtract(const Duration(hours: 14)),
        applicantsCount: 4,
      ),
      Gig(
        id: 'GIG-204',
        title: 'Interactive 3D Spline Animations & Micro-Interactions in Flutter',
        category: 'Mobile & Web Apps',
        posterName: 'Liam Zhao',
        posterAvatar: 'LZ',
        posterRating: '4.9 ★',
        budget: 420.0,
        deliveryTime: '2 Days',
        description:
            'Incorporate silky smooth physics springs, hover glows, and glass button interactions for a luxury mobile web experience.',
        tags: ['Animations', 'Physics', 'Micro-UX', 'Design'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        applicantsCount: 9,
      ),
      Gig(
        id: 'GIG-205',
        title: 'Stripe Connect Escrow & Automated Platform Commission Webhooks',
        category: 'Backend & Security',
        posterName: 'Chloe Bennett',
        posterAvatar: 'CB',
        posterRating: '4.92 ★',
        budget: 950.0,
        deliveryTime: '1 Week',
        description:
            'Build automated escrow holding vaults where client funds are securely locked and 10% platform fee is automatically deducted on completion.',
        tags: ['Escrow', 'Payments', 'Security', 'Webhooks'],
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        applicantsCount: 7,
      ),
    ]);
  }

  void addGig({
    required String title,
    required String category,
    required double budget,
    required String deliveryTime,
    required String description,
    required List<String> tags,
  }) {
    final newGig = Gig(
      id: 'GIG-${_gigs.length + 201}',
      title: title,
      category: category,
      posterName: 'You (Alex)',
      posterAvatar: 'ME',
      posterRating: '4.98 ★',
      budget: budget,
      deliveryTime: deliveryTime,
      description: description,
      tags: tags.isEmpty ? ['Custom Gig'] : tags,
      createdAt: DateTime.now(),
      applicantsCount: 0,
    );

    _gigs.insert(0, newGig);
    notifyListeners();
  }

  void acceptGig(String id) {
    final index = _gigs.indexWhere((g) => g.id == id);
    if (index != -1) {
      _gigs[index].status = 'accepted';
      notifyListeners();
    }
  }

  void negotiateGig(String id, double counterAmount, String note) {
    final index = _gigs.indexWhere((g) => g.id == id);
    if (index != -1) {
      _gigs[index].status = 'countered';
      _gigs[index].counterAmount = counterAmount;
      _gigs[index].counterNote = note;
      notifyListeners();
    }
  }

  void declineGig(String id) {
    final index = _gigs.indexWhere((g) => g.id == id);
    if (index != -1) {
      _gigs[index].status = 'declined';
      notifyListeners();
    }
  }
}
