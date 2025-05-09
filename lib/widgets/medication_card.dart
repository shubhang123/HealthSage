import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final String content;

  MedicationCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
