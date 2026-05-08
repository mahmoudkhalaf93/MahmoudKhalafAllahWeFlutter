import 'package:flutter/material.dart';


class Do extends StatefulWidget {
  List<Map<String, dynamic>> doTasks;
  Do(this.doTasks);
  @override
  State<Do> createState() => _DoState(doTasks);
}

class _DoState extends State<Do> {
  List<Map<String, dynamic>> doTasks;
  _DoState(this.doTasks);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
      for(int i=0;i<doTasks.length;i++)
        buildTaskCard(doTasks[i],Colors.red,() {
          // --- بداية الترتيب التلقائي ---
          setState(() {
            // 1. اعكس حالة المهمة (من صح لغلط أو العكس)
            doTasks[i]['isDone'] = !doTasks[i]['isDone'];

            // // 2. رتب القائمة فوراً
            // doTasks.sort((a, b) {
            //   if (a['isDone'] && !b['isDone']) return -1; // المنتهي يطلع فوق
            //   if (!a['isDone'] && b['isDone']) return 1;  // غير المنتهي ينزل تحت
            //   return 0;
            // });
            applySmartSort(doTasks);
          });
          // --- نهاية الترتيب التلقائي ---
        })
    ],);
  }
  @override
  void initState() {
    super.initState();
    // ترتيب كل القوائم أول ما الأبلكيشن يفتح
    applySmartSort(doTasks);
  }
  void applySmartSort(List<Map<String, dynamic>> list) {
    list.sort((a, b) {
      if (!a['isDone'] && b['isDone']) return -1; // الغير منتهي (false) يطلع فوق
      if (a['isDone'] && !b['isDone']) return 1;  // المنتهي (true) ينزل تحت
      return 0;
    });
  }
  Widget buildTaskCard(Map<String, dynamic> task, Color categoryColor, VoidCallback onToggle) {
    bool isDone = task['isDone'];

    return GestureDetector(
      onTap: onToggle, // أول ما يضغط على الكارت كله أو علامة الصح
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: ListTile(
          leading: InkWell( // استخدمنا InkWell عشان تأثير الضغطة
            onTap: onToggle,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? categoryColor : Colors.transparent,
                border: Border.all(color: categoryColor, width: 2),
              ),
              child: Icon(
                Icons.check,
                size: 20,
                color: isDone ? Colors.white : Colors.transparent,
              ),
            ),
          ),
          title: Text(
            task['taskTitle'],
            style: TextStyle(
              color: isDone ? Colors.grey : Colors.black87,
              decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          subtitle: Text(task['createdAt']),
        ),
      ),
    );
  }
}


