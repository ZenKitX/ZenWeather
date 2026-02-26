import 'package:location/location.dart';
import 'package:logger/logger.dart';
import '../data/local/storage_service.dart';

/// 定位服务
class LocationService {
  final Location _location = Location();
  final Logger _logger = Logger();

  /// 检查定位权限
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 检查定位服务是否启用
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _logger.w('定位服务未启用');
        return false;
      }
    }

    // 检查定位权限
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _logger.w('定位权限被拒绝');
        return false;
      }
    }

    return true;
  }

  /// 获取当前位置
  Future<LocationData?> getCurrentLocation() async {
    try {
      // 检查权限
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        return null;
      }

      // 获取位置
      final locationData = await _location.getLocation();
      
      // 保存位置
      if (locationData.latitude != null && locationData.longitude != null) {
        await StorageService.setLastLocation(
          locationData.latitude!,
          locationData.longitude!,
        );
      }

      return locationData;
    } catch (e) {
      _logger.e('获取位置失败: $e');
      return null;
    }
  }

  /// 获取上次保存的位置
  Future<LocationData?> getLastLocation() async {
    final lat = StorageService.getLastLatitude();
    final lon = StorageService.getLastLongitude();

    if (lat != null && lon != null) {
      return LocationData.fromMap({
        'latitude': lat,
        'longitude': lon,
      });
    }

    return null;
  }

  /// 监听位置变化
  Stream<LocationData> onLocationChanged() {
    return _location.onLocationChanged;
  }
}
