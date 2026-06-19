import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  Map data;

  Chatpage(this.data);

  @override
  State<Chatpage> createState() => _ChatpageState(data);
}

class _ChatpageState extends State<Chatpage> {
  Map data;

  _ChatpageState(this.data);

  List<Map> receiverMessages = [
    {"message": "Hi, how are you?", "time": "10:30 AM"},
    {"message": "Did you finish the task?", "time": "10:31 AM"},
    {"message": "The client is asking.", "time": "10:35 AM"},
    {"message": "Please check the mail.", "time": "10:40 AM"},
    {"message": "I sent the files.", "time": "10:45 AM"},
    {"message": "Are you there?", "time": "11:00 AM"},
    {"message": "Let me know soon.", "time": "11:05 AM"},
    {"message": "Meeting at 5?", "time": "11:15 AM"},
    {"message": "The link is ready.", "time": "11:30 AM"},
    {"message": "See you later!", "time": "11:45 AM"},
  ];
  List<Map> senderMessages = [
    {"message": "I am fine, thanks!", "time": "10:32 AM"},
    {"message": "Working on it now.", "time": "10:33 AM"},
    {"message": "Almost done.", "time": "10:36 AM"},
    {"message": "Checked it, looks good.", "time": "10:42 AM"},
    {"message": "Received the files.", "time": "10:47 AM"},
    {"message": "Yes, just a moment.", "time": "11:02 AM"},
    {"message": "I'll call you back.", "time": "11:10 AM"},
    {"message": "5 PM works for me.", "time": "11:20 AM"},
    {"message": "Great, thanks.", "time": "11:35 AM"},
    {"message": "Talk soon!", "time": "11:50 AM"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(this.data["image"]),
            ),
            SizedBox(width: 12),
            Text(this.data["title"]),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < senderMessages.length; i++)
                    Column(
                      children: [
                        receiver(receiverMessages[i]),
                        sender(senderMessages[i]),

                      ],
                    ),
                ],
              ),
            ),
            Card(

              elevation: 10,
              shadowColor: Colors.black,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.send, size: 35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sender(Map data) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage("assets/images/user28.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8,
              children: [
                Text(
                  "Mahmoud khalaf",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  data["message"],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.end,
                data["time"],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget receiver(Map data) {
    return Container(
      color: Colors.cyanAccent[100],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.start,
                  data["time"],
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  Text(
                    this.data["title"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    data["message"],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ],
              ),
            ),

            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(this.data["image"]),
            ),
          ],
        ),
      ),
    );
  }
}
