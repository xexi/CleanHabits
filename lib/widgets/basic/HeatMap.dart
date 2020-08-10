import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';

class HeatMap extends StatelessWidget {
  final Map<DateTime, int> data;
  final String type;
  final ValueChanged<String> onFilter;

  HeatMap({this.data, this.type, this.onFilter});

  Widget _typeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        items: ["Show All", "Completed", "Started", "Skipped"]
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        value: this.type,
        onChanged: (e) => onFilter(e),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    var _weekDaysLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    var _monthsLabels = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    var minThreshold = data.values.reduce(min);
    var avgThreshold =
        data.values.reduce((a, b) => a + b) ~/ data.values.length;
    var maxThreshold = data.values.reduce(max);
    var _colorThresholds = {
      minThreshold == 0 ? 1 : minThreshold: accentColor.withAlpha(75),
      ((avgThreshold - minThreshold) / 2 + minThreshold).toInt():
          accentColor.withAlpha(100),
      avgThreshold: accentColor.withAlpha(130),
      ((maxThreshold - avgThreshold) / 2 + avgThreshold).toInt():
          accentColor.withAlpha(180),
      maxThreshold: accentColor.withAlpha(255),
    };

    var widgetList = <Widget>[
      ListTile(
        dense: true,
        title: Text(
          'Daily Tracker',
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: _typeDropDown(),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: HeatMapCalendar(
          input: data,
          colorThresholds: _colorThresholds,
          weekDaysLabels: _weekDaysLabels,
          monthsLabels: _monthsLabels,
          squareSize: 24.0,
          textOpacity: 0.3,
          labelTextColor: Colors.blueGrey,
        ),
      )
    ];
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
