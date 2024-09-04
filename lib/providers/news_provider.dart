import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/data/news_model.dart';
import 'package:groupchat/repositories/news_repository.dart';

final newsProvider = ChangeNotifierProvider((ref) => NewsProvider());

class NewsProvider extends ChangeNotifier{
  List<NewsModel>? newsList;
  List<NewsModel>? allNewsList;

  void listenToNews(String myCountry) {
    if(newsList!=null){
      return;
    }
    NewsRepository().getNewsStream(myCountry: myCountry).listen((newsData) {
      newsList ??= [];
      newsList = newsData.entries.map((entry) {
        return NewsModel(
            id: entry.key,
            description: entry.value.description,
            uid: entry.value.uid,
            imageUrl: entry.value.imageUrl,
            title: entry.value.title,
            country: entry.value.country,
            timeStamp: entry.value.timeStamp,
        );
      }).toList();
      newsList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      notifyListeners();
    });
  }

  void listenToAllNews() {
    if(allNewsList!=null){
      return;
    }
    NewsRepository().getAllNewsStream().listen((newsData) {
      allNewsList ??= [];
      allNewsList = newsData.entries.map((entry) {
        return NewsModel(
          id: entry.key,
          description: entry.value.description,
          uid: entry.value.uid,
          imageUrl: entry.value.imageUrl,
          title: entry.value.title,
          country: entry.value.country,
          timeStamp: entry.value.timeStamp,
        );
      }).toList();
      allNewsList?.sort((a, b) => b.timeStamp!.compareTo(a.timeStamp!));
      notifyListeners();
    });
  }

}