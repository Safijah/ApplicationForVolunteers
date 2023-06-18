import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/providers/notification_provider.dart';
import 'package:radvolontera_admin/screens/notification/notification_list_screen.dart';
import 'package:radvolontera_admin/utils/util.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ],
    child: const MyMaterialApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: LayoutExamples(), //Counter(),
    );
  }
}

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          color: Colors.red,
          child: Center(
            child: Container(
              height: 100,
              color: Colors.blue,
              child: Text("Example text"),
              alignment: Alignment.bottomLeft,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Item 1"),
            Text("Item 2"),
            Text("Item 3"),
          ],
        ),
        Container(
          height: 150,
          color: Colors.red,
          child: Text("Contain"),
          alignment: Alignment.center,
        )
      ],
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material app',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
   LoginPage({Key? key}) : super(key: key);
 TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
    title: Text("Login"),
  ),
  body: Center(
    child: Container(
      constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              Image.asset("assets/images/logo.jpg", height: 100, width: 100,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: Icon(Icons.email),
                ),
                controller: _usernameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password),
                ),
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(value)) {
                    return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    Authorization.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiQWRtaW4iLCJ1bmlxdWVfbmFtZSI6InNhZmlqYS5odWJsamFyQGVkdS5maXQuYmEiLCJlbWFpbCI6InNhZmlqYS5odWJsamFyQGVkdS5maXQuYmEiLCJuYW1laWQiOiJhYzQ3NzA3Zi1hMjEyLTQ2ZGItODFlYS02ZDE0ZDIyYTU4MTIiLCJuYmYiOjE2ODcxMDc1NjEsImV4cCI6MTY5NDg4MzU2MSwiaWF0IjoxNjg3MTA3NTYxLCJpc3MiOiJSYWRWb2xvbnRlcmEifQ.9yhNaX8f_3vnDN47aWghI39gNpc0TMievqR_1b73LdY";
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationListScreen()));
                  }
                },
                child: Text("Login"),
              )
            ]),
          ),
        ),
      ),
    ),
  ),
  );
  }
}