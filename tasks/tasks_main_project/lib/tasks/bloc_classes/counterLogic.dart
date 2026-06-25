


import 'package:bloc/bloc.dart';
import 'package:tasks_main_project/tasks/bloc_classes/counterState.dart';

class Counterlogic extends Cubit<Counterstate>{
  Counterlogic ():super(InitCounter());


  int varCounter =5 ;
  setP(){
    varCounter++;
    emit(PCounter());
  }
  setM(){
    varCounter--;
    emit(MCounter());
  }
  setR(){
    varCounter=0;
    emit(RCounter());
  }
}