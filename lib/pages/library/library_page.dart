//------/dart and flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

//------/packages
export 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//------/controller
import '../../widgets/fade_in_image_widget.dart';
import '/controller/custom_response.dart';
import '/controller/custom_dio.dart';
import '/controller/internet_connection.dart';
import '/controller/load_data_from_api.dart';

//------/model
import '../../widgets/book_introduction/book_introduction_model.dart';

//------/view/audio_player_models
import '../audiobook/audiobook_player_page.dart';

//------/view/view_models
import '../../widgets/custom_circular_progress_indicator.dart';
import '../../widgets/custom_smart_refresher.dart';
import '/widgets/no_internet_connection.dart';
import 'book_sections_page.dart';

//------/main
import '/main.dart';
import 'library_controller.dart';

bool dataIsLoadingGlobal = true;

class LibraryPage extends GetView<LibraryController> {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      bottomNavigationBar: playerBottomNavigationBar,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('کتابخانه من'),
      leading: const Icon(
        Ionicons.library_outline,
      ),
    );
  }

  Widget _body(BuildContext context,) {
    return RefreshIndicator(
      onRefresh: () => controller.fetch(),
      child: controller.obx(
            (state) => _innerBody(context),
        onError: (e) => const Text('onError'),
        onLoading: const Center(
          child: CustomCircularProgressIndicator(),
        ),
        onEmpty: const Text('onEmpty'),
      ),
    );
  }

  Widget _innerBody(BuildContext context) {
    return const Center(
      child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
    );
    if (controller.state!.isEmpty) {
      return const Center(
        child: Text('کتابی در کتابخانه شما موجود نمی باشد.'),
      );
    } else {
      // return CustomSmartRefresher(
      //   refreshController: refreshController,
      //   onRefresh: () => onRefresh(() => _initMyBooks()),
      //   onLoading: () => onLoading(() => _initMyBooks()),
      //   list: List<InkWell>.generate(
      //     _myBooks.length,
      //         (index) => _myBook(_myBooks[index]),
      //   ),
      //   listType: 'کتاب',
      //   refresh: refresh,
      //   loading: loading,
      //   lastPage: lastPage,
      //   currentPage: currentPage,
      //   dataIsLoading: dataIsLoadingGlobal,
      // );
    }
  }

  InkWell _myBook(BuildContext context,BookIntroductionModel book) {
    return InkWell(
      onTap: () {
        if (book.type == 1) {
          if (book.id != previousAudiobookInPlayId) {
            audioPlayerHandler.onTaskRemoved();
            audioPlayerHandler.seek(Duration(microseconds: 0));

            demoOfBookIsPlaying.$ = false;
            demoInPlayId = -1;
            demoPlayer.stop();

            audioPlayerHandler.stop();
            mediaItems.clear();

            audioPlayerHandler.stop();

            audiobookInPlay = book;
            audiobookInPlayId = book.id;
          }

          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return AudiobookPlayerPage(audiobook: book);
              },
            ),
          );
        } else {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return BookSectionsPage(book: book);
              },
            ),
          );
        }
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        shape: Theme.of(context).cardTheme.shape,
        child: Row(
          children: [
            _bookCover(context, book),
            _bookShortInformation(context, book),
          ],
        ),
      ),
    );
  }

  Padding _bookCover(BuildContext context,BookIntroductionModel book) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          shape: BoxShape.rectangle,
        ),
        width: 25.0.w,
        height: 13.0.h,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: FadeInImageWidget(
            image: book.bookCoverPath,
          ),
        ),
      ),
    );
  }

  Expanded _bookShortInformation(BuildContext context,BookIntroductionModel book) {
    return Expanded(
      child: ListTile(
        title: Text(
          book.name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          book.author,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Visibility(
          visible: book.price == 'رایگان',
          child: _removeFreeBookButton(context, book),
        ),
      ),
    );
  }

  InkWell _removeFreeBookButton(BuildContext context,BookIntroductionModel book) {
    return InkWell(
      onTap: () {
        controller.removeFreeBook(context, book);
      },
      child: Icon(Ionicons.trash_outline),
    );
  }

}
