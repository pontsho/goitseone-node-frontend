import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/widgets.dart';
import 'package:mzansibeats/database/database_client.dart';

class BookmarkModel extends ChangeNotifier {
  DatabaseClient db;
  List<Song> bookmarks = List<Song>();

  BookmarkModel() {
    initPlayer();
    fetchBookmarks();
  }

  void initPlayer() async {
    db = new DatabaseClient();
    await db.create();
  }

  add(Song song) async {
    await db.favSong(song);
    fetchBookmarks();
  }

  remove(Song song) async {
    await db.favSong(song);
    fetchBookmarks();
  }

  alreadyExists(s) async {
    if( (await db.isfav(s)) == 1)
      return true;
    else
      return false;
  }

  fetchBookmarks() async {
    bookmarks = await db.fetchFavSong();
    notifyListeners();
  }
}
