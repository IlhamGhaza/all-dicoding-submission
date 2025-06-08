import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Memeriksa dan meminta izin untuk mengakses foto (Android 13+) atau penyimpanan eksternal (Android <13).
///
/// Mengembalikan `true` jika izin diberikan, `false` jika tidak.
///
/// Catatan Penting:
/// - Fungsi ini secara dinamis memilih izin yang sesuai berdasarkan versi Android:
///   - **Android 13 (API 33) ke atas**: Meminta `Permission.photos` (memerlukan `READ_MEDIA_IMAGES` di AndroidManifest).
///   - **Di bawah Android 13**: Meminta `Permission.storage` (memerlukan `READ_EXTERNAL_STORAGE` di AndroidManifest,
///     disarankan dengan `android:maxSdkVersion="32"`).
/// - Jika Anda memerlukan akses ke jenis media lain (video, audio) di Android 13+,
///   Anda perlu membuat handler serupa atau memperluas fungsi ini untuk `Permission.videos` atau `Permission.audio`.
/// - Untuk akses ke semua file (misalnya, aplikasi file manager) di Android 11 (API 30) ke atas,
///   Anda mungkin memerlukan `Permission.manageExternalStorage`, yang biasanya
///   memerlukan pengguna untuk diarahkan ke pengaturan sistem.
/// - Jika aplikasi Anda menargetkan Android 10 (API 29) atau lebih rendah dan memerlukan
///   akses penyimpanan legacy, pastikan `android:requestLegacyExternalStorage="true"`
///   ada di `AndroidManifest.xml`.
Future<bool> checkAndroidExternalStoragePermission() async {
  try {
    Permission permissionToRequest;
    String permissionName;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt >= 33) {
        permissionToRequest = Permission.photos;
        permissionName = "foto (READ_MEDIA_IMAGES)";
      } else {
        permissionToRequest = Permission.storage;
        permissionName = "penyimpanan eksternal (READ_EXTERNAL_STORAGE)";
      }
    } else if (Platform.isIOS) {
      permissionToRequest = Permission.photos;
      permissionName = "galeri foto";
    } else {
      debugPrint(
        "Pengecekan izin penyimpanan/foto tidak relevan untuk platform ini.",
      );
      return true; // Platform lain (web, desktop) diasumsikan tidak memerlukan izin
    }

    PermissionStatus status = await permissionToRequest.status;
    debugPrint("Status awal izin $permissionName: $status");

    if (status.isGranted) {
      debugPrint("Izin $permissionName sudah diberikan.");
      return true;
    }

    if (status.isPermanentlyDenied) {
      debugPrint(
        "Izin $permissionName ditolak secara permanen. Membuka pengaturan aplikasi...",
      );
      await openAppSettings();
      return Future.error("Izin $permissionName ditolak secara permanen.");
    }

    if (status.isRestricted) {
      debugPrint(
        "Izin $permissionName dibatasi (misalnya oleh kontrol orang tua atau kebijakan perusahaan).",
      );
      return Future.error("Izin $permissionName dibatasi.");
    }

    // Jika status .isDenied atau status lain yang masih memungkinkan permintaan (misalnya .isLimited)
        debugPrint("Meminta izin $permissionName...");
        PermissionStatus newStatus = await permissionToRequest.request();
        debugPrint(
          "Status baru izin $permissionName setelah permintaan: $newStatus",
        );

        if (newStatus.isGranted) {
      debugPrint("Izin $permissionName berhasil diberikan setelah permintaan.");
      return true;
        } else if (newStatus.isPermanentlyDenied) {
          debugPrint(
        "Izin $permissionName ditolak secara permanen setelah permintaan. Membuka pengaturan aplikasi...",
          );
          await openAppSettings();
          return Future.error("Izin $permissionName ditolak secara permanen.");
        } else {
          debugPrint(
        "Izin $permissionName tidak diberikan setelah permintaan (status: $newStatus).",
          );
      return Future.error("Izin $permissionName tidak diberikan setelah permintaan.");
    }
  } catch (e) {
    debugPrint(
      "Error saat memeriksa atau meminta izin akses foto/penyimpanan: $e",
    );
    return Future.error("Error saat memeriksa atau meminta izin akses foto/penyimpanan: $e");
  }
}

