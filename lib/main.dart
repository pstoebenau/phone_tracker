import 'package:phone_tracker/hello_world.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phone_tracker/providers/settings_provider.dart';

void main() => runApp(
  MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Settings()),
  ],
  child: MaterialApp(home: MyApp()),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final samples = [
      Sample(
        'LiveLink Tracker',
        'Use your phone to control a camera in UE4.',
        Icons.home,
        () => Navigator.of(context)
            .push<void>(MaterialPageRoute(builder: (c) => HelloWorldPage())),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ARKit Demo'),
      ),
      body: ListView(
        children: [
          SampleItem(item: samples[0]),
          SettingsForm(),
        ]
      ),
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
class SettingsForm extends StatefulWidget {
  SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  String positionAxis = "xyz";
  String rotationAxis = "xyz";
  double rotOffsetX = 0;
  double rotOffsetY = 0;
  double rotOffsetZ = 0;
  double posMultX = 1;
  double posMultY = 1;
  double posMultZ = 1;
  double rotMultX = 1;
  double rotMultY = 1;
  double rotMultZ = 1;

  void saveFormToProvider() {
    Settings settings = context.read<Settings>();
    settings.setPositionAxis(positionAxis);
    settings.setRotationAxis(rotationAxis);
    settings.setRotOffset(rotOffsetX, rotOffsetY, rotOffsetZ);
    settings.setRotMult(rotMultX, rotMultY, rotMultZ);
    settings.setPosMult(posMultX, posMultY, posMultZ);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged:(value) => positionAxis = value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Position Axis",
          ),
        ),
        TextField(
          onChanged:(value) => rotationAxis = value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Rotation Axis",
          ),
        ),
        TextField(
          onChanged:(value) => rotOffsetX = double.parse(value),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Rotation Offset X",
          ),
        ),
        TextField(
          onChanged:(value) => rotOffsetY = double.parse(value),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Rotation Offset Y",
          ),
        ),
        TextField(
          onChanged:(value) => rotOffsetZ = double.parse(value),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Rotation Offset Z",
          ),
        ),
        const Text("Position Invert"),
        ElevatedButton(
          onPressed: () => setState(() {
            posMultX *= -1;
          }),
          child: Text("X: ${posMultX}"),
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            posMultY *= -1;
          }),
          child: Text("Y: ${posMultY}"),
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            posMultZ *= -1;
          }),
          child: Text("Z: ${posMultZ}"),
        ),
        const Text("Rotation Invert"),
        ElevatedButton(
          onPressed: () => setState(() {
            rotMultX *= -1;
          }),
          child: Text("X: ${rotMultX}"),
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            rotMultY *= -1;
          }),
          child: Text("Y: ${rotMultY}"),
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            rotMultZ *= -1;
          }),
          child: Text("Z: ${rotMultZ}"),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => saveFormToProvider(),
            child: const Text("Save"),
          ),
        ),
        Text(context.watch<Settings>().positionAxis),
        Text("${context.watch<Settings>().posMult}"),
        Text(context.watch<Settings>().rotationAxis),
        Text("${context.watch<Settings>().rotOffset}"),
        Text("${context.watch<Settings>().rotMult}"),
      ],
    );
  }
}