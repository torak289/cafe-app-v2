import 'package:cafeapp_v2/constants/cafe_app_ui.dart';
import 'package:cafeapp_v2/data_models/cafe_model.dart';
import 'package:cafeapp_v2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditLargeTextField extends StatefulWidget {
  final CafeModel cafe;
  final Function callback;
  late bool isEditing = false;
  EditLargeTextField({
    super.key,
    required this.cafe,
    required this.callback,
  });

  @override
  State<EditLargeTextField> createState() => _EditableCafeNameFieldState();
}

class _EditableCafeNameFieldState extends State<EditLargeTextField> {
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DatabaseService database = Provider.of(context, listen: false);
    if (widget.isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              enableSuggestions: false,
              controller: editingController,
              minLines: 5,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(CafeAppUI.buttonSpacingMedium)),
          GestureDetector(
            onTap: () async {
              String res = await database
                  .editCafeDescription(editingController.text.trim());
              if (res == "Success") {
                setState(
                  () {
                    widget.isEditing = false;
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${widget.cafe.description}'),
          GestureDetector(
            onTap: () async {
              setState(() {
                widget.isEditing = true;
                editingController.text = widget.cafe.description!;
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
