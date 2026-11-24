class BudgetCategory {
  const BudgetCategory({
    required this.name,
    required this.amount,
    required this.iconName,
  });

  final String name;
  final int amount;
  final String iconName;

  factory BudgetCategory.fromJson(Map<String, dynamic> json) {
    return BudgetCategory(
      name: json['name'] as String,
      amount: json['amount'] as int,
      iconName: json['iconName'] as String? ?? 'category',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'iconName': iconName,
      };
}

class BudgetBreakdown {
  const BudgetBreakdown({
    required this.total,
    required this.days,
    required this.categories,
    this.fixedPercent = 65,
    this.flexiblePercent = 35,
  });

  final int total;
  final int days;
  final List<BudgetCategory> categories;
  final int fixedPercent;
  final int flexiblePercent;

  int get dailyAverage => days == 0 ? 0 : (total / days).round();

  int percentOf(BudgetCategory c) =>
      total == 0 ? 0 : ((c.amount / total) * 100).round();

  factory BudgetBreakdown.fromJson(Map<String, dynamic> json) {
    return BudgetBreakdown(
      total: json['total'] as int,
      days: json['days'] as int,
      fixedPercent: json['fixedPercent'] as int? ?? 65,
      flexiblePercent: json['flexiblePercent'] as int? ?? 35,
      categories: (json['categories'] as List)
          .map((e) => BudgetCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'days': days,
        'fixedPercent': fixedPercent,
        'flexiblePercent': flexiblePercent,
        'categories': categories.map((e) => e.toJson()).toList(),
      };
}
