import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(children: [
            TextFormField(
              // instead of textfield, we use textformfield
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Item Name',
              ),
              validator: (value) {
                return "demo...";
              },
            ),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end, // used it to allign both lines.
              children: [
                Expanded(
                  // Used it because both row and text form fiels and horizontally unconstrained.
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                    ),
                    initialValue: "1",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // same reason as above
                  child: DropdownButtonFormField(items: [
                    for (final category in categories
                        .entries) // categories.entries providesv us with a list of map entries
                      DropdownMenuItem(
                        value: category.value,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: category.value.color,
                            ),
                            const SizedBox(width: 8),
                            Text(category.value.title)
                          ],
                        ),
                      ),
                  ], onChanged: (value) {}),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () {}, child: const Text('Reset')),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add Item'),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
