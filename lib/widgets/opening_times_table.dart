import 'package:flutter/material.dart';

class OpeningTimes extends StatefulWidget {

  //TODO: Implement backend 
  //TODO: Implement future builder
  //TODO: Impelement local states
  bool monday = false;

  bool tuesday = false;

  bool wednesday = false;

  bool thursday = false;

  bool friday = false;

  bool saturday = false;

  bool sunday = false;

  OpeningTimes({
    super.key,
  });

  @override
  State<OpeningTimes> createState() => _OpeningTimesState();
}

class _OpeningTimesState extends State<OpeningTimes> {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(24),
        1: IntrinsicColumnWidth(),
        2: FixedColumnWidth(32),
        3: FixedColumnWidth(64),
        4: FixedColumnWidth(24),
        5: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Checkbox(
              value: widget.monday,
              onChanged: (value) {
                setState(() {
                  widget.monday = !widget.monday;
                });
              },
            ),
            const Text(
              "Monday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(
              keyboardType: TextInputType.datetime,
            ),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
              value: widget.tuesday,
              onChanged: (value) {
                setState(() {
                  widget.tuesday = !widget.tuesday;
                });
              },
            ),
            const Text(
              "Tuesday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
              value: widget.wednesday,
              onChanged: (value) {
                setState(() {
                  widget.wednesday = !widget.wednesday;
                });
              },
            ),
            const Text(
              "Wednesday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
              value: widget.thursday,
              onChanged: (value) {
                setState(() {
                  widget.thursday = !widget.thursday;
                });
              },
            ),
            const Text(
              "Thursday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
              value: widget.friday,
              onChanged: (value) {
                setState(() {
                  widget.friday = !widget.friday;
                });
              },
            ),
            const Text(
              "Friday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
              value: widget.saturday,
              onChanged: (value) {
                setState(() {
                  widget.saturday = !widget.saturday;
                });
              },
            ),
            const Text(
              "Saturday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
              value: widget.sunday,
              onChanged: (value) {
                setState(() {
                  widget.sunday = !widget.sunday;
                });
              },
            ),
            const Text(
              "Sunday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:", textAlign: TextAlign.center),
            TextFormField()
          ],
        ),
      ],
    );
  }
}
