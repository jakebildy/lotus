import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/streak_count_page.dart';

class TurtlesPage extends StatefulWidget {
  const TurtlesPage({Key? key}) : super(key: key);

  @override
  State<TurtlesPage> createState() => _TurtlesPageState();
}

class _TurtlesPageState extends State<TurtlesPage> {
  @override
  Widget build(BuildContext context) {
      
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: TabBar(
            tabs: [
              Tab(child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text("Turtles", style: TextStyle(fontSize: 18),),
                  Text("0/100", style: TextStyle(fontSize: 12)),
                ],
              ),),
              Tab(child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text("Eggs", style: TextStyle(fontSize: 18)),
                  Text("0", style: TextStyle(fontSize: 12)),
                ],
              ),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
          GridView.count(  
                crossAxisCount: 3,  
                crossAxisSpacing: 4.0,  
                mainAxisSpacing: 8.0,  
                children: List.generate(100, (index) {  
                  return Center(  
                    child: TurtleCard(unlocked: index < 5),  
                  );  
                }  
                )),
              ListView(),
          ],
        ),
      ),
    );

  }
}