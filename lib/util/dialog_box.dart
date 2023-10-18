import 'package:flutter/material.dart';
import 'package:to_do_list/util/my_button.dart';

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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff522B5B),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('Görev Ekle'),
      ),
      backgroundColor: const Color(0xff86A8cf),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Yeni bir tane ekle !',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline4?.fontSize,
                ),
              ),
              subtitle: Text(
                'Bana Görevinden Bahset :)',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6?.fontSize,
                ),
              ),
            ),
            const SizedBox(height: 15),
            //get user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Görevim ',
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Save Button
                MyButton(
                  text: 'Şimdi Oluştur',
                  onPressed: onSave,
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
