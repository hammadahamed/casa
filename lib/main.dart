import 'package:casa/common/app_colors.dart';
import 'package:casa/views/albums.dart';
import 'package:casa/views/home.dart';
import 'package:casa/views/posts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Casa',
      theme: ThemeData.dark(),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int tabIndex = 0;

  Icon getIcon(
    IconData icon, {
    Color color = Colors.white,
  }) {
    return Icon(
      icon,
      size: 20,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = const [
      Home(),
      Posts(),
      Albums(),
    ];

    List<BottomNavigationBarItem> bnbItems() {
      return [
        Icons.home,
        Icons.mark_chat_unread,
        Icons.photo_sharp,
      ]
          .asMap()
          .map(
            (index, icon) => MapEntry(
              index,
              BottomNavigationBarItem(
                icon: getIcon(icon),
                label: "Item $index",
                activeIcon: getIcon(
                  icon,
                  color: Colors.blue,
                ),
              ),
            ),
          )
          .values
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: tabIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bgDark,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
        },
        items: [
          ...bnbItems(),
        ],
      ),
    );
  }
}
