import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ViewerTournamentsCalendarScreen extends StatefulWidget {
  const ViewerTournamentsCalendarScreen({super.key});

  static const path = "viewer_tournaments_calendar";

  @override
  State<ViewerTournamentsCalendarScreen> createState() => _ViewerTournamentsCalendarScreenState();
}

class _ViewerTournamentsCalendarScreenState extends State<ViewerTournamentsCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    //todo
    return Container(
      color: Colors.lightBlue,
    );
  }
}
