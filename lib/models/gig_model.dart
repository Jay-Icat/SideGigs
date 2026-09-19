class Gig {
  final String id;
  final String title;
  final String category;
  final String posterName;
  final String posterAvatar;
  final String posterRating;
  final double budget;
  final String deliveryTime;
  final String description;
  final List<String> tags;
  final DateTime createdAt;
  String status; // 'open', 'accepted', 'countered', 'declined'
  double? counterAmount;
  String? counterNote;
  int applicantsCount;

  Gig({
    required this.id,
    required this.title,
    required this.category,
    required this.posterName,
    required this.posterAvatar,
    required this.posterRating,
    required this.budget,
    required this.deliveryTime,
    required this.description,
    required this.tags,
    required this.createdAt,
    this.status = 'open',
    this.counterAmount,
    this.counterNote,
    this.applicantsCount = 0,
  });

  double get platformFee => budget * 0.10; // 10% fee
  double get netPayout => budget - platformFee;

  double get counterPlatformFee => (counterAmount ?? budget) * 0.10;
  double get counterNetPayout => (counterAmount ?? budget) - counterPlatformFee;
}
