import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Import your Firebase options
import 'firebase_options.dart';

// Import your existing project files
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/screens/UI_page.dart';

// Import the new Model and Repository you created
import 'models/task_model.dart';
import 'repositories/task_repository.dart';

void main() async {
  // Required for Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const FlutterUIApp());
}

class FlutterUIApp extends StatelessWidget {
  const FlutterUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskManagementProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Bonus',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'FLUTTER UI & FIREBASE'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // YOUR ORIGINAL COUNTER UI
            Container(
              height: 150,
              width: 350,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withAlpha(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  const Text('Counter value:', style: TextStyle(fontSize: 18)),
                  Text('$_counter', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.purple)),
                  ElevatedButton(onPressed: _incrementCounter, child: const Text("Increment")),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BONUS ASSIGNMENT NAVIGATION BUTTON
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FirebaseTaskScreen()),
                );
              },
              icon: const Icon(Icons.storage),
              label: const Text("GO TO FIREBASE TASKS"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEW SCREEN FOR THE BONUS ASSIGNMENT ---
class FirebaseTaskScreen extends StatefulWidget {
  const FirebaseTaskScreen({super.key});

  @override
  State<FirebaseTaskScreen> createState() => _FirebaseTaskScreenState();
}

class _FirebaseTaskScreenState extends State<FirebaseTaskScreen> {
  final TaskRepository _repo = TaskRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task to Firestore'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'Task Title')),
            TextField(controller: _descController, decoration: const InputDecoration(hintText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                _repo.addTask(TaskModel(
                  title: _titleController.text,
                  description: _descController.text,
                ));
                _titleController.clear();
                _descController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Real-time Tasks'), backgroundColor: Colors.orangeAccent),
      body: StreamBuilder<List<TaskModel>>(
        stream: _repo.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No tasks in Firestore"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _repo.deleteTask(task.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}