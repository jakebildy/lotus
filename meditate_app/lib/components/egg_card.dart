import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditate_app/components/shake_widget.dart';

class EggCard extends StatelessWidget {

  EggCard({Key? key}) : super(key: key);
  
  final shakeKey = GlobalKey<ShakeWidgetState>();
  
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        shakeKey.currentState?.shake();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          key: UniqueKey(),
          backgroundColor: Colors.greenAccent,
          content: Text("Meditate consecutive days to hatch this egg!")));
      },
      child: Card(
        child:Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
               ShakeWidget(
              // 4. pass the GlobalKey as an argument
              key: shakeKey,
              // 5. configure the animation parameters
              shakeCount: 3,
              shakeOffset: 10,
              shakeDuration: Duration(milliseconds: 500),
              // 6. Add the child widget that will be animated
              child: Image.asset("assets/egg.png", height: 60,)),
              SizedBox(height: 10,),
              Stack(
                children: [
                   Container(color: Colors.black26, width: MediaQuery.of(context).size.width/3-10, height: 4,),
              //    Container(color: Colors.greenAccent, width: ( (MediaQuery.of(context).size.width/9-10)), height: 4,),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}