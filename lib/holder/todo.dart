class TodoItem {
  String title;
  int deadline, created;

  TodoItem(this.title, this.deadline, this.created);
}

class TodoTab {
  String title;
  List<TodoItem> items = [], filteredItems = [];

  TodoTab(this.title, this.items, this.filteredItems);

  void copyFullToFiltered() => filteredItems = [...items];

  void sort(int sortingType) {
    _sort0(items, sortingType);
    _sort0(filteredItems, sortingType);
  }

  void _sort0(List<TodoItem> items, int sortingType) {
    switch (sortingType) {
      case TodoItemSortingType.added:
        items.sort((a, b) => b.created.compareTo(a.created));
        break;
      case TodoItemSortingType.deadline:
        items.sort((a, b) => b.deadline.compareTo(a.deadline));
        break;
      case TodoItemSortingType.name:
        items.sort((a, b) => a.title.compareTo(a.title));
        break;
      default:
        break;
    }
  }
}

class TodoItemSortingType {
  static const int deadline = 0, name = 1, added = 2;
}
