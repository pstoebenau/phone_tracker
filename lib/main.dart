import 'package:phone_tracker/hello_world.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final samples = [
      Sample(
        'Hello World',
        'The simplest scene with all geometries.',
        Icons.home,
        () => Navigator.of(context)
            .push<void>(MaterialPageRoute(builder: (c) => HelloWorldPage())),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ARKit Demo'),
      ),
      body:
          ListView(children: samples.map((s) => SampleItem(item: s)).toList()),
    );
  }
}

class SampleItem extends StatelessWidget {
  const SampleItem({
    required this.item,
    Key? key,
  }) : super(key: key);
  final Sample item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => item.onTap(),
        child: ListTile(
          leading: Icon(item.icon),
          title: Text(
            item.title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          subtitle: Text(
            item.description,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }
}

class Sample {
  const Sample(this.title, this.description, this.icon, this.onTap);
  final String title;
  final String description;
  final IconData icon;
  final Function onTap;
}
