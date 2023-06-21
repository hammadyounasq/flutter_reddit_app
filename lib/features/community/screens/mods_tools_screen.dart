import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModTools extends StatelessWidget {
  final String name;
  const ModTools({Key? key, required this.name}) : super(key: key);

  void navigiateToModTools(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigiateToAddMods(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mod Tools"),
        ),
        body: Column(
          children: [
            ListTile(
              leading: Icon(Icons.add_moderator),
              title: Text('Add Moderators'),
              onTap: () => navigiateToAddMods(context),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Community'),
              onTap: () {
                navigiateToModTools(context);
              },
            ),
          ],
        ));
  }
}
