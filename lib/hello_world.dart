import 'dart:ffi';
import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:udp/udp.dart';

class HelloWorldPage extends StatefulWidget {
	@override
	_HelloWorldPagState createState() => _HelloWorldPagState();
}

class _HelloWorldPagState extends State<HelloWorldPage> {
	late ARKitController arkitController;
	Vector3 position = Vector3(0, 0, 0);
	Quaternion quaternion = Quaternion(0, 0, 0, 1);
	// creates a UDP instance and binds it to the first available network
	// interface on port 65000.
	late UDP sender;

	void update(double time) async {
		updateTransform();
	}

	void updateTransform() async {
		Matrix4? mat = await arkitController.pointOfViewTransform();
		if (mat != null) {
			position = mat.getTranslation();
			quaternion = Quaternion.fromRotation(mat.getRotation());
		}

		sendPacket();
	}

  // Specifically for use in Unreal Engine Live Link
	void sendPacket() async {
		String data = "${position.x*100} ${position.y*100} ${position.z*100} ${quaternion.x} ${quaternion.z} ${quaternion.y} ${quaternion.w}";
    int dataLength = await sender.send(data.codeUnits, Endpoint.broadcast(port: Port(54321)));
	}

	@override
	void dispose() {
		arkitController.dispose();
		sender.close();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(
			title: const Text('ARKit in Flutter'),
		),
		body: Container(
			child: ARKitSceneView(
				onARKitViewCreated: onARKitViewCreated,
				environmentTexturing:
					ARWorldTrackingConfigurationEnvironmentTexturing.automatic,
			),
		),
	);

	void onARKitViewCreated(ARKitController arkitController) async {
		this.arkitController = arkitController;
		sender = await UDP.bind(Endpoint.any(port: Port(5649)));
		arkitController.updateAtTime = (time) => update(time);

		this.arkitController.add(_createSphere());
	}

	ARKitNode _createSphere() => ARKitNode(
		geometry:
				ARKitSphere(materials: _createRandomColorMaterial(), radius: 0.04),
		position: Vector3(0, 0, 0),
	);

	final _rnd = math.Random();
	List<ARKitMaterial> _createRandomColorMaterial() {
		return [
			ARKitMaterial(
				lightingModelName: ARKitLightingModel.physicallyBased,
				metalness: ARKitMaterialProperty.value(_rnd.nextDouble()),
				roughness: ARKitMaterialProperty.value(_rnd.nextDouble()),
				diffuse: ARKitMaterialProperty.color(
					Color((_rnd.nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
				),
			)
		];
	}
}