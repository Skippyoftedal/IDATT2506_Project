import 'package:idatt2506_project/navigation/route_widget.dart';
import 'package:idatt2506_project/navigation/routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<StatefulWidget> createState() {
    return AppDrawerState();
  }
}

class AppDrawerState extends State<AppDrawer> {

  @override
  initState()  {

    getData();

    super.initState();
  }

  getData() async {
    var list = await getList(context, "assets/lists/hyttetur.json");
    print("found $list");
    var allLists = await getAllLists(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(left: 10, top: 50),
        children: [
          for (var route in getAllRoutes()) RouteWidget(route: route),
          const Text("hello")
        ],
      ),
    );
  }
}



