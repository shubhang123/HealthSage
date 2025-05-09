import 'package:flutter/material.dart';
import 'package:authapp/widgets/medication_card.dart';

class PersonalDetailsCard extends StatelessWidget {
  final String name;
  final List<String> chronicConditions;
  final List<String> surgeries;
  final List<String> allergies;
  final String dateOfBirth;

  PersonalDetailsCard({
    required this.name,
    required this.chronicConditions,
    required this.surgeries,
    required this.allergies,
    required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF386cf1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome back,\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 24,
                        ),
                      ),
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            // Display chronic conditions
            if (chronicConditions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Chronic Conditions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Bold and white text
                    ),
                  ),
                  Container(
                    height: 50, // Adjusted height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chronicConditions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 2, right: 2),
                          child: MedicationCard(
                            content: chronicConditions[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 0),

            // Display allergies
            if (allergies.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Allergies:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Bold and white text
                    ),
                  ),
                  Container(
                    height: 50, // Adjusted height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: allergies.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: MedicationCard(
                            content: allergies[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            // Display surgeries
            if (surgeries.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Surgeries:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white, // Bold and white text
                    ),
                  ),
                  Container(
                    height: 50, // Adjusted height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: surgeries.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: MedicationCard(
                            content: surgeries[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
