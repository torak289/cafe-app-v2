import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditableCafeNameField extends StatefulWidget {
  final CafeModel cafe;
  final Function callback;
  const EditableCafeNameField({
    super.key,
    required this.cafe,
    required this.callback,
  });

  @override
  State<EditableCafeNameField> createState() => _EditableCafeNameFieldState();
}

class _EditableCafeNameFieldState extends State<EditableCafeNameField> {
  TextEditingController editingController = TextEditingController();
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    DatabaseService database = Provider.of(context, listen: false);
    if (isEditing) {
      return Row(
        children: [
          SizedBox(
            width: 240,
            child: TextField(
              enableSuggestions: false,
              controller: editingController,
            ),
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          GestureDetector(
            onTap: () async {
              String res =
                  await database.editCafeName(editingController.text.trim());
              if (res == "Success") {
                setState(
                  () {
                    isEditing = false;
                    editingController.clear();
                    //widget.callback.call();
                    //TODO: Implement parent set state rebuild...
                  },
                );
              } else {
                debugPrint(res);
                setState(() {
                  //TODO: Implement Error State
                });
              }
            },
            child: const Icon(
              Icons.save_rounded,
              color: CafeAppUI.iconButtonIconColor,
              size: 16,
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Text('${widget.cafe.name}'),
          const Padding(padding: EdgeInsets.all(2)),
          widget.cafe.verified!
              ? const Icon(
                  Icons.verified,
                  color: Colors.pinkAccent,
                  size: 16,
                )
              : const SizedBox.shrink(),
          const Padding(padding: EdgeInsets.all(8)),
          GestureDetector(
            onTap: () async {
              setState(() {
                isEditing = true;
                editingController.text = widget.cafe.name!;
              });
            },
            child: const Icon(
              Icons.edit_rounded,
              size: 16,
              color: Colors.black,
            ),
          ),
        ],
      );
    }
  }
}
