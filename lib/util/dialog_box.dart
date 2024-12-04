import 'package:flutter/material.dart';
import 'package:todoapp/components/color_components.dart';
import 'package:todoapp/custom_keys/keys.dart';
import 'package:todoapp/util/my_button.dart';

class DialogBox extends StatelessWidget {
  late final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCustom.scafoldbackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorCustom.scafoldbackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                textAlign: TextAlign.start,
                CustomKeys.listTilesubTitleKonu,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                ),
              ),
            ),
            const SizedBox(height: 15),
            //get user input
            TextFormField(
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus!.unfocus(),
              maxLines: null,
              style: const TextStyle(fontSize: 20),
              controller: controller,
              decoration: InputDecoration(
                labelStyle: const TextStyle(fontSize: 20),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorCustom.dialogboxtextfield,
                    width: 3,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorCustom.dialogboxtextfield,
                    width: 2,
                  ),
                ),
                hintText: CustomKeys.textFieldHintText,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Save Button
                MyButton(
                  text: CustomKeys.myButtonName,
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(CustomKeys.snackBarTitle),
                        ),
                      );
                    }
                    onSave();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
