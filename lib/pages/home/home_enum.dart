//------/model
import '../../widgets/book_introduction/book_introduction_model.dart';
import 'home_config.dart';

enum HomeEnum {
  audioBooks,
  voicemails,
  ebooks,
  podcasts,
  childrenAndTeenagersBooks;
}

extension HomeEnumExtension on HomeEnum {
  String get title {
    return {
      HomeEnum.audioBooks: HomeConfig.config.texts.audioBooks,
      HomeEnum.voicemails: HomeConfig.config.texts.voicemails,
      HomeEnum.ebooks: HomeConfig.config.texts.ebooks,
      HomeEnum.podcasts: HomeConfig.config.texts.podcasts,
      HomeEnum.childrenAndTeenagersBooks:
          HomeConfig.config.texts.childrenAndTeenagersBooks,
    }[this]!;
  }

  String get slug {
    return {
      HomeEnum.audioBooks: HomeConfig.config.apis.audioBooks,
      HomeEnum.voicemails: HomeConfig.config.apis.voicemails,
      HomeEnum.ebooks: HomeConfig.config.apis.ebooks,
      HomeEnum.podcasts: HomeConfig.config.apis.podcasts,
      HomeEnum.childrenAndTeenagersBooks:
      HomeConfig.config.apis.childrenAndTeenagersBooks,
    }[this]!;
  }
}