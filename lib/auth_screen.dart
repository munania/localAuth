import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final LocalAuthentication authentication;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    authentication = LocalAuthentication();
    authentication.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BIOMETRICS AUTH"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///CHECK IF DEVICE IS SUPPORTED
          if (_supportState)
            const Text('The device is supported')
          else
            const Text('The device is not supported'),

          ///GET AVAILABLE BIOMETRICS TYPE
          ElevatedButton(
            onPressed: _getAvailableBiometrics,
            child: Text("Get Available Biometrics"),
          ),
          const Divider(height: 100),
          //AUTHENTICATE
          ElevatedButton(onPressed: _authenticate, child: Text('Authenticate')),
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await authentication.authenticate(
          localizedReason: "Authenticate to access your data",
          options:
              AuthenticationOptions(stickyAuth: true, biometricOnly: false));
      print("Authenticated: $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await authentication.getAvailableBiometrics();
    print("List of available biometrics: $availableBiometrics");
    if (!mounted) {
      return;
    }
    //then we call setState
  }
}
