import 'package:authapp/tabs/home/chat_interface.dart';
import 'package:authapp/tabs/home/fake_files.dart';
import 'package:authapp/tabs/home/files_page.dart';
import 'package:authapp/tabs/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [TabPage(userId: widget.userId), const ChatPage(), FileListPage()];
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            selectedIndex: _selectedIndex,
            gap: 16,
            onTabChange: _onTabChange,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Assistant',
              ),
              GButton(
                icon: Icons.file_present_rounded,
                text: 'Reports',
              )
            ],
            padding: const EdgeInsets.all(16),
            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            color: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.primary,
            tabBackgroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
