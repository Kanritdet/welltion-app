import 'package:flutter/foundation.dart';
import '../models/track_model.dart';
import '../models/playlist_model.dart';
import '../models/mock_data.dart';

enum TrackRepeatMode { none, all, one }

class PlayerProvider extends ChangeNotifier {
  TrackModel? _currentTrack;
  PlaylistModel? _currentPlaylist;
  List<TrackModel> _queue = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isShuffle = false;
  TrackRepeatMode _repeatMode = TrackRepeatMode.none;

  TrackModel? get currentTrack => _currentTrack;
  PlaylistModel? get currentPlaylist => _currentPlaylist;
  List<TrackModel> get queue => List.unmodifiable(_queue);
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  TrackRepeatMode get repeatMode => _repeatMode;
  bool get hasNext => _queue.isNotEmpty && _currentIndex < _queue.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  void loadPlaylist(PlaylistModel playlist, {int startIndex = 0}) {
    _currentPlaylist = playlist;
    _queue = MockData.tracksByPlaylist(playlist);
    _currentIndex = _queue.isEmpty ? 0 : startIndex.clamp(0, _queue.length - 1);
    _currentTrack = _queue.isEmpty ? null : _queue[_currentIndex];
    _isPlaying = false;
    notifyListeners();
  }

  void playTrack(TrackModel track) {
    _currentTrack = track;
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }

  void resume() {
    if (_currentTrack == null) return;
    _isPlaying = true;
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _currentTrack = null;
    notifyListeners();
  }

  void next() {
    if (!hasNext) return;
    _currentIndex++;
    _currentTrack = _queue[_currentIndex];
    _isPlaying = true;
    notifyListeners();
  }

  void previous() {
    if (!hasPrevious) return;
    _currentIndex--;
    _currentTrack = _queue[_currentIndex];
    _isPlaying = true;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _repeatMode = TrackRepeatMode.values[(_repeatMode.index + 1) % TrackRepeatMode.values.length];
    notifyListeners();
  }

  void jumpTo(int index) {
    if (index < 0 || index >= _queue.length) return;
    _currentIndex = index;
    _currentTrack = _queue[_currentIndex];
    _isPlaying = true;
    notifyListeners();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, item);
    if (oldIndex == _currentIndex) {
      _currentIndex = newIndex;
    } else if (oldIndex < _currentIndex && newIndex >= _currentIndex) {
      _currentIndex--;
    } else if (oldIndex > _currentIndex && newIndex <= _currentIndex) {
      _currentIndex++;
    }
    _currentTrack = _queue.isEmpty ? null : _queue[_currentIndex];
    notifyListeners();
  }
}
