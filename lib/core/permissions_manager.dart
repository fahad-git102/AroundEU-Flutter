import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  bool _isRequesting = false;

  Future<Map<String, PermissionStatus>> requestPermissions() async {
    if (_isRequesting) {
      return {};
    }

    _isRequesting = true;

    try {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.location,
        Permission.storage,
      ].request();

      PermissionStatus locationStatus = permissions[Permission.location] ?? PermissionStatus.denied;
      PermissionStatus storageStatus = permissions[Permission.storage] ?? PermissionStatus.denied;
      return {
        'location': locationStatus,
        'storage': storageStatus,
      };
    } finally {
      _isRequesting = false;
    }
  }

  void checkPermissions() async {
    Map<String, PermissionStatus> permissions = await requestPermissions();

    if (permissions['location']?.isGranted == true &&
        permissions['storage']?.isGranted == true) {
    } else {
    }
  }
}
