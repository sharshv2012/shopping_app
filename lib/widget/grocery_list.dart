import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widget/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  var isLoading = true;

  var errorHappened = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'first-project-59e18-default-rtdb.asia-southeast1.firebasedatabase.app',
        'grocery_items.json');

    final response = await http.get(url);

    final statusCode = response.statusCode;

    if (statusCode >= 400) {
      setState(() {
        errorHappened = true;
      });
    }

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (categoryItem) => // used firstwhere to get the first item that matches the condition.
                  categoryItem.value.title == item.value['category'])
          .value; // to get the category object by comparing the title of the category.

      loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }

    setState(() {
      _groceryItems = loadedItems;
      isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newItem != null) {
      // did'nt call the get method to avoid redudant calls.
      setState(() {
        _groceryItems.add(newItem);
      });
    } else {
      return;
    }
  }

  void _deleteItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    var undoPressed = false;

    setState(() {
      _groceryItems.remove(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item deleted!'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            undoPressed = true;
            setState(() {
              _groceryItems.insert(index, item);
            });
          },
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (undoPressed) {
      return;
    }

    final url = Uri.https(
      'first-project-59e18-default-rtdb.asia-southeast1.firebasedatabase.app',
      'grocery_items/${item.id}.json',
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deletion failed!'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("No Groceries Yet!"));

    if (isLoading) {
      content =
          const Center(child: CircularProgressIndicator()); // loading spinner.
    }

    if (errorHappened) {
      content = const Center(child: Text("An error occured! Try again later."));
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems
            .length, // so flutter knows how often the builder will be called.
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) => setState(() {
            _deleteItem(_groceryItems[index]);
          }),
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addItem),
        ],
      ),
      body: content,
    );
  }
}
