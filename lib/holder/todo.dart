class TodoItem {
  String title, id;
  int deadline;

  TodoItem(this.id, this.title, this.deadline);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is TodoItem) && (other.id == id);
  }
}

class TodoTab {
  String title, id;
  List<TodoItem> items = [];

  TodoTab(this.id, this.title, this.items);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is TodoItem) && (other.id == id);
  }
}
