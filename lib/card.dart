import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_listtt/todo_card.dart';
import 'database_helper.dart';
import 'fake_data.dart';
import 'model.dart';
import 'todo.dart';
import 'calendar.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

class todoCard extends StatelessWidget {
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    bool isDone = true;
    return Scaffold(
      body: Stack(
        children: [
          //other page background
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                HeroDialogRoute(
                    builder: (context) => todoButton()
                ),
              );
            },
            child: Container(
              color: Colors.black.withOpacity(isDone ? 0.5 : 0),
            ),
          ),

          //main page
          GestureDetector(
            onTap: () {
              isDone = !isDone;
            },
            child: Hero(
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                tag: "Popup",
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFF8BE1D8),
                            ),
                          ),
                          Text(
                            " ",
                          )
                        ],
                      ),
                    ),
              ),
                ),
            ),
          ),
          isDone ? Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width * 0.05,
                            MediaQuery.of(context).size.height * 0.05),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.9,
                child: calendar()
            ),
          ) : Null,
          isDone ? SafeArea(
            child: Expanded(
              child: ScrollConfiguration(
                child: StreamBuilder(
                  initialData: [],
                  stream: _dbHelper.getTasks().asStream(),
                  builder: (context,snapshot){
                    if (!snapshot.hasData){
                      return Text("test");
                    }
                    return ScrollConfiguration(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return _TodoListContent(

                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ) : Null,
          isDone ? AddTodoButton() : Null,
        ],
      ),
    );
  }
}

class _TodoListContent extends StatelessWidget {
  const _TodoListContent({
    Key key,
    @required this.todos,
  }) : super(key: key);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Transform.translate(
                offset: Offset(MediaQuery.of(context).size.width * 0.12,
                               MediaQuery.of(context).size.height * -0.04),
                child: ListView.builder(
                  itemCount: todos.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final _todo = todos[index];
                    return _TodoCard(todo: _todo);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// {@template todo_card}
/// Card that display a [Todo]'s content.
///
/// On tap it opens a [HeroDialogRoute] with [_TodoPopupCard] as the content.
/// {@endtemplate}
class _TodoCard extends StatelessWidget {
  /// {@macro todo_card}
  const _TodoCard({
    Key key,
    @required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: _TodoPopupCard(todo: todo),
            ),
          ),
        );
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        tag: todo.id,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  _TodoTitle(title: todo.description),
                  const SizedBox(
                    height: 8,
                  ),
                  if (todo.items != null) ...[
                    const Divider(),
                    _TodoItemsBox(items: todo.items),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template todo_title}
/// Title of a [Todo].
/// {@endtemplate}
class _TodoTitle extends StatelessWidget {
  /// {@macro todo_title}
  const _TodoTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}

/// {@template todo_popup_card}
/// Popup card to expand the content of a [Todo] card.
///
/// Activated from [_TodoCard].
/// {@endtemplate}
class _TodoPopupCard extends StatelessWidget {
  const _TodoPopupCard({Key key, this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: todo.id,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TodoTitle(title: todo.description),
                      const SizedBox(
                        height: 8,
                      ),
                      if (todo.items != null) ...[
                        const Divider(),
                        _TodoItemsBox(items: todo.items),
                      ],
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const TextField(
                          maxLines: 8,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Write a note...',
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template todo_items_box}
/// Box containing the list of a [Todo]'s items.
///
/// These items can be checked.
/// {@endtemplate}
class _TodoItemsBox extends StatelessWidget {
  /// {@macro todo_items_box}
  const _TodoItemsBox({
    Key key,
    @required this.items,
  }) : super(key: key);

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) _TodoItemTile(item: item),
      ],
    );
  }
}

/// {@template todo_item_template}
/// An individual [Todo] [Item] with its [Checkbox].
/// {@endtemplate}
class _TodoItemTile extends StatefulWidget {
  /// {@macro todo_item_template}
  const _TodoItemTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  _TodoItemTileState createState() => _TodoItemTileState();
}

class _TodoItemTileState extends State<_TodoItemTile> {
  void _onChanged(bool val) {
    setState(() {
      widget.item.completed = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        onChanged: _onChanged,
        value: widget.item.completed,
      ),
      title: Text(widget.item.description),
    );
  }
}

