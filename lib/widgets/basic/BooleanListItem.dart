import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class BooleanListItem extends StatelessWidget {
  final Habit habit;
  final DateTime date;
  BooleanListItem({this.habit, this.date});

  @override
  Widget build(BuildContext context) {
    //
    var subtitleStyle = Theme.of(context).textTheme.subtitle2;

    var backgroundColor = this.habit.ynCompleted
        ? Theme.of(context).primaryColor.withAlpha(10)
        : Theme.of(context).scaffoldBackgroundColor;

    var borderColor = this.habit.ynCompleted
        ? Theme.of(context).primaryColor.withAlpha(80)
        : Theme.of(context).textTheme.subtitle2.color.withAlpha(50);

    var _icon = this.habit.ynCompleted
        ? Icon(Icons.check_circle, color: Theme.of(context).accentColor)
        : Icon(
            Icons.panorama_fish_eye,
            color: Theme.of(context).primaryColor.withAlpha(200),
          );

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: ListTile(
        dense: true,
        title: Hero(
          tag: 'habit-title-' + this.habit.id.toString(),
          child: Text(
            this.habit.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        subtitle: Text(this.habit.reminder, style: subtitleStyle),
        trailing: IconButton(
          icon: _icon,
          onPressed: () => debugPrint('habbit marked completed'),
        ),
        onTap: () => Navigator.pushNamed(
          context,
          '/habit/progress',
          arguments: this.habit,
        ),
      ),
    );
  }
}
