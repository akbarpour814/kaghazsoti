class EditProfileModel {
  final String firstAndLastName;
  final String numberPhone;

  EditProfileModel.fromJson(Map<String, dynamic> json)
      : firstAndLastName = json['name'],
        numberPhone = json['username'];
}
