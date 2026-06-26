class S {
  static bool _isArabic = true;
  static void setArabic(bool value) => _isArabic = value;

  static String get appTitle => _isArabic ? 'لوحة الإدارة' : 'Admin Dashboard';
  static String get admin => _isArabic ? 'المسؤول' : 'Admin';
  static String get adminEmail => 'admin@app.com';

  static String get home => _isArabic ? 'الرئيسية' : 'Home';
  static String get categories => _isArabic ? 'الأقسام' : 'Categories';
  static String get users => _isArabic ? 'المستخدمين' : 'Users';
  static String get orders => _isArabic ? 'الطلبات' : 'Orders';
  static String get drivers => _isArabic ? 'السائقين' : 'Drivers';
  static String get restaurants => _isArabic ? 'المطاعم' : 'Restaurants';
  static String get offers => _isArabic ? 'العروض' : 'Offers';
  static String get dashboardSub =>
      _isArabic ? 'Admin Dashboard' : 'Admin Dashboard';
  static String get settings => _isArabic ? 'الإعدادات' : 'Settings';
  static String get language => _isArabic ? 'اللغة' : 'Language';
  static String get darkMode => _isArabic ? 'الوضع الداكن' : 'Dark Mode';
  static String get arabic => _isArabic ? 'عربي' : 'Arabic';
  static String get english => _isArabic ? 'إنجليزي' : 'English';

  static String get welcomeMsg => _isArabic ? 'مرحباً بك' : 'Welcome';
  static String get overviewMsg => _isArabic
      ? 'إليك نظرة عامة على النظام اليوم'
      : 'Here\'s an overview of your system today';
  static String get totalUsers =>
      _isArabic ? 'إجمالي المستخدمين' : 'Total Users';
  static String get availableCategories =>
      _isArabic ? 'الأقسام المتاحة' : 'Available Categories';
  static String get totalOrders =>
      _isArabic ? 'إجمالي الطلبات' : 'Total Orders';
  static String get totalRevenue =>
      _isArabic ? 'إجمالي الإيرادات' : 'Total Revenue';
  static String get ordersActivity =>
      _isArabic ? 'نشاط الطلبات' : 'Orders Activity';
  static String get last7Days => _isArabic ? 'آخر 7 أيام' : 'Last 7 days';
  static String get orderStatusDist =>
      _isArabic ? 'توزيع حالات الطلبات' : 'Order Status Distribution';
  static String get recentOrders => _isArabic ? 'آخر الطلبات' : 'Recent Orders';
  static String get viewAll => _isArabic ? 'عرض الكل ←' : 'View All →';
  static String get noData => _isArabic ? 'لا توجد بيانات' : 'No data';
  static String get noOrdersYet =>
      _isArabic ? 'لا يوجد طلبات حتى الآن' : 'No orders yet';
  static String get categoryAnalytics =>
      _isArabic ? 'إحصائيات الأقسام' : 'Category Analytics';

  static List<String> get weekDays => _isArabic
      ? ['سبت', 'أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة']
      : ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  static String get pending => _isArabic ? 'قيد المعالجة' : 'Pending';
  static String get completed => _isArabic ? 'مكتمل' : 'Completed';
  static String get delivering => _isArabic ? 'قيد التوصيل' : 'Delivering';
  static String get cancelled => _isArabic ? 'ملغي' : 'Cancelled';
  static String get all => _isArabic ? 'الكل' : 'All';

  static String get manageCategories =>
      _isArabic ? 'إدارة الأقسام' : 'Manage Categories';
  static String get manageCategoriesSub => _isArabic
      ? 'إضافة وتعديل وحذف الأقسام'
      : 'Add, edit and delete categories';
  static String get addCategory => _isArabic ? 'إضافة قسم' : 'Add Category';
  static String get editCategory => _isArabic ? 'تعديل القسم' : 'Edit Category';
  static String get addNewCategory =>
      _isArabic ? 'إضافة قسم جديد' : 'Add New Category';
  static String get categoryName => _isArabic ? 'اسم القسم' : 'Category Name';
  static String get description => _isArabic ? 'الوصف' : 'Description';
  static String get noCategoriesYet =>
      _isArabic ? 'لا توجد أقسام بعد' : 'No categories yet';
  static String get addCategoryHint => _isArabic
      ? 'اضغط على "إضافة قسم" لإنشاء قسم جديد'
      : 'Press "Add Category" to create a new one';

  static String get manageUsers =>
      _isArabic ? 'إدارة المستخدمين' : 'Manage Users';
  static String get manageUsersSub => _isArabic
      ? 'عرض وإدارة حسابات المستخدمين'
      : 'View and manage user accounts';
  static String get noUsersYet =>
      _isArabic ? 'لا يوجد مستخدمين حالياً' : 'No users yet';
  static String get active => _isArabic ? 'نشط' : 'Active';
  static String get disabled => _isArabic ? 'معطل' : 'Disabled';
  static String get disable => _isArabic ? 'تعطيل' : 'Disable';
  static String get enable => _isArabic ? 'تفعيل' : 'Enable';

  static String get manageOrders =>
      _isArabic ? 'إدارة الطلبات' : 'Manage Orders';
  static String get manageOrdersSub => _isArabic
      ? 'متابعة وتحديث حالات الطلبات'
      : 'Track and update order statuses';
  static String get noOrdersNow =>
      _isArabic ? 'لا يوجد طلبات حالياً' : 'No orders right now';
  static String get searchOrders =>
      _isArabic ? 'بحث برقم الطلب...' : 'Search by order ID...';

  static String get meals => _isArabic ? 'الوجبات' : 'Meals';
  static String get addMeal => _isArabic ? 'إضافة وجبة' : 'Add Meal';
  static String get editMeal => _isArabic ? 'تعديل الوجبة' : 'Edit Meal';
  static String get mealName => _isArabic ? 'اسم الوجبة' : 'Meal Name';
  static String get mealNameAr =>
      _isArabic ? 'اسم الوجبة (عربي)' : 'Meal Name (AR)';
  static String get mealPrice => _isArabic ? 'السعر' : 'Price';
  static String get available => _isArabic ? 'متاح' : 'Available';
  static String get unavailable => _isArabic ? 'غير متاح' : 'Unavailable';
  static String get noMealsYet =>
      _isArabic ? 'لا توجد وجبات بعد' : 'No meals yet';
  static String get addMealHint => _isArabic
      ? 'اضغط على "إضافة وجبة" لإنشاء وجبة جديدة'
      : 'Press "Add Meal" to create a new one';

  static String get categoryDetails =>
      _isArabic ? 'تفاصيل القسم' : 'Category Details';
  static String get backToCategories =>
      _isArabic ? 'العودة للأقسام' : 'Back to Categories';
  static String get mealsCount => _isArabic ? 'عدد الوجبات' : 'Meals';
  static String get completedOrders =>
      _isArabic ? 'الطلبات المكتملة' : 'Completed Orders';
  static String get revenue => _isArabic ? 'الإيرادات' : 'Revenue';
  static String get viewDetails => _isArabic ? 'عرض' : 'View';

  static String get search => _isArabic ? 'بحث...' : 'Search...';
  static String get edit => _isArabic ? 'تعديل' : 'Edit';
  static String get delete => _isArabic ? 'حذف' : 'Delete';
  static String get cancel => _isArabic ? 'إلغاء' : 'Cancel';
  static String get save => _isArabic ? 'حفظ' : 'Save';
  static String get add => _isArabic ? 'إضافة' : 'Add';
  static String get confirmDelete =>
      _isArabic ? 'تأكيد الحذف' : 'Confirm Delete';
  static String get successAdd =>
      _isArabic ? 'تم الإضافة بنجاح' : 'Added successfully';
  static String get successEdit =>
      _isArabic ? 'تم التعديل بنجاح' : 'Updated successfully';
  static String get successDelete =>
      _isArabic ? 'تم الحذف بنجاح' : 'Deleted successfully';
  static String get successStatus =>
      _isArabic ? 'تم تحديث الحالة بنجاح' : 'Status updated successfully';
  static String get errorOccurred =>
      _isArabic ? 'حدث خطأ أثناء العملية' : 'An error occurred';
  static String get loadError =>
      _isArabic ? 'حدث خطأ في تحميل البيانات' : 'Error loading data';

  static String orderNum(String id) => _isArabic ? 'طلب #$id' : 'Order #$id';
  static String deleteConfirmMsg(String name) => _isArabic
      ? 'هل أنت متأكد من حذف "$name"؟'
      : 'Are you sure you want to delete "$name"?';
  static String deleteOrderMsg(String id) =>
      _isArabic ? 'حذف الطلب #$id؟' : 'Delete order #$id?';
  static String deleteUserMsg(String name) =>
      _isArabic ? 'حذف المستخدم "$name"؟' : 'Delete user "$name"?';
  static String deleteMealMsg(String name) =>
      _isArabic ? 'حذف الوجبة "$name"؟' : 'Delete meal "$name"?';
  static String userLabel(String id) =>
      _isArabic ? 'المستخدم: $id' : 'User: $id';
  static String get searchInCategories =>
      _isArabic ? 'بحث في الأقسام...' : 'Search categories...';
  static String get searchUsers =>
      _isArabic ? 'بحث بالاسم أو الإيميل...' : 'Search by name or email...';
  static String get searchMeals =>
      _isArabic ? 'بحث في الوجبات...' : 'Search meals...';

  static String get userStats =>
      _isArabic ? 'إحصائيات المستخدم' : 'User Statistics';
  static String get totalOrdersUser =>
      _isArabic ? 'إجمالي الطلبات' : 'Total Orders';
  static String get cancelledOrdersUser =>
      _isArabic ? 'الطلبات الملغية' : 'Cancelled Orders';
  static String get completedOrdersUser =>
      _isArabic ? 'الطلبات المكتملة' : 'Completed Orders';
  static String get pendingOrdersUser =>
      _isArabic ? 'طلبات قيد التنفيذ' : 'Pending Orders';
  static String get totalSpent =>
      _isArabic ? 'إجمالي المصروفات' : 'Total Spent';
  static String get close => _isArabic ? 'إغلاق' : 'Close';
  static String get loadingStats =>
      _isArabic ? 'جاري تحميل الإحصائيات...' : 'Loading statistics...';
}
