import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<
      FormState>(); // different from value key. It is used to identify the form and validate it.

  var _enteredName = '';

  var _enteredQuantity = 1;

  var _selectedCategory = categories[Categories.vegetables]!;

  var isSending = false;

  saveItem() async {
    var validate = _formKey.currentState!.validate(); // validates the form

    if (validate) {
      // save only when value is valid.

      setState(() {
        // needed setState so the buttons can be disabled.
        isSending = true;
      });

      _formKey.currentState!.save(); // saves the form

      final url = Uri.https(
          'first-project-59e18-default-rtdb.asia-southeast1.firebasedatabase.app',
          'grocery_items.json');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title
          },
        ),
      );

      print(response.body);
      print(response.statusCode);

      final Map<String, dynamic> resData = json.decode(response.body);
      // we get the ID as name in the response body.

      if (!context.mounted) {
        // tells if the widget is the part of the screen(mounted) or not
        return; // below code wont be executed if the widget is not mounted.
      }

      //Navigator.of(context).pop(); // closes the current screen.

      Navigator.of(context).pop(GroceryItem(
          // No need to send any data now.
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory)); // closes the current screen.

      //_formKey.currentState!.reset(); // resets the form  after saving it.
    }
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
              onSaved: (value) {
                _enteredName = value!;
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
                    initialValue: _enteredQuantity.toString(),
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
                    onSaved: (value) {
                      _enteredQuantity = int.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  // same reason as above
                  child: DropdownButtonFormField(
                      items: [
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
                      ],
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          // so currently selected value is updated on the screen.
                          _selectedCategory = value as Category;
                        });
                      }),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            // if isSending is true, then the button is disabled.
                            _formKey.currentState!.reset(); // resets the form
                          },
                    child: const Text('Reset')),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: isSending ? null : saveItem,
                  child: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Add Item'),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
