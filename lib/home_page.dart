import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:room_db/database/moor_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController controller;
  late DateTime? newTaskDate;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: database.watchAllTasks(),
              builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                final tasks = snapshot.data ?? <Task>[];

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, index) {
                    final task = tasks[index];

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(caption: 'Delete', color: Colors.red, icon: Icons.delete, onTap: () => database.deleteTask(task))
                      ],
                      child: CheckboxListTile(
                        title: Text(task.name),
                        subtitle: Text(task.dueDate?.toString() ?? 'No date'),
                        value: task.completed,
                        onChanged: (newValue) => database.updateTask(task.copyWith(completed: newValue)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Task Name'),
                    onSubmitted: (inputName) {
                      final task = Task(name: inputName, dueDate: newTaskDate, completed: false, id: 1);
                      database.insertTask(task);

                      _resetValuesAfterSubmit();
                    },
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      newTaskDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2050));
                    },
                    icon: Icon(Icons.calendar_today)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      controller.clear();
    });
  }
}
