import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var localAuth = LocalAuthentication();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  bool canCheckBiometrics = false;
  List<BiometricType> listaBiometrics;
  String authorized = 'Não Autorizado';

  checkBiometrics() async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    print(canCheckBiometrics);

    setState(() => loading = false);
  }

  availableBiometrics() async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1));
    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();

    print(availableBiometrics);

    listaBiometrics = availableBiometrics;
    setState(() {});
    setState(() => loading = false);
    
  }

  authenticate() async {
    
    bool authenticated = false;
    await Future.delayed(Duration(seconds: 1));
    
    try {
      authenticated = await localAuth.authenticateWithBiometrics(
        localizedReason: '',
        useErrorDialogs: true,
        stickyAuth: false);
    } on PlatformException catch(e){
      print(e);
    }

    print(authenticated.toString());
    

    setState(() {
      authorized = authenticated ? 'Autorizado' : 'Não Autorizado';
    });
  }

  @override
  Widget build(BuildContext context) {

    if(loading){
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Biometric"),
        actions: <Widget>[Icon(Icons.refresh)],
      ),
      body: Column(
        children: <Widget>[
          Text("Checa se o dispositivo é capaz de verificar dados biometricos"),
          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => checkBiometrics(),
                child: Text("Checar"),
              ),
              Text(canCheckBiometrics.toString())
              // Text(canCheckBiometrics.toString()),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Text("Biometria disponível?"),
          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => availableBiometrics(),
                child: Text("Checar"),
              ),
              Text(listaBiometrics.toString())
              // Text(canCheckBiometrics.toString()),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Text("Authenticate"),
          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () => authenticate(),
                child: Text("Checar"),
              ),
              // Text(listaBiometrics.toString())
              // Text(canCheckBiometrics.toString()),
            ],
          ),
          Text(authorized),
        ],
      ),
    );
  }
}
