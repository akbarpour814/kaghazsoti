class AboutUsModel {
  final String aboutUs;
  final String website;
  final String email;
  final String whatsapp;
  late String share;

  AboutUsModel.fromJson(Map<String, dynamic> json)
      : aboutUs = json['content'],
        website = json['general_website_url'],
        email = json['admin_email_address'],
        whatsapp = json['admin_mobile_number'] {
    share =
        'بهترین و جدیدترین کتاب های صوتی را با ما بشنوید.\n\nراه های ارتباط با ما:\n\nواتساپ: $whatsapp\nایمیل: $email\nوب سایت: $website\n\nدانلود از طریق: \n\nنسخه اندروید: ${'androidLink'}\n\nنسخه آی.او.اس: ${'iosLink'}';
  }
}
