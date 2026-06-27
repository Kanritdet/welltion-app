import 'package:flutter/foundation.dart';
import '../models/track_model.dart';
import '../models/playlist_model.dart';
import '../models/mock_data.dart';

class PlayerProvider extends ChangeNotifier {
  TrackModel? _currentTrack;
  PlaylistModel? _currentPlaylist;
  List<TrackModel> _queue = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;

  TrackModel? get currentTrack => _currentTrack;
  PlaylistModel? get currentPlaylist => _currentPlaylist;
  List<TrackModel> get queue => List.unmodifiable(_queue);
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
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
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  void jumpTo(int index) {
    if (index < 0 || index >= _queue.length) return;
    _currentIndex = index;
    _currentTrack = _queue[_currentIndex];
    _isPlaying = true;
    notifyListeners();
  }
}
