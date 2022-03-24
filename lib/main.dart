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
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
  int rotationAxis = 0;
  double rotOffsetX = 0;
  double rotOffsetY = 0;
  double rotOffsetZ = 0;
  double rotMultX = 1;
  double rotMultY = 1;
  double rotMultZ = 1;

  void saveFormToProvider() {
    Settings settings = context.read<Settings>();
    settings.setRotationAxis(rotationAxis);
    settings.setRotOffset(rotOffsetX, rotOffsetY, rotOffsetZ);
    settings.setRotMult(rotMultX, rotMultY, rotMultZ);
  }
  
  Widget CustomRadioButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          rotationAxis = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: (rotationAxis == index) ? Colors.green : Colors.black,
        ),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: (rotationAxis == index) ? Colors.green : Colors.black),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                CustomRadioButton("xyz", 0),
                CustomRadioButton("xzy", 1),
                CustomRadioButton("yxz", 2),
              ],
            ),
            Row(
              children: [
                CustomRadioButton("yzx", 3),
                CustomRadioButton("zxy", 4),
                CustomRadioButton("zyx", 5),
              ],
            )
          ],
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
        ElevatedButton(
          onPressed: () => setState(() {
            rotMultX *= -1;
          }),
          child: Text("Rotation Inert X: ${rotMultX}"),
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            rotMultY *= -1;
          }),
          child: Text("Rotation Inert Y: ${rotMultY}"),
        ),
        ElevatedButton(
          onPressed: () => setState(() {
            rotMultZ *= -1;
          }),
          child: Text("Rotation Inert Z: ${rotMultZ}"),
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
        Text("${context.watch<Settings>().rotationAxis}"),
        Text("${context.watch<Settings>().rotOffset}"),
        Text("${context.watch<Settings>().rotMult}"),
      ],
    );
  }
}