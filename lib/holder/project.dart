class Project {
  String name, id;
  int lastAccessed;

  Project(this.id, this.name, this.lastAccessed);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    return (other is Project) && (other.id == id);
  }
}
