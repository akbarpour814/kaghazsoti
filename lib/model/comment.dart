import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:persian_number_utility/persian_number_utility.dart';
class Comment {
  late Topic topic;
  late String text;
  late CommentStatus status;
  late List<String> answers;
  late String sentDate;
  late DateTime sentDateTime;
  late String lastAnswerDate;
  late DateTime lastAnswerDateTime;

  Comment.fromJson(Map<String, dynamic> json) {
    int findTopic = TopicExtension.topics.values.toList().indexWhere((element) => element == json['title']);

    topic = TopicExtension.topics.keys.elementAt(findTopic > -1 ? findTopic : TopicExtension.topics.length - 1);
    text = json['body'];
    status = json['status'] == 'done' ? CommentStatus.answered : CommentStatus.waiting;

    answers = [];
    for(Map<String, dynamic> answer in json['answers']) {
      answers.add(answer['body']);
    }

    sentDateTime = DateTime.parse(json['created_at']);
    sentDate = '${DateFormat('HH:mm').format(sentDateTime.toLocal())} - ${sentDateTime.toPersianDate(twoDigits: true)}';

    lastAnswerDateTime = DateTime.parse(json['updated_at']);
    lastAnswerDate = '${DateFormat('HH:mm').format(sentDateTime.toLocal())} - ${sentDateTime.toPersianDate(twoDigits: true)}';
  }
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
