class Project {
  String name, id;
  int lastAccessed, itemCount;

  Project(this.id, this.name, this.lastAccessed, this.itemCount);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is Project) && (other.id == id);
  }
}
