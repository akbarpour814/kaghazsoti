class FAQModel {
  final String question;
  final String answer;

  FAQModel.fromJson(Map<String, dynamic> json)
      : question = json['q'],
        answer = json['a'];
}
