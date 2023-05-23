

import 'package:todo_app/shared/shared.cubit/cubit.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isClickable = true,
  // Function? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData prefix,
  Function? suffixPressed,
  IconData? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit as void Function(String)?,
      enabled: isClickable,
      onChanged: onChange as void Function(String)?,
      validator: validate as String? Function(String?)?,
      onTap: onTap as void Function()?,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed as void Function()?,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: model['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );


Widget taskBuilder (List<Map> tasks )
=> ConditionalBuilder( builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length),
condition: tasks.length>0,
  fallback:(context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text('No Tasks Yet, Please Add Some Tasks',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey
        ),)
      ],
    ),
  ) ,
);


// Widget taskBuilder({
//   required List<Map> tasks,
// }) =>
//     ConditionalBuilder(
//       condition: tasks.length > 0,
//       builder: (context) => ListView.separated(
//         itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
//         separatorBuilder: (context, index) => myDivider(),
//         itemCount: tasks.length,
//       ),
//       fallback: (context) => Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.menu,
//               size: 100.0,
//               color: Colors.grey,
//             ),
//             Text(
//               'No Tasks Yet, Please Add some Tasks',
//               style: TextStyle(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey),
//             )
//           ],
//         ),
//       ),
//     );
//
// Widget myDivider() => Padding(
//   padding: const EdgeInsetsDirectional.only(
//     start: 20.0,
//   ),
//   child: Container(
//     width: double.infinity,
//     height: 1.0,
//     color: Colors.grey[300],
//   ),
// );

Widget bulidArticleItem(article) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(
                '${article['https://th.bing.com/th/id/R.7d5a5ddd051f3e250cdfd4c5e9e188d7?rik=f1oXVyE9fdsydQ&riu=http%3a%2f%2fengineering.letsnurture.com%2fwp-content%2fuploads%2f2018%2f07%2fflutter.png&ehk=slD%2f%2bodJ1M8aDXUvCda3w6EySDQnrwTsxJ8Ucua0hCk%3d&risl=&pid=ImgRaw&r=0']}'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Container(
          height: 120.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('2022-11')
            ],
          ),
        ),
      ),
    ],
  ),
);