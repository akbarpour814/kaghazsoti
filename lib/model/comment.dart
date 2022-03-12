import 'package:flutter/material.dart';

class Comment {
  late Topic topic;
  late String text;
  late CommentStatus status;
  late DateTime data;
  late String response;

  Comment({
    required this.topic,
    required this.text,
    required this.status,
    required this.data,
    required this.response,
  });
}


enum Topic {
  suggestion,
  complaint,
  defect,
  question,
  other,
}

extension TopicExtension on Topic {
  static const Map<Topic, String> topics = {
    Topic.suggestion: 'پیشنهاد',
    Topic.complaint: 'شکایت',
    Topic.defect: 'گزارش نقص فنی',
    Topic.question: 'پرسش',
    Topic.other: 'سایر موارد',
  };

  String? get title => topics[this];
}


enum CommentStatus {
  answered,
  waiting,
  cancelled,
}

extension CommentStatusExtension on CommentStatus {
  static const Map<CommentStatus, String> statusOfComments = {
    CommentStatus.answered: 'پاسخ داده شده',
    CommentStatus.waiting: 'در انتظار پاسخ',
    CommentStatus.cancelled: 'لغو ارسال',
  };

  static const Map<CommentStatus, Color> statusColorOfComments = {
    CommentStatus.answered: Colors.lightGreen,
    CommentStatus.waiting: Colors.grey,
    CommentStatus.cancelled: Colors.redAccent,
  };

  String? get title => statusOfComments[this];

  Color? get color => statusColorOfComments[this];
}