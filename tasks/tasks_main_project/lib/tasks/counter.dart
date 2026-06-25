import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_main_project/tasks/bloc_classes/counterLogic.dart';
import 'package:tasks_main_project/tasks/bloc_classes/counterState.dart';

class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>Counterlogic(),

      child: BlocConsumer<Counterlogic,Counterstate>(
        listener: (context,state){},
        builder:(context,state)
            {
              Counterlogic obj =BlocProvider.of(context);
              return Scaffold(
                appBar: AppBar(),
                body: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Counter", style: TextStyle(color: Colors.black, fontSize: 20)),
                            Text("${obj.varCounter}",style: TextStyle(color: Colors.black,fontSize: 20)),
                            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    child: Text(
                      "+",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.black87,
                    onPressed: () {
                   obj.setP();
                    },
                  ),
                  MaterialButton(
                    child: Text(
                      "-",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.black,
                    onPressed: () {
                     obj.setM();
                    },
                  ),
                ],
                            ),
                            MaterialButton(
                child: Text(
                  "reset",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                color: Colors.black,
                onPressed: () {
                 obj.setR();
                },
                            ),
                          ],
                        ),
              );},
      ),
    );
  }
}
