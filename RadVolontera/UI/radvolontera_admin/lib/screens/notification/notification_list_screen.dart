import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/providers/notification_provider.dart';
import 'package:radvolontera_admin/screens/notification/notification_details_screen.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationProvider _notificationProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _notificationProvider = context.read<NotificationProvider>();
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Notification list"),
      child: Container(
     child:Column(children: 
     [Text("Test"),
      SizedBox(height: 8,),
         ElevatedButton(onPressed: () {
                    print("login proceed");
                    var data = _notificationProvider.get();
                    print("Data $data");
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NotificationDetailsWidget(),));
                }, child: Text("Back"))],),
    ),
    );
  }
}