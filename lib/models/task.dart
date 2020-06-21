class Task {
  int key;
  String name;
  bool isDone;

  Task({this.key, this.name, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
