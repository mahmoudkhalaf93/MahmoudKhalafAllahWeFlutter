import 'package:flutter/material.dart';

class Delegate extends StatefulWidget {
  List<Map<String, dynamic>> delegateTasks;
  Delegate(this.delegateTasks);
  @override
  State<Delegate> createState() => _DelegateState(delegateTasks);
}

class _DelegateState extends State<Delegate> {
  List<Map<String, dynamic>> delegateTasks;
  _DelegateState(this.delegateTasks);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        for(int i=0;i<delegateTasks.length;i++)
          buildTaskCard(delegateTasks[i],Colors.red,() {
            // --- بداية الترتيب التلقائي ---
            setState(() {
              // 1. اعكس حالة المهمة (من صح لغلط أو العكس)
              delegateTasks[i]['isDone'] = !delegateTasks[i]['isDone'];

              // // 2. رتب القائمة فوراً
              // doTasks.sort((a, b) {
              //   if (a['isDone'] && !b['isDone']) return -1; // المنتهي يطلع فوق
              //   if (!a['isDone'] && b['isDone']) return 1;  // غير المنتهي ينزل تحت
              //   return 0;
              // });
              applySmartSort(delegateTasks);
            });
            // --- نهاية الترتيب التلقائي ---
          })
      ],);
  }
  @override
  void initState() {
    super.initState();
    // ترتيب كل القوائم أول ما الأبلكيشن يفتح
    applySmartSort(delegateTasks);
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