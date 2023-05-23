import 'package:bloc/bloc.dart';
import 'package:todo_app/shared/shared.cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archive_tasks_screen.dart';
import '../../modules/done-tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeIndex( int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase()  {
    openDatabase('todo.db', version: 1,
        onCreate: (Database database,int version) {
         // print('database created');
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('Error When Creating Table ${error.toString()}');
          });
        },
      onOpen: (Database database) {

          getDataFromDatabase(database);
          print('database opened');
        },
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date
   }) async
  {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,date, time , status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((err) {
        print('Error When Insering New Record ${err.toString()}');
      });
    });
  }

  void getDataFromDatabase(Database database)
  {
    newTasks =[];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLodingState());

    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['ststus'] == 'new')
          newTasks.add(element);
        else if (element['ststus'] == 'done')
          doneTasks.add(element);
        else archiveTasks.add(element);

      });

      emit(AppGetDatabaseState());
    });

  }

  void updateData({
    required String status,
    required int id,
}) async
  {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status' , id]
    ).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });

  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]

    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });

  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }
}