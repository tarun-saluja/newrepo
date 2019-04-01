class ActionClass {
  String uuid;
  String eventUuid;

  //MeetingClass meeting;
  String note;
  String profilePicture;
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
    this.profilePicture,
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
    return 'Action{uuid: $uuid, event_uuid: $eventUuid, note: $note, profile_picture: $profilePicture, assiged_to: $assignedTo, status: $status, is_deleted: $isDeleted, created_at: $createdAt, due_date: $dueDate, is_externally_modified: $isExternallyModified}';
  }
}
