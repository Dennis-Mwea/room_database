import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:provider/provider.dart';
import 'package:room_db/database/moor_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController taskController;
  late TextEditingController colorController;
  late DateTime? newTaskDate;
  bool showCompleted = false;
  static const Color DEFAULT_COLOR = Colors.red;
  Color pickedTagColor = DEFAULT_COLOR;
  Tag? selectedTag;

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController();
    colorController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final dao = Provider.of<TaskDao>(context);
    final tagDao = Provider.of<TagDao>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tasks'), actions: [
        Row(children: [Text('Completed'), Switch(value: showCompleted, onChanged: (newValue) => setState(() => showCompleted = newValue))])
      ]),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: dao.watchAllTasks(),
              builder: (context, AsyncSnapshot<List<TaskWithTag>> snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                final tasks = snapshot.data ?? <TaskWithTag>[];

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, index) {
                    final item = tasks[index];

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(caption: 'Delete', color: Colors.red, icon: Icons.delete, onTap: () => dao.deleteTask(item.task))
                      ],
                      child: CheckboxListTile(
                        title: Text(item.task.name),
                        subtitle: Text(item.task.dueDate?.toString() ?? 'No date'),
                        secondary: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (item.tag != null) ...[
                              Container(
                                  width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(item.tag!.color))),
                              Text(item.tag!.name, style: TextStyle(color: Colors.black.withOpacity(0.5))),
                            ],
                          ],
                        ),
                        value: item.task.completed,
                        onChanged: (newValue) => dao.updateTask(item.task.copyWith(completed: newValue)),
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
                    controller: taskController,
                    decoration: InputDecoration(hintText: 'Task Name'),
                    onSubmitted: (inputName) {
                      final task = TasksCompanion(name: Value(inputName), dueDate: Value(newTaskDate), tagName: Value(selectedTag?.name));
                      dao.insertTask(task);

                      _resetValuesAfterSubmit();
                    },
                  ),
                ),
                _buildTagSelector(context),
                IconButton(
                    onPressed: () async {
                      newTaskDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2050));
                    },
                    icon: Icon(Icons.calendar_today)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: colorController,
                    decoration: InputDecoration(hintText: 'Tag Name'),
                    onSubmitted: (inputName) {
                      final task = TagsCompanion(name: Value(inputName), color: Value(pickedTagColor.value));
                      tagDao.insertTag(task);

                      _resetValuesAfterSubmit();
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(width: 25, height: 25, decoration: BoxDecoration(shape: BoxShape.circle, color: pickedTagColor)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: MaterialColorPicker(
                              allowShades: false,
                              selectedColor: DEFAULT_COLOR,
                              onMainColorChange: (colorSwatch) {
                                setState(() => pickedTagColor = Color(colorSwatch!.value));
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<List<Tag>> _buildTagSelector(BuildContext context) {
    return StreamBuilder<List<Tag>>(
      stream: Provider.of<TagDao>(context).watchTags(),
      builder: (context, snapshot) {
        final tags = snapshot.data ?? [];

        DropdownMenuItem<Tag> dropdownFromTag(Tag tag) {
          return DropdownMenuItem<Tag>(
            value: tag,
            child: Row(
              children: <Widget>[
                Text(tag.name),
                SizedBox(width: 5),
                Container(width: 15, height: 15, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(tag.color)))
              ],
            ),
          );
        }

        final dropdownMenuItems = tags.map((tag) => dropdownFromTag(tag)).toList()
          ..insert(0, DropdownMenuItem<Tag>(value: null, child: Text('No Tag')));

        return Expanded(
            child: DropdownButton<Tag>(
                onChanged: (Tag? tag) => setState(() => selectedTag = tag),
                isExpanded: true,
                value: selectedTag,
                items: dropdownMenuItems));
      },
    );
  }

  void _resetValuesAfterSubmit() {
    setState(() {
      newTaskDate = null;
      colorController.clear();
      taskController.clear();
      selectedTag = null;
    });
  }
}
