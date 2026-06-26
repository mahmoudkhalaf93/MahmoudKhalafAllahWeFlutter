import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_layout.dart';
import '../l10n/app_strings.dart';
import '../providers/settings_provider.dart';
import '../widgets/image_upload_field.dart';

class CategoryDetailScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final FirebaseService _fs = FirebaseService();
  final SettingsProvider _settings = SettingsProvider();
  String _search = '';

  late Future<CategoryStats> _stats;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_refresh);
    _loadStats();
  }

  @override
  void dispose() {
    _settings.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _loadStats() {
    _stats = _fs.getCategoryAnalytics().then(
      (map) => map[widget.category.id] ?? CategoryStats(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackHeader(),
            const SizedBox(height: AppTheme.spaceM),
            _buildCategoryInfo(),
            const SizedBox(height: AppTheme.spaceM),
            _buildStatsRow(),
            const SizedBox(height: AppTheme.spaceL),
            _buildMealsHeader(),
            const SizedBox(height: AppTheme.spaceM),
            Expanded(child: _buildMealsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildBackHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          color: AppTheme.textSecondary,
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/categories'),
          tooltip: S.backToCategories,
        ),
        const SizedBox(width: AppTheme.spaceS),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.categoryDetails, style: AppTheme.pageTitle),
            const SizedBox(height: 2),
            Text(
              widget.category.name,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryInfo() {
    final c = widget.category;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.bgSurface,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: c.image.isEmpty
                ? Icon(
                    Icons.category_outlined,
                    color: AppTheme.textMuted,
                    size: 28,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    child: Image.network(
                      c.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported_outlined,
                        color: AppTheme.textMuted,
                        size: 28,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: AppTheme.sectionTitle),
                if (c.nameAr.isNotEmpty)
                  Text(
                    c.nameAr,
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                if (c.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      c.description,
                      style: AppTheme.smallText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return FutureBuilder<CategoryStats>(
      future: _stats,
      builder: (context, snap) {
        final stats = snap.data ?? CategoryStats();
        return Row(
          children: [
            _buildStatItem(
              Icons.restaurant_menu_outlined,
              S.mealsCount,
              stats.mealsCount.toString(),
            ),
            const SizedBox(width: AppTheme.spaceM),
            _buildStatItem(
              Icons.check_circle_outline,
              S.completedOrders,
              stats.completedOrders.toString(),
            ),
            const SizedBox(width: AppTheme.spaceM),
            _buildStatItem(
              Icons.attach_money_rounded,
              S.revenue,
              '${stats.revenue.toStringAsFixed(0)} EGP',
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMain),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(icon, color: AppTheme.textSecondary, size: 18),
            ),
            const SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.smallText),
                  const SizedBox(height: 2),
                  Text(value, style: AppTheme.cardTitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsHeader() {
    return Wrap(
      spacing: AppTheme.spaceM,
      runSpacing: AppTheme.spaceM,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(S.meals, style: AppTheme.sectionTitle),
        SizedBox(
          width: 250,
          height: 40,
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            style: AppTheme.bodyText,
            decoration: InputDecoration(
              hintText: S.searchMeals,
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showMealDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: Text(S.addMeal),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
        ),
      ],
    );
  }

  Widget _buildMealsTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMain),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: StreamBuilder<List<MealModel>>(
        stream: _fs.streamMeals(widget.category.id),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu_outlined,
                    size: 48,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Text(
                    S.noMealsYet,
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Text(S.addMealHint, style: AppTheme.smallText),
                ],
              ),
            );
          }

          var meals = snap.data!;
          if (_search.isNotEmpty) {
            final q = _search.toLowerCase();
            meals = meals
                .where(
                  (m) =>
                      m.name.toLowerCase().contains(q) ||
                      m.nameAr.toLowerCase().contains(q) ||
                      m.description.toLowerCase().contains(q),
                )
                .toList();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: AppTheme.smallText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                dataTextStyle: AppTheme.bodyText,
                dividerThickness: 1,
                columnSpacing: 32,
                headingRowHeight: 48,
                dataRowMinHeight: 64,
                dataRowMaxHeight: 64,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: AppTheme.borderColor,
                    width: 1,
                  ),
                ),
                columns: [
                  DataColumn(label: Text(S.mealName)),
                  DataColumn(label: Text(S.mealPrice)),
                  DataColumn(label: Text(S.description)),
                  DataColumn(label: Text(S.available)),
                  const DataColumn(label: Text('Actions')),
                ],
                rows: meals.map((m) => _buildMealRow(m)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildMealRow(MealModel m) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: m.image.isEmpty
                    ? Icon(
                        Icons.restaurant_outlined,
                        color: AppTheme.textMuted,
                        size: 18,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          m.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported_outlined,
                            color: AppTheme.textMuted,
                            size: 18,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: AppTheme.spaceM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    m.name,
                    style: AppTheme.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (m.nameAr.isNotEmpty)
                    Text(
                      m.nameAr,
                      style: AppTheme.smallText.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            '${m.price.toStringAsFixed(0)} EGP',
            style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(
          Text(
            m.description.isNotEmpty ? m.description : '-',
            style: AppTheme.smallText,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (m.isAvailable ? AppTheme.success : AppTheme.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              m.isAvailable ? S.available : S.unavailable,
              style: AppTheme.smallText.copyWith(
                color: m.isAvailable ? AppTheme.success : AppTheme.error,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                color: AppTheme.textSecondary,
                tooltip: S.edit,
                onPressed: () => _showMealDialog(m),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppTheme.error,
                tooltip: S.delete,
                onPressed: () => _confirmDeleteMeal(m),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMealDialog([MealModel? meal]) {
    final nameC = TextEditingController(text: meal?.name ?? '');
    final nameArC = TextEditingController(text: meal?.nameAr ?? '');
    final descC = TextEditingController(text: meal?.description ?? '');
    final descArC = TextEditingController(text: meal?.descriptionAr ?? '');
    final priceC = TextEditingController(
      text: meal != null ? meal.price.toStringAsFixed(0) : '',
    );
    final imgC = TextEditingController(text: meal?.image ?? '');
    bool isAvailable = meal?.isAvailable ?? true;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(
            meal == null ? S.addMeal : S.editMeal,
            style: AppTheme.sectionTitle,
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameC,
                    decoration: InputDecoration(
                      labelText: '${S.mealName} (EN)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: nameArC,
                    decoration: InputDecoration(labelText: S.mealNameAr),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: priceC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '${S.mealPrice} (EGP)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: descC,
                    decoration: InputDecoration(
                      labelText: '${S.description} (EN)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  TextField(
                    controller: descArC,
                    decoration: InputDecoration(
                      labelText: '${S.description} (AR)',
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  ImageUploadField(
                    label: 'صورة الصنف (Meal Image)',
                    currentImageUrl: imgC.text,
                    folderName: 'meals',
                    onImageUploaded: (url) {
                      imgC.text = url;
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.available, style: AppTheme.bodyText),
                      Switch(
                        value: isAvailable,
                        onChanged: (v) => setDialogState(() => isAvailable = v),
                        activeThumbColor: AppTheme.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(ctx),
              child: Text(
                S.cancel,
                style: AppTheme.bodyText.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (nameC.text.trim().isEmpty) return;
                      final price = double.tryParse(priceC.text.trim());
                      if (price == null || price < 0) return;

                      setDialogState(() => isLoading = true);

                      final newMeal = MealModel(
                        id: meal?.id ?? '',
                        categoryId: widget.category.id,
                        name: nameC.text.trim(),
                        nameAr: nameArC.text.trim(),
                        description: descC.text.trim(),
                        descriptionAr: descArC.text.trim(),
                        price: price,
                        image: imgC.text.trim(),
                        isAvailable: isAvailable,
                        createdAt: meal?.createdAt,
                      );

                      bool ok;
                      if (meal == null) {
                        ok = await _fs.addMeal(widget.category.id, newMeal);
                      } else {
                        ok = await _fs.updateMeal(widget.category.id, newMeal);
                      }

                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? (meal == null
                                        ? S.successAdd
                                        : S.successEdit)
                                  : S.errorOccurred,
                            ),
                          ),
                        );

                        _loadStats();
                        setState(() {});
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(S.save),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteMeal(MealModel m) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          S.confirmDelete,
          style: AppTheme.sectionTitle.copyWith(color: AppTheme.error),
        ),
        content: Text(S.deleteMealMsg(m.name), style: AppTheme.bodyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              S.cancel,
              style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              final ok = await _fs.deleteMeal(widget.category.id, m.id);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(content: Text(ok ? S.successDelete : S.errorOccurred)),
              );
              _loadStats();
              if (mounted) setState(() {});
            },
            child: Text(S.delete),
          ),
        ],
      ),
    );
  }
}
