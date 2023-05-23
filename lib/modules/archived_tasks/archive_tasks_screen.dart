import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/componentes/components.dart';
import '../../shared/shared.cubit/cubit.dart';
import '../../shared/shared.cubit/states.dart';

class ArchiveTaskScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state){
        var tasks = AppCubit.get(context).archiveTasks;

        return taskBuilder(tasks);
      },
    );
  }
}

