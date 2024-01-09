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

  final _formKey = GlobalKey<FormState>(); // different from value key. It is used to identify the form and validate it.

  saveItem(){
    _formKey.currentState!.validate(); // validates the form
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // used to identify the form and validate it.
          child: Column(children: [
            TextFormField(
              // instead of textfield, we use textformfield
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Item Name',
              ),
              validator: (value) {
                if (value == null || 
                    value.isEmpty || 
                    value.trim().length <= 1 || 
                    value.trim().length > 50) {
                  return 'Please enter a valid item name.';
                }
                return null;
              },
            ),
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end, // used it to allign both lines.
              children: [
                Expanded(
                  // Used it because both row and text form fiels and horizontally unconstrained.
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                    initialValue: "1",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                if (value == null || 
                    value.isEmpty || 
                    int.tryParse(value) == null || 
                    int.tryParse(value)! <= 0) {
                  return 'Please enter a valid positive number.';
                }
                return null;
              },
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
                  onPressed: saveItem,
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
