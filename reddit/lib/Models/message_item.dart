class Messages {
  String id;
  String? senderUsername;
  String? senderType;
  String? receiverUsername;
  String? receiverType;
  String? senderVia;
  String? message;
  String? createdAt;
  String? deletedAt;
  bool unreadFlag;
  bool isSent;
  bool? isReply;
  String? parentMessageId;
  String? subject;
  bool? isInvitation;

  Messages({
    required this.id,
    this.senderUsername,
    this.senderType,
    this.receiverUsername,
    this.receiverType,
    this.message,
    this.createdAt,
    required this.unreadFlag,
    required this.isSent,
    this.isReply,
    this.subject,
    this.senderVia,
    this.deletedAt,
    this.parentMessageId,
    this.isInvitation,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['_id'],
      senderUsername: json['sender_username'],
      senderType: json['sender_type'],
      receiverUsername: json['receiver_username'],
      receiverType: json['receiver_type'],
      senderVia: json['sender_via'],
      message: json['message'],
      createdAt: json['created_at'],
      deletedAt: json['deleted_at'],
      unreadFlag: json['unread_flag'],
      isSent: json['is_sent'],
      isReply: json['is_reply'],
      parentMessageId: json['parent_message_id'],
      subject: json['subject'],
      isInvitation: json['is_invitation'],
    );
  }
}
