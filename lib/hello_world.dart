import 'dart:ffi';
import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:udp/udp.dart';
import 'package:provider/provider.dart';
import 'package:phone_tracker/providers/settings_provider.dart';

class HelloWorldPage extends StatefulWidget {
	@override
	_HelloWorldPagState createState() => _HelloWorldPagState();
}

class _HelloWorldPagState extends State<HelloWorldPage> {
	late ARKitController arkitController;
	Vector3 position = Vector3(0, 0, 0);
	Vector3 rotation = Vector3(0, 0, 0);
	Quaternion quaternion = Quaternion(0, 0, 0, 1);
	// creates a UDP instance and binds it to the first available network
	// interface on port 65000.
	late UDP sender;

	void update(double time) async {
		updateTransform();
	}

	void updateTransform() async {
    Settings settings = context.read<Settings>();
    RotationAxis rotationAxis = settings.rotationAxis;
    Vector3 rotOffset = Vector3.array(settings.rotOffset).scaled(math.pi/180);
    Vector3 rotMult = Vector3.array(settings.rotMult);

		Matrix4? mat = await arkitController.pointOfViewTransform();
		if (mat != null) {
			position = mat.getTranslation().scaled(100);
			position.multiply(Vector3(1, 1, -1));
			quaternion = Quaternion.fromRotation(mat.getRotation());

			Vector3 rot = QuaternionToEuler(quaternion);
      Vector3 UE4Rot = Vector3(rot.x, rot.y, rot.z);
      if (rotationAxis == RotationAxis.xzy) {
        UE4Rot = Vector3(rot.x, rot.z, rot.y);
      }
      else if (rotationAxis == RotationAxis.yxz) {
        UE4Rot = Vector3(rot.y, rot.x, rot.z);
      }
      else if (rotationAxis == RotationAxis.yzx) {
        UE4Rot = Vector3(rot.y, rot.z, rot.x);
      }
      else if (rotationAxis == RotationAxis.zxy) {
        UE4Rot = Vector3(rot.z, rot.x, rot.y);
      }
      else if (rotationAxis == RotationAxis.zyx) {
        UE4Rot = Vector3(rot.z, rot.y, rot.x);
      }
      UE4Rot.add(rotOffset);
      UE4Rot.multiply(rotMult);
			quaternion = EulerToQuaternion(UE4Rot);
      rotation = QuaternionToEuler(quaternion);
		}

		sendPacket();
	}

  Quaternion EulerToQuaternion(Vector3 e) {
    double cy = math.cos(e.z * 0.5);
    double sy = math.sin(e.z * 0.5);
    double cp = math.cos(e.y * 0.5);
    double sp = math.sin(e.y * 0.5);
    double cr = math.cos(e.x * 0.5);
    double sr = math.sin(e.x * 0.5);

    double w = cr * cp * cy + sr * sp * sy;
    double x = sr * cp * cy - cr * sp * sy;
    double y = cr * sp * cy + sr * cp * sy;
    double z = cr * cp * sy - sr * sp * cy;

    return Quaternion(x, y, z, w);
  }

  Vector3 QuaternionToEuler(Quaternion q) {
    double sinr_cosp = 2 * (q.w*q.x + q.y*q.z);
    double cosr_cosp = 1 - 2 * (q.x*q.x + q.y*q.y);
    double rotX = math.atan2(sinr_cosp, cosr_cosp);

    double sinp = 2 * (q.w * q.y - q.z * q.x);
    double rotY;
    if (sinp.abs() >= 1) {
      rotY = math.pi/2 * sinp.sign;
    }
    else {
      rotY = math.asin(sinp);
    }

    double siny_cosp = 2 * (q.w * q.z + q.x * q.y);
    double cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z);
    double rotZ = math.atan2(siny_cosp, cosy_cosp);

    return Vector3(rotX, rotY, rotZ);
  }

  // Specifically for use in Unreal Engine Live Link
	void sendPacket() async {
		String data = getPacketData();
    int dataLength = await sender.send(data.codeUnits, Endpoint.broadcast(port: Port(54321)));
	}

	String getPacketData() {
    // return rotation.scaled(180/math.pi).toString();
		return "${position.y} ${position.x} ${position.z} ${quaternion.x} ${quaternion.y} ${quaternion.z} ${quaternion.w}";
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
		floatingActionButton: FloatingActionButton(
			onPressed: () => debugPrint(getPacketData()),
			tooltip: 'Increment',
			child: const Icon(Icons.add),
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
				ARKitSphere(materials: _createRandomColorMaterial(), radius: 0.01),
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
					Color((_rnd.nextDouble() * 0xFF0000).toInt() << 0).withOpacity(1.0),
				),
			)
		];
	}
}