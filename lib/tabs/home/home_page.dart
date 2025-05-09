import 'package:authapp/camera.dart';
import 'package:authapp/reminder/pages/home_page.dart';
import 'package:authapp/reminder/pages/new_entry/new_entry_page.dart';
import 'package:authapp/tabs/home/chat_interface.dart';
import 'package:authapp/tabs/home/fake_files.dart';
import 'package:authapp/tabs/home/files_page.dart';
import 'package:flutter/material.dart';
import 'package:authapp/widgets/personal_details_card.dart';
import 'package:authapp/widgets/activity_card.dart'; // Assuming this is where CustomCard is defined
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TabPage extends StatefulWidget {
  final String userId;

  TabPage({required this.userId, Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  String name = '',
      dateOfBirth = '',
      address = '',
      username = '',
      mobileNo = '',
      bloodGroup = '';
  List<String> allergies = [];
  List<String> surgeries = [];
  List<String> chronicConditions = [];
  String ec1No = '', ec2No = '';
  String height = '', weight = '';
  String imageUrl = '', pdfUrl = '';
  String steps = '';
  int totalMinutesAsleep = 0;
  int heartRate = 0, sleepDuration = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchHeartRate();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      DocumentSnapshot fitbitSnapshot = await FirebaseFirestore.instance
          .collection('fitbit_data')
          .doc('latest')
          .get();

      if (userSnapshot.exists && fitbitSnapshot.exists) {
        setState(() {
          name = userSnapshot.get('Name')?.toString() ?? '';
          dateOfBirth = userSnapshot.get('DateofBirth')?.toString() ?? '';
          address = userSnapshot.get('address')?.toString() ?? '';
          username = userSnapshot.get('username')?.toString() ?? '';
          mobileNo = userSnapshot.get('mobile_no')?.toString() ?? '';
          bloodGroup = userSnapshot.get('bloodGroup')?.toString() ?? '';
          ec1No = userSnapshot.get('ec1_no')?.toString() ?? '';
          ec2No = userSnapshot.get('ec2_no')?.toString() ?? '';
          height = userSnapshot.get('height')?.toString() ?? '';
          weight = userSnapshot.get('weight')?.toString() ?? '';
          imageUrl = userSnapshot.get('imageUrl')?.toString() ?? '';
          pdfUrl = userSnapshot.get('pdfUrl')?.toString() ?? '';

          // Fetching lists from Firestore
          allergies = List<String>.from(userSnapshot.get('allergies') ?? []);
          surgeries = List<String>.from(userSnapshot.get('surgeries') ?? []);
          chronicConditions =
              List<String>.from(userSnapshot.get('chronicConditions') ?? []);

          steps = fitbitSnapshot.get('steps')?.toString() ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchHeartRate() async {
    try {
      DocumentSnapshot fitbitSnapshot = await FirebaseFirestore.instance
          .collection('fitbit_data')
          .doc('latest')
          .get();

      if (fitbitSnapshot.exists) {
        setState(() {
          var sleepData = fitbitSnapshot.get('sleep');
          if (sleepData != null) {
            var summary = sleepData['summary'];
            if (summary != null) {
              var totalMinutesAsleep = summary['totalMinutesAsleep'];
              if (totalMinutesAsleep != null) {
                // Assuming totalMinutesAsleep is a string, you may need to parse it to int
                sleepDuration = int.parse(totalMinutesAsleep.toString());
              }
            }
          }
          var heartRateData = fitbitSnapshot.get('heart_rate');
          if (heartRateData != null) {
            var activitiesHeartIntraday =
                heartRateData['activities-heart-intraday'];
            if (activitiesHeartIntraday != null) {
              var dataset = activitiesHeartIntraday['dataset'];
              if (dataset != null && dataset is List && dataset.isNotEmpty) {
                var lastEntry = dataset.last;
                var value = lastEntry['value'];
                if (value != null) {
                  heartRate = int.parse(value.toString());
                }
              }
            }
          }
        });
      } else {
        print('Fitbit data document does not exist');
      }
    } catch (e) {
      print('Error fetching fitbit data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        onPressed: () {
          // go to new entry page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewEntryPage(
                Id: widget.userId,
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home Page'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.find_in_page),
              title: const Text('Find Doctors'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Add Reminder'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => NewEntryPage(
                              Id: widget.userId,
                            ))));
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_copy),
              title: const Text('My Reports'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => FileListPage())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Virtual Assistant'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ChatPage())));
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 18.0, left: 15, right: 15, bottom: 2),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (context) {
                    return IconButton.filled(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.menu,
                            color: Theme.of(context).colorScheme.onPrimary));
                  }),
                  Image.asset(
                    'assets/logo.png',
                    width: 170,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  IconButton.filled(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    icon: Icon(Icons.camera_alt,
                        color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CameraScreen())));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              PersonalDetailsCard(
                name: name,
                chronicConditions: chronicConditions,
                surgeries: surgeries,
                allergies: allergies,
                dateOfBirth: dateOfBirth,
              ),
              const SizedBox(height: 0),
              Container(
                height: 200,
                width: double.infinity,
                child: const BottomContainer(),
              ),
              /*CustomCard(
                height: 200,
                width: double.infinity,
                title: 'Calories Burned',
                value: weight,
                unit: 'kcal',
                graphData: [
                  FlSpot(0, 3),
                  FlSpot(1, 5),
                  FlSpot(2, 2),
                  FlSpot(3, 7),
                  FlSpot(4, 4),
                  FlSpot(5, 6),
                ],
              ),*/

              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      height: 120,
                      width: double.infinity,
                      title: 'Height',
                      value: height,
                      unit: 'cm',
                      graphData: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomCard(
                      height: 120,
                      width: double.infinity,
                      title: 'Weight',
                      value: weight,
                      unit: 'Kg',
                      graphData: null,
                    ),
                  ),
                ],
              ),
              /*SizedBox(height: 10),
              CustomCard(
                height: 200,
                width: double.infinity,
                title: 'Heart Rate',
                value: '72',
                unit: 'bpm',
                graphData: [
                  FlSpot(0, 60),
                  FlSpot(1, 62),
                  FlSpot(2, 64),
                  FlSpot(3, 70),
                  FlSpot(4, 68),
                  FlSpot(5, 72),
                ],
              ),*/
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      height: 120,
                      width: double.infinity,
                      title: 'Sleep',
                      value: '$sleepDuration',
                      unit: 'minutes',
                      graphData: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomCard(
                      height: 120,
                      width: double.infinity,
                      title: 'Heart Rate',
                      value: '$heartRate',
                      unit: '',
                      graphData: null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomCard(
                height: 200,
                width: double.infinity,
                title: 'Heart Rate',
                value: '$heartRate',
                unit: '',
                graphData: [
                  const FlSpot(0, 5),
                  const FlSpot(1, 10),
                  const FlSpot(2, 15),
                  const FlSpot(3, 20),
                  const FlSpot(4, 30),
                  const FlSpot(5, 45),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      height: 120,
                      width: double.infinity,
                      title: 'Steps',
                      value: steps,
                      unit: '',
                      graphData: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: CustomCard(
                      height: 120,
                      width: double.infinity,
                      title: 'Stress Level',
                      value: '3',
                      unit: 'high',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const CustomCard(
                height: 200,
                width: double.infinity,
                title: 'Active Minutes',
                value: '60',
                unit: 'mins',
                graphData: [
                  FlSpot(0, 10),
                  FlSpot(1, 20),
                  FlSpot(2, 30),
                  FlSpot(3, 40),
                  FlSpot(4, 50),
                  FlSpot(5, 60),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