/// Memeriksa dan meminta izin notifikasi.
///
/// Mengembalikan `true` jika izin diberikan, `false` jika tidak.
/// Izin notifikasi (`POST_NOTIFICATIONS`) diperlukan terutama untuk Android 13 (API 33) ke atas.
/// Pada versi Android yang lebih lama, izin ini biasanya diberikan secara default.
// Future<bool> checkNotificationPermission() async {
//   try {
//     PermissionStatus status = await Permission.notification.status;
//     debugPrint("Status awal izin notifikasi: $status");

//     if (status.isGranted) {
//       debugPrint("Izin notifikasi sudah diberikan.");
//       return true;
//     }

//     if (status.isPermanentlyDenied) {
//       debugPrint(
//         "Izin notifikasi ditolak secara permanen. Membuka pengaturan aplikasi...",
//       );
//       await openAppSettings();
//       return false;
//     }

//     if (status.isRestricted) {
//       debugPrint("Izin notifikasi dibatasi.");
//       return false;
//     }

//     debugPrint("Meminta izin notifikasi...");
//     PermissionStatus newStatus = await Permission.notification.request();
//     debugPrint("Status baru izin notifikasi setelah permintaan: $newStatus");

//     return newStatus.isGranted;
//   } catch (e) {
//     debugPrint("Error saat memeriksa atau meminta izin notifikasi: $e");
//     return false;
//   }
// }

/// Memeriksa dan meminta izin kamera.
///
/// Mengembalikan `true` jika izin diberikan.
/// Melemparkan error jika izin ditolak, dibatasi, atau terjadi kesalahan.
Future<bool> checkCameraPermission() async {
  const permissionName = "kamera";
  try {
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint("Pengecekan izin kamera tidak relevan untuk platform ini.");
      return true; // Platform lain (web, desktop) diasumsikan tidak memerlukan izin
    }

    PermissionStatus status = await Permission.camera.status;
    debugPrint("Status awal izin $permissionName: $status");

    if (status.isGranted) {
      debugPrint("Izin $permissionName sudah diberikan.");
      return true;
    }

    if (status.isPermanentlyDenied) {
      debugPrint(
        "Izin $permissionName ditolak secara permanen. Membuka pengaturan aplikasi...",
      );
      await openAppSettings();
      return Future.error("Izin $permissionName ditolak secara permanen.");
    }

    if (status.isRestricted) {
      debugPrint("Izin $permissionName dibatasi.");
      return Future.error("Izin $permissionName dibatasi.");
    }

        debugPrint("Meminta izin $permissionName...");
        PermissionStatus newStatus = await Permission.camera.request();
        debugPrint(
          "Status baru izin $permissionName setelah permintaan: $newStatus",
        );

        if (newStatus.isGranted) {
      debugPrint("Izin $permissionName berhasil diberikan setelah permintaan.");
      return true;
        } else if (newStatus.isPermanentlyDenied) {
          debugPrint(
        "Izin $permissionName ditolak secara permanen setelah permintaan. Membuka pengaturan aplikasi...",
          );
          await openAppSettings();
          return Future.error("Izin $permissionName ditolak secara permanen.");
        } else {
          debugPrint(
        "Izin $permissionName tidak diberikan setelah permintaan (status: $newStatus).",
          );
      return Future.error("Izin $permissionName tidak diberikan setelah permintaan.");
    }
  } catch (e) {
    debugPrint("Error saat memeriksa atau meminta izin $permissionName: $e");
    return Future.error("Error saat memeriksa atau meminta izin $permissionName: $e");
  }
}

/// Memeriksa dan meminta izin telepon (hanya untuk panggilan).
///
/// Mengembalikan `true` jika izin diberikan.
/// Melemparkan error jika izin ditolak, dibatasi, atau terjadi kesalahan.
/// Menggunakan `Permission.phone` yang mungkin mencakup beberapa izin terkait telepon.
