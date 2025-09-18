import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Turn raw Report Services data into FlChart widgets
class ChartServices {
  /// Line Chart → sales per day per shift
  static LineChartData salesLine(List<Map<String, dynamic>> raw) {
    final grouped = <String, Map<String, double>>{};
    for (var r in raw) {
      final date = r['date'] as String;
      final shift = r['shift_type'] as String;
      final total = (r['total'] as int).toDouble();
      grouped.putIfAbsent(date, () => {});
      grouped[date]![shift] = total;
    }

    final dates = grouped.keys.toList()..sort();
    final shifts = {'morning', 'afternoon', 'evening'};
    final colors = {
      'morning': 0xff4caf50,
      'afternoon': 0xffff9800,
      'evening': 0xff2196f3,
    };

    final lineBars = shifts.map((shift) {
      final spots = <FlSpot>[];
      for (int i = 0; i < dates.length; i++) {
        spots.add(FlSpot(i.toDouble(), grouped[dates[i]]![shift] ?? 0));
      }
      return LineChartBarData(
        spots: spots,
        isCurved: true,
        color: Color(colors[shift]!),
        dotData: FlDotData(show: false),
      );
    }).toList();

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) =>
                Text(dates[value.toInt()].substring(5)),
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: lineBars.toList(),
    );
  }

  /// Bar chart → expenses per day
  static BarChartData expensesBar(List<Map<String, dynamic>> raw) {
    final grouped = <String, double>{};
    for (var r in raw) {
      final date = r['date'] as String;
      final total = (r['total'] as int).toDouble();
      grouped[date] = (grouped[date] ?? 0) + total;
    }
    final dates = grouped.keys.toList()..sort();

    final bars = dates
        .map((date) => BarChartGroupData(
              x: dates.indexOf(date),
              barRods: [
                BarChartRodData(toY: grouped[date]!, color: Colors.redAccent)
              ],
            ))
        .toList();

    return BarChartData(
      barGroups: bars,
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) =>
                Text(dates[value.toInt()].substring(5)),
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
    );
  }
}
