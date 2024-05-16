import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/notification_provider.dart';
import 'package:radvolontera_mobile/providers/report_provider.dart';
import 'package:radvolontera_mobile/providers/section_provider.dart';
import 'package:radvolontera_mobile/providers/status_provider.dart';
import 'package:radvolontera_mobile/providers/useful_link_provider.dart';
import 'package:radvolontera_mobile/providers/volunteering_announcement_provider.dart';
import 'package:radvolontera_mobile/screens/home/home_screen.dart';
import 'package:radvolontera_mobile/utils/util.dart';

void main() {
  runApp(MyMaterialApp());
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => SectionProvider()),
        ChangeNotifierProvider(create: (_) => UsefulLinkProvider()),
        ChangeNotifierProvider(create: (_) => VolunteeringAnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => StatusProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: MaterialApp(
        title: 'RS II Material app',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: LoginPage(),
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AccountProvider _accountProvider;

  @override
  Widget build(BuildContext context) {
    _accountProvider = context.read<AccountProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/logo.jpg",
                        height: 100,
                        width: 100,
                      ),
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
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
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
                          if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
                              .hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var username = _usernameController.text;
                              var password = _passwordController.text;
                              try {
                                var body = {
                                  'username': username,
                                  'password': password,
                                };
                                var result =
                                    await _accountProvider.login(body);
                                Authorization.token =
                                    result['accessToken'].toString();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePageScreen()));
                              } on Exception catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text("Error"),
                                          content: Text(e.toString()),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("OK"))
                                          ],
                                        ));
                              }
                            }
                          },
                          child: Text("Login"),
                        ),
                      )
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
