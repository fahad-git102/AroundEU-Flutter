import 'package:permission_handler/permission_handler.dart';

class PermissionsManager{
  Future<Map<String, PermissionStatus>> requestPermissions() async {
    // Request permissions for location, storage, and microphone
    Map<Permission, PermissionStatus> permissions = await [
      Permission.location,
      Permission.storage,
      // Permission.microphone,
    ].request();

    // Check each permission's status
    PermissionStatus locationStatus = permissions[Permission.location] ?? PermissionStatus.denied;
    PermissionStatus storageStatus = permissions[Permission.storage] ?? PermissionStatus.denied;
    // PermissionStatus microphoneStatus = permissions[Permission.microphone] ?? PermissionStatus.denied;

    return {
      'location': locationStatus,
      'storage': storageStatus,
      // 'microphone': microphoneStatus,
    };
  }

  void checkPermissions() async {
    Map<String, PermissionStatus> permissions = await requestPermissions();

    if (permissions['location']!.isGranted &&
        permissions['storage']!.isGranted) {
        // permissions['microphone']!.isGranted) {
    } else {
      // You can also guide the user to the app settings to manually grant permissions if needed
    }
  }

}