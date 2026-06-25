import 'package:flutter/material.dart';
import 'package:tasks_main_project/tasksapp/databasehelper/databasehelper.dart';
import 'package:tasks_main_project/tasksapp/tabs/decide.dart';
import 'package:tasks_main_project/tasksapp/tabs/delegate.dart';
import 'package:tasks_main_project/tasksapp/tabs/do.dart';
import 'package:tasks_main_project/tasksapp/tabs/postpone.dart';
import 'package:tasks_main_project/tasksapp/mywidgets.dart';


class Home extends StatefulWidget {
  String name, image;

  Home({required this.name, required this.image});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  List<Map<String, dynamic>> decideTasks = [
    {"isDone": true, "taskTitle": "تعلم أساسيات الـ State Management", "hasReminder": true, "createdAt": "2026-05-08 10:00 AM"},
    {"isDone": false, "taskTitle": "البحث عن كورسات Flutter متقدمة", "hasReminder": false, "createdAt": "2026-05-08 11:00 AM"},
    {"isDone": true, "taskTitle": "وضع خطة لإنقاص الوزن والرياضة", "hasReminder": true, "createdAt": "2026-05-08 09:00 AM"},
    {"isDone": false, "taskTitle": "قراءة كتاب عن هندسة البرمجيات", "hasReminder": false, "createdAt": "2026-05-08 01:00 PM"},
    {"isDone": false, "taskTitle": "تخطيط رحلة الصيف القادمة", "hasReminder": true, "createdAt": "2026-05-08 12:00 PM"},
    {"isDone": true, "taskTitle": "تحسين ملف LinkedIn الشخصي", "hasReminder": false, "createdAt": "2026-05-08 02:00 PM"},
    {"isDone": false, "taskTitle": "مذاكرة دروس اللغة الإنجليزية", "hasReminder": true, "createdAt": "2026-05-08 08:00 AM"},
    {"isDone": true, "taskTitle": "البحث عن شقة جديدة للإيجار", "hasReminder": false, "createdAt": "2026-05-08 03:00 PM"},
    {"isDone": false, "taskTitle": "تنظيم ملفات الكمبيوتر القديمة", "hasReminder": false, "createdAt": "2026-05-08 04:00 PM"},
    {"isDone": true, "taskTitle": "تطوير مهارات الـ UI/UX في فلاتر", "hasReminder": true, "createdAt": "2026-05-08 05:00 PM"},
  ];
  List<Map<String, dynamic>> delegateTasks = [
    {"isDone": false, "taskTitle": "إرسال ملفات الصور للمصمم", "hasReminder": false, "createdAt": "2026-05-08 10:00 AM"},
    {"isDone": true, "taskTitle": "طلب السوبر ماركت عبر التطبيق", "hasReminder": true, "createdAt": "2026-05-08 11:00 AM"},
    {"isDone": false, "taskTitle": "تكليف الزميل بمراجعة التقرير", "hasReminder": false, "createdAt": "2026-05-08 09:00 AM"},
    {"isDone": true, "taskTitle": "حجز موعد صيانة الغسالة", "hasReminder": true, "createdAt": "2026-05-08 01:00 PM"},
    {"isDone": false, "taskTitle": "مطالبة خدمة العملاء بحل مشكلة النت", "hasReminder": false, "createdAt": "2026-05-08 12:00 PM"},
    {"isDone": true, "taskTitle": "تفويض السكرتارية بترتيب المواعيد", "hasReminder": false, "createdAt": "2026-05-08 02:00 PM"},
    {"isDone": false, "taskTitle": "إرسال دعوات الحفل للأصدقاء", "hasReminder": true, "createdAt": "2026-05-08 08:00 AM"},
    {"isDone": true, "taskTitle": "طلب غداء للفريق من المطعم", "hasReminder": false, "createdAt": "2026-05-08 03:00 PM"},
    {"isDone": false, "taskTitle": "تنسيق موعد الحلاق بالهاتف", "hasReminder": false, "createdAt": "2026-05-08 04:00 PM"},
    {"isDone": true, "taskTitle": "تأجير شخص لتنظيف الحديقة", "hasReminder": false, "createdAt": "2026-05-08 05:00 PM"},
  ];
  List<Map<String, dynamic>> postponeTasks = [
    {"isDone": false, "taskTitle": "تغيير خلفية التطبيق للوضع الليلي", "hasReminder": false, "createdAt": "2026-05-08 10:00 AM"},
    {"isDone": false, "taskTitle": "مشاهدة كورس التصوير الفوتوغرافي", "hasReminder": false, "createdAt": "2026-05-08 11:00 AM"},
    {"isDone": true, "taskTitle": "تجربة ألعاب جديدة على الموبايل", "hasReminder": false, "createdAt": "2026-05-08 09:00 AM"},
    {"isDone": false, "taskTitle": "شراء إكسسوارات مكتبية", "hasReminder": false, "createdAt": "2026-05-08 01:00 PM"},
    {"isDone": false, "taskTitle": "تعلم العزف على آلة موسيقية", "hasReminder": false, "createdAt": "2026-05-08 12:00 PM"},
    {"isDone": true, "taskTitle": "زيارة متاحف القاهرة القديمة", "hasReminder": false, "createdAt": "2026-05-08 02:00 PM"},
    {"isDone": true, "taskTitle": "فرز الملابس القديمة للتبرع بها", "hasReminder": false, "createdAt": "2026-05-08 08:00 AM"},
    {"isDone": false, "taskTitle": "البحث عن أنواع شاشات 4K", "hasReminder": false, "createdAt": "2026-05-08 03:00 PM"},
    {"isDone": true, "taskTitle": "كتابة مذكرات يومية", "hasReminder": false, "createdAt": "2026-05-08 04:00 PM"},
    {"isDone": false, "taskTitle": "إضافة تأثيرات صوتية للأزرار", "hasReminder": false, "createdAt": "2026-05-08 05:00 PM"},
  ];
  List<Map<String, dynamic>> doTasks = [
    {
      "isDone": false,
      "taskTitle": "إصلاح Bug الـ Login اللي بيقفل التطبيق",
      "hasReminder": true,
      "createdAt": "2026-05-08 10:00 AM"
    },
    {
      "isDone": true,
      "taskTitle": "تسليم كود الآلة الحاسبة للعميل",
      "hasReminder": false,
      "createdAt": "2026-05-08 11:00 AM"
    },
    {
      "isDone": false,
      "taskTitle": "دفع فاتورة الكهرباء قبل قطع الخدمة",
      "hasReminder": true,
      "createdAt": "2026-05-08 09:00 AM"
    },
    {
      "isDone": true,
      "taskTitle": "الرد على إيميل الشركة بخصوص الوظيفة",
      "hasReminder": false,
      "createdAt": "2026-05-08 01:00 PM"
    },
    {
      "isDone": false,
      "taskTitle": "تغيير زيت الموتوسيكل",
      "hasReminder": true,
      "createdAt": "2026-05-08 12:00 PM"
    },
    {
      "isDone": true,
      "taskTitle": "تجهيز السيرة الذاتية للمقابلة غداً",
      "hasReminder": true,
      "createdAt": "2026-05-08 02:00 PM"
    },
    {
      "isDone": false,
      "taskTitle": "شراء الدواء الهام للعائلة",
      "hasReminder": true,
      "createdAt": "2026-05-08 08:00 AM"
    },
    {
      "isDone": true,
      "taskTitle": "تأكيد حجز مكان التدريب اليوم",
      "hasReminder": false,
      "createdAt": "2026-05-08 03:00 PM"
    },
    {
      "isDone": false,
      "taskTitle": "رفع الكود الأخير على GitHub",
      "hasReminder": true,
      "createdAt": "2026-05-08 04:00 PM"
    },
    {
      "isDone": false,
      "taskTitle": "مراجعة متطلبات المشروع الجديد",
      "hasReminder": false,
      "createdAt": "2026-05-08 05:00 PM"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0,top: 4),
            child: CircleAvatar(backgroundImage: AssetImage("assets/images/user10.jpg"),),
          ),
          actions: [
            IconButton(
              onPressed: () {
                print("ok");
              },
              icon: Icon(Icons.access_time),
            ),
            InkWell(
              child: Icon(Icons.login),
              onTap: () {
                print("login");
              },
            ),
            SizedBox(width: 10),
            InkWell(
              child: Icon(Icons.language),
              onTap: () {
                print("arabic");
              },
            ),
          ],
          backgroundColor: Colors.blueGrey,
          title: Text(widget.name),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Do",icon: Icon(Icons.bolt, color: Colors.red),),
              Tab(text: "Decide",icon: Icon(Icons.calendar_month, color: Colors.blue),),
              Tab(text: "Delegate",icon: Icon(Icons.groups, color: Colors.orange),),
              Tab(text: "Postpone",icon: Icon(Icons.snooze,color: Colors.grey),),
            ],
          ),
        ),

        //backgroundColor: Colors.red,
        body: TabBarView(
          controller: _tabController,
          children: [
            Do(doTasks),Decide(decideTasks),Delegate(delegateTasks),Postpone(postponeTasks)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTaskSheet(context,_tabController.index),
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context, int tabIndex) {
    TextEditingController taskController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("إضافة مهمة جديدة",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: taskController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "اكتب المهمة هنا...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (taskController.text.isNotEmpty) {
                    DateTime now = DateTime.now();
// تنسيق التاريخ والوقت معاً: السنة/الشهر/اليوم - الساعة:الدقيقة
                    String formattedDate = "${now.year}-${now.month}-${now.day}   ${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
                    setState(() {
                      var newTask = {
                        "isDone": false,
                        "taskTitle": taskController.text,
                        "hasReminder": false,
                        "createdAt": "${formattedDate}"
                      };

                      switch (tabIndex) {
                        case 0:
                          doTasks.add(newTask);
                          applySmartSort(doTasks);
                          break;
                        case 1:
                          decideTasks.add(newTask);
                          applySmartSort(decideTasks);
                          break;
                        case 2:
                          delegateTasks.add(newTask);
                          applySmartSort(delegateTasks);
                          break;
                        case 3:
                          postponeTasks.add(newTask);
                          applySmartSort(postponeTasks);
                          break;
                      }
                    });
                    Navigator.pop(context);
                  } // نهاية الـ if
                }, // نهاية الـ onPressed
                child: const Text("Add task", style: TextStyle(color: Colors.white)),
              ), // نهاية الـ ElevatedButton
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  void applySmartSort(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      if (!a['isDone'] && b['isDone']) return -1; // الغير منتهي (false) يطلع فوق
      if (a['isDone'] && !b['isDone']) return 1;  // المنتهي (true) ينزل تحت
      return 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    DatabaseHelper databaseHelper=DatabaseHelper();
    databaseHelper.createTable();
  }
}
