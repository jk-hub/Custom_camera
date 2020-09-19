library own_camera.globals;

import 'dart:io';

// import 'package:simple_permissions/simple_permissions.dart';

// initPlatformState() async {
//   try {
//     await Permission.getPermissionsStatus([PermissionName.Storage])
//         .then((List<Permissions> v) {
//       print(v[0].permissionStatus);
//       if (v[0].permissionStatus == PermissionStatus.deny ||
//           v[0].permissionStatus == PermissionStatus.notDecided ||
//           v[0].permissionStatus == PermissionStatus.notAgain) {
//         Permission.requestPermissions([PermissionName.Storage]).then((d) {
//           print(d);
//         });
//       }
//     });
//     getDir(); //checks if files already exists if not it creates the required folders
//   } on PlatformException {
//     print('Failed to get platform version.');
//   }
//   bool mounted;
//   if (!mounted) return;
// }

// var permissionResult = await SimplePermissions.requestPermission(
//     Permission.WriteExternalStorage);
// if (permissionResult == PermissionStatus.authorized) {
//   // code of read or write file in external storage (SD card)
//   print("storage permission status -----------$permissionResult");

Future getDir() async {
  var folderName = 'Own_Camera_Demo';
  var subFolderName = 'Media';
  final path = Directory("storage/emulated/0/$folderName/$subFolderName");
  if ((await path.exists())) {
    print("exist");
  } else {
    print("not exist");
    await path.create(
      recursive: true,
    );
    print('custom dir path--- ${path.path}');
  }
  return path.path;
}
