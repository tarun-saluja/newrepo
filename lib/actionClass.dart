import 'package:memob/assigneeClass.dart';
import 'package:memob/meetingClass.dart';

class ActionClass {
  String uuid;
  String eventUuid;
  //MeetingClass meeting;
  String note;
 // AssigneeClass assignee;
  String assignedTo;
  String status;
  bool isDeleted;
  String createdAt;
  String dueDate;
 // List<String> tags;
  bool isExternallyModified;
 // List<String> comments;

  ActionClass(
      this.uuid,
      this.eventUuid,
      //this.meeting,
      this.note,
     // this.assignee,
      this.assignedTo,
      this.status,
      this.isDeleted,
      this.createdAt,
      this.dueDate,
     // this.tags,
      this.isExternallyModified,
     // this.comments
     );

  @override
  String toString() {
    return 'Action{uuid: $uuid, event_uuid: $eventUuid, note: $note, assiged_to: $assignedTo, status: $status, is_deleted: $isDeleted, created_at: $createdAt, due_date: $dueDate, is_externally_modified: $isExternallyModified}';
  }
}