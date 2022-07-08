class Group {
  late int id;
  late String name;
  late int order;
  late bool show;

  Group(this.id, this.name, {this.order = 99, this.show = true});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
    show = json['show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['show'] = show;
    return data;
  }

  Group copy() {
    return Group(id, name, order: order, show: show);
  }
}
