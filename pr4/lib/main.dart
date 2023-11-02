import 'dart:math';

import 'package:pr4/elementProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void toPage(String text, BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => Page(text: text))));
}

void pushAndRemoveUntil(String text, BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => Page(text: text))));
}

void main() {
  ElementProvider elem = ElementProvider();
  runApp(
    ChangeNotifierProvider.value(
      value: elem,
      child: MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == "/pushAndRemoveUntil") {
            return MaterialPageRoute(
                builder: (context) =>
                    Page(text: 'Использование pushAndRemoveUntil'));
          }
          if (settings.name == "/pushReplace ") {
            return MaterialPageRoute(
                builder: (context) => Page(text: 'Использование pushReplace '));
          } else if (settings.name == '/toMain') {
            return MaterialPageRoute(builder: (context) => MainApp());
          }
        },
        title: "PR4",
        home: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  void removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  final List<int> _items = List<int>.generate(50, (int index) => index);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ElementProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/pushAndRemoveUntil', (route) => false);
                  },
                  child: Text('Использование pushAndRemove')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Page(text: 'Использование pushReplace')));
                    ;
                  },
                  child: Text('Использование pushReplace')),
              Expanded(
                child: ReorderableListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                  children: <Widget>[
                    for (int index = 0; index < _items.length; index += 1)
                      RowElem(
                        key: Key('$index'),
                        index: index,
                        text: 'Элемент ${_items[index]}',
                        items: _items,
                        deleteElem: removeItem,
                        type: 'base',
                      )
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final int item = _items.removeAt(oldIndex);
                      _items.insert(newIndex, item);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String text;
  const Page({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: text);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
            TextField(
              controller: textEditingController,
              readOnly: true,
            )
          ],
        ),
      ),
    );
  }
}

class RowElem extends StatefulWidget {
  final int index;
  final String text;
  final List<int>? items;
  final Function(int) deleteElem;
  final String type;

  const RowElem(
      {required this.index,
      required this.text,
      this.items,
      required this.deleteElem,
      Key? key,
      required this.type})
      : super(key: key);
  @override
  RowElemState createState() => RowElemState();
}

class RowElemState extends State<RowElem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(widget.text)),
            onTap: () {
              if (widget.type == 'base') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => Page(text: widget.text))));
              }
              if (widget.type == "pushAndRemoveUntil") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Page(text: widget.text)),
                    (route) => false);
              }
            },
          ),
        ),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => Page(text: widget.text))));
            }),
        IconButton(
            onPressed: () {
              setState(() {
                widget.deleteElem(widget.index);
              });
            },
            icon: Icon(Icons.delete)),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
      ],
    );
  }
}
