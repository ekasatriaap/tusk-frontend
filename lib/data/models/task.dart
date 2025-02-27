import 'user.dart';

class Task {
  final int? id;
  final int? userId;
  final String? title;
  final String? description;
  final String? status;
  final String? reason;
  final int? revision;
  final DateTime? dueDate;
  final DateTime? submitDate;
  final DateTime? rejectDate;
  final DateTime? approveDate;
  final String? attachment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Task({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.status,
    this.reason,
    this.revision,
    this.dueDate,
    this.submitDate,
    this.rejectDate,
    this.approveDate,
    this.attachment,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        reason: json["reason"],
        revision: json["revision"],
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        submitDate: json["submitDate"] == null || json["submitDate"] == ""
            ? null
            : DateTime.parse(json["submitDate"]),
        rejectDate: json["rejectDate"] == null || json["rejectDate"] == ""
            ? null
            : DateTime.parse(json["rejectDate"]),
        approveDate: json["approveDate"] == null || json["approveDate"] == ""
            ? null
            : DateTime.parse(json["approveDate"]),
        attachment: json["attachment"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "status": status,
        "reason": reason,
        "revision": revision,
        "dueDate": dueDate?.toIso8601String(),
        "submitDate": submitDate?.toIso8601String(),
        "rejectDate": rejectDate?.toIso8601String(),
        "approveDate": approveDate?.toIso8601String(),
        "attachment": attachment,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}
