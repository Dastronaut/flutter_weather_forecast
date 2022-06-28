import 'package:flutter/material.dart';

class SubWeather extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String description;

  const SubWeather({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: Icon(
            icon,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontFamily: 'flutterfonts',
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 28,
                fontFamily: 'flutterfonts',
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontFamily: 'flutterfonts',
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
        ),
      ]),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white.withOpacity(0.65),
      ),
    );
  }
}
