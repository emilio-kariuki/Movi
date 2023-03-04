import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: Colors.black,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: Text('App version 1.0.0', style: TextStyle(color: Colors.white),),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('App version 1.0.0', style: TextStyle(color: Colors.white),),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('App version 1.0.0', style: TextStyle(color: Colors.white),),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('App version 1.0.0', style: TextStyle(color: Colors.white),),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('App version 1.0.0', style: TextStyle(color: Colors.white),),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('App version 1.0.0', style: TextStyle(color: Colors.white),),
                    onTap: () {},
                  ),
                ],
              ),
            );
  }
}