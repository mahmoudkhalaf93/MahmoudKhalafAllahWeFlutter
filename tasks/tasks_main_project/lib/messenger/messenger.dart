import 'package:flutter/material.dart';
import 'package:tasks_main_project/messenger/chatpage.dart';

class Messenger extends StatefulWidget {
  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  List<Map> stories = [
    {"image": "assets/images/user8.jpg", "title": "mahmoud khalaf"},
    {"image": "assets/images/user13.jpg", "title": "run"},
    {"image": "assets/images/user28.jpg", "title": "sport"},
    {"image": "assets/images/user3.jpg", "title": "sport fun"},
    {"image": "assets/images/user4.jpg", "title": "suzuki"},
    {"image": "assets/images/user27.jpg", "title": "alfredo"},
    {"image": "assets/images/user8.jpg", "title": "mahmoud khalaf"},
    {"image": "assets/images/user1.jpg", "title": "run"},
    {"image": "assets/images/user2.jpg", "title": "sport"},
    {"image": "assets/images/user3.jpg", "title": "sport fun"},
    {"image": "assets/images/user4.jpg", "title": "suzuki"},
    {"image": "assets/images/user15.jpg", "title": "alfredo"},
    {"image": "assets/images/user16.jpg", "title": "run"},
    {"image": "assets/images/user22.jpg", "title": "sport"},
    {"image": "assets/images/user14.jpg", "title": "sport fun"},
    {"image": "assets/images/user17.PNG", "title": "suzuki"},
    {"image": "assets/images/user19.jpg", "title": "alfredo"},
  ];

  List<Map> users = [
    {
      "image": "assets/images/user1.jpg",
      "title": "Mahmoud Khalaf",
      "message": "Hi, how are you?",
      "time": "10:30 AM",
    },
    {
      "image": "assets/images/user2.jpg",
      "title": "Ahmed Ali",
      "message": "Did you finish the design?",
      "time": "10:45 AM",
    },
    {
      "image": "assets/images/user3.jpg",
      "title": "Sarah Hassan",
      "message": "The meeting is at 5 PM.",
      "time": "11:00 AM",
    },
    {
      "image": "assets/images/user4.jpg",
      "title": "Omar Khaled",
      "message": "Check the new updates.",
      "time": "11:15 AM",
    },
    {
      "image": "assets/images/user5.jpg",
      "title": "Laila Mahmoud",
      "message": "See you tomorrow!",
      "time": "11:30 AM",
    },
    {
      "image": "assets/images/user6.jpg",
      "title": "Zaid Ammar",
      "message": "I sent the files to your email.",
      "time": "11:45 AM",
    },
    {
      "image": "assets/images/user7.jpg",
      "title": "Hana Youssef",
      "message": "Happy Birthday!",
      "time": "12:00 PM",
    },
    {
      "image": "assets/images/user8.jpg",
      "title": "Mostafa Ibrahim",
      "message": "Call me when you are free.",
      "time": "12:15 PM",
    },
    {
      "image": "assets/images/user9.jpg",
      "title": "Nour El-Din",
      "message": "The project is almost done.",
      "time": "12:30 PM",
    },
    {
      "image": "assets/images/user10.jpg",
      "title": "Mariam Adel",
      "message": "Can we postpone the call?",
      "time": "12:45 PM",
    },
    {
      "image": "assets/images/user11.jpg",
      "title": "Youssef Tarek",
      "message": "Let's go cycling today.",
      "time": "1:00 PM",
    },
    {
      "image": "assets/images/user12.jpg",
      "title": "Amira Saad",
      "message": "I love this Flutter tutorial.",
      "time": "1:15 PM",
    },
    {
      "image": "assets/images/user13.jpg",
      "title": "Khaled Walid",
      "message": "Where are you now?",
      "time": "1:30 PM",
    },
    {
      "image": "assets/images/user14.jpg",
      "title": "Dina Mohamed",
      "message": "The pizza was delicious!",
      "time": "1:45 PM",
    },
    {
      "image": "assets/images/user15.jpg",
      "title": "Ibrahim Fawzy",
      "message": "I finished the abstract class.",
      "time": "2:00 PM",
    },
    {
      "image": "assets/images/user16.jpg",
      "title": "Fatma Salem",
      "message": "Send me the location.",
      "time": "2:15 PM",
    },
    {
      "image": "assets/images/user17.PNG",
      "title": "Adam Sherif",
      "message": "Are you coming to the match?",
      "time": "2:30 PM",
    },
    {
      "image": "assets/images/user18.PNG",
      "title": "Rania Bakr",
      "message": "Thanks for your help.",
      "time": "2:45 PM",
    },
    {
      "image": "assets/images/user19.jpg",
      "title": "Tamer Hosny",
      "message": "Good morning!",
      "time": "3:00 PM",
    },
    {
      "image": "assets/images/user20.jpg",
      "title": "Salma Eid",
      "message": "Don't forget the keys.",
      "time": "3:15 PM",
    },
    {
      "image": "assets/images/user21.jpg",
      "title": "Hassan Mounir",
      "message": "The code is working fine.",
      "time": "3:30 PM",
    },
    {
      "image": "assets/images/user22.jpg",
      "title": "Mona Ahmed",
      "message": "Wait for me at the station.",
      "time": "3:45 PM",
    },
    {
      "image": "assets/images/user23.jpg",
      "title": "Waleed Samy",
      "message": "Nice to meet you.",
      "time": "4:00 PM",
    },
    {
      "image": "assets/images/user24.jpg",
      "title": "Yasmine Ali",
      "message": "I'm busy right now.",
      "time": "4:15 PM",
    },
    {
      "image": "assets/images/user25.jpg",
      "title": "Basem Raafat",
      "message": "Let's test the emulator.",
      "time": "4:30 PM",
    },
    {
      "image": "assets/images/user26.jpg",
      "title": "Ghada Kamel",
      "message": "Excellent work!",
      "time": "4:45 PM",
    },
    {
      "image": "assets/images/user27.jpg",
      "title": "Hany Ramzy",
      "message": "Check the pull request.",
      "time": "5:00 PM",
    },
    {
      "image": "assets/images/user28.jpg",
      "title": "Maha Zain",
      "message": "I'm arriving in 10 minutes.",
      "time": "5:15 PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            height: 105,

            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < stories.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        showStory(stories[i]);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(stories[i]["image"]),
                          ),
                          Text(
                            stories[i]["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          for (int i = 0; i < users.length; i++)
            Card(
              color: Colors.white,
              shadowColor: Colors.black,
              margin: EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatpage(users[i])),
                  );
                },
                leading: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(users[i]["image"]),
                ),
                trailing: Text(users[i]["time"]),
                title: Text(users[i]["title"]),
                subtitle: Text(users[i]["message"]),
              ),
            ),
        ],
      ),
    );
  }

  Future<dynamic> showStory(Map data) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Image.asset(data["image"]),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    data["title"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(.9),
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
