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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = this.task;
    data['description'] = this.description;
    data['done'] = this.done;
    return data;
  }
}
