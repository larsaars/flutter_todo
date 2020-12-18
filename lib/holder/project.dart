class Project {
  String name, id;

  Project(this.name);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is Project) && (other.id == id);
  }
}