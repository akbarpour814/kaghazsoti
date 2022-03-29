import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:persian_number_utility/persian_number_utility.dart';

import 'date_time_format.dart';
class Comment {
  late Topic topic;
  late String text;
  late CommentStatus status;
  late List<String> answers;
  late String sentDate;
  late String lastAnswerDate;

  Comment.fromJson(Map<String, dynamic> json) {
    int findTopic = TopicExtension.topics.values.toList().indexWhere((element) => element == json['title']);

    topic = TopicExtension.topics.keys.elementAt(findTopic > -1 ? findTopic : TopicExtension.topics.length - 1);
    text = json['body'];
    status = json['status'] == 'done' ? CommentStatus.answered : CommentStatus.waiting;

    answers = [];
    for(Map<String, dynamic> answer in json['answers']) {
      answers.add(answer['body']);
    }

    sentDate = DateTimeFormat.dateTimeFormat(date: json['created_at']);

    lastAnswerDate = DateTimeFormat.dateTimeFormat(date: json['updated_at']);
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
