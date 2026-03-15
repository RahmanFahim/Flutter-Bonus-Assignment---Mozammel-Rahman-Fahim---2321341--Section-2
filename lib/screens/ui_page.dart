import 'package:flutter/material.dart';
import 'package:flutter_ui_class/data/dummy_data.dart';
import 'package:flutter_ui_class/models/card_data_model.dart';
import 'package:flutter_ui_class/widgets/task_card_widget.dart';

class UiPage extends StatefulWidget {
  const UiPage({super.key});

  @override
  State<UiPage> createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {


  DummyData dummyData = DummyData();


  @override
  Widget build(BuildContext context) {
    print("Building UI Page...");
    

    return Scaffold(
      appBar: AppBar(
        title: Text("UI PAGE"),
        backgroundColor: Colors.purpleAccent,
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: dummyData.tasks.length,
        itemBuilder: (context, index) {
          final task = dummyData.tasks[index];

          return TaskCardWidget(
            title: task.title,
            subtitle: task.subtitle,
            icon: task.icon,
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dummyData.addTaskExternal(
            CardDataModel(
              title: "New Task",
              subtitle: "This is a new task",
              icon: Icons.add
            )
          );
          setState(
            (){
              
            }
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
