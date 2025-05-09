import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String value;
  final String unit;
  final List<FlSpot>? graphData;

  const CustomCard({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.value,
    required this.unit,
    this.graphData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF386cf1).withAlpha(220),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSurface,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer,
                fontSize: 16),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 36),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 16),
              ),
            ],
          ),
          if (graphData != null) const SizedBox(height: 8),
          if (graphData != null)
            Expanded(
              child: Container(
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: graphData!.first.x,
                    maxX: graphData!.last.x,
                    minY: graphData!
                        .map((e) => e.y)
                        .reduce((a, b) => a < b ? a : b),
                    maxY: graphData!
                        .map((e) => e.y)
                        .reduce((a, b) => a > b ? a : b),
                    lineBarsData: [
                      LineChartBarData(
                        spots: graphData!,
                        isCurved: true,
                        color: Theme.of(context).colorScheme.onPrimary,
                        barWidth: 3,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
