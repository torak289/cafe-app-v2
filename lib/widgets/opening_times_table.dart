import 'package:flutter/material.dart';

class OpeningTimes extends StatelessWidget {
  const OpeningTimes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(24),
        1: IntrinsicColumnWidth(),
        2: FixedColumnWidth(32),
        3: FixedColumnWidth(64),
        4: FixedColumnWidth(16),
        5: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Monday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Tuesday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Wednesday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Thursday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Friday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Saturday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
        TableRow(
          children: [
            Checkbox(
                value: false,
                onChanged: (bool? value) {
                  value = !value!;
                }),
            const Text(
              "Sunday",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("From:"),
            TextFormField(),
            const Text("To:"),
            TextFormField()
          ],
        ),
      ],
    );
  }
}
