import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../services/api_service.dart';

class DeviceProvider extends ChangeNotifier {
  DeviceModel? _connectedDevice;
  List<DeviceModel> _userDevices = [];

  DeviceModel? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectedDevice != null;
  List<DeviceModel> get userDevices => List.unmodifiable(_userDevices);

  Future<void> loadDevices(String userId) async {
    _userDevices = await ApiService().getUserDevices(userId);
    notifyListeners();
  }

  void connect(DeviceModel device) {
    _connectedDevice = device;
    notifyListeners();
  }

  void disconnect() {
    _connectedDevice = null;
    notifyListeners();
  }
}
