class Task {
  String task;
  String description;
  bool done;
  String key;

  Task({this.task, this.description, this.done});

  Task.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    description = json['description'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['task'] = task;
    data['description'] = description;
    data['done'] = done;
    return data;
  }
}
