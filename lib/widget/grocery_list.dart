import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  final List<GroceryItem> _groceryItems = [];
  void _addItem() async{
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
    if(newItem == null){
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget content = const Center(
      child: Text("No Groceries Yet!")
    );

    if(_groceryItems.isNotEmpty){
      content = ListView.builder(
        itemCount: _groceryItems
            .length, // so flutter knows how often the builder will be called.
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) => setState(() {
            _groceryItems.removeAt(index);
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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem
          ),],
      ),
      body: content,
    );
  }
}
