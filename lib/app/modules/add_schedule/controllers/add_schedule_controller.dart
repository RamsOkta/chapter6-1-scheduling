import 'package:get/get.dart';
import 'package:notifikasi_obat/app/data/medicine.dart';
import 'package:notifikasi_obat/app/helper/DbHelper.dart';
import 'package:notifikasi_obat/app/modules/home/controllers/home_controller.dart';
import 'package:notifikasi_obat/app/utils/notification_api.dart' as notif;
import 'package:flutter/material.dart';
import 'package:notifikasi_obat/app/data/notification.dart' as notif;

class AddScheduleController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController frequencyController;
  final List<TextEditingController> timeController =
      <TextEditingController>[].obs;

  var db = DbHelper();
  final frequency = 0.obs;

  HomeController homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    notif.NotificationApi.init();

    nameController = TextEditingController();
    frequencyController = TextEditingController();
  }

  void add(String name, int frequency) async {
    await db.insertMedicine(Medicine(name: name, frequency: frequency));

    var lastMedicineId = await db.getLastMedicineId();

    for (int i = 0; i < frequency; i++) {
      final controller =
          TextEditingController(); // Tambahkan kontrol waktu baru
      timeController.add(controller); // Tambahkan kontrol waktu ke dalam list
      String timeText = timeController[i].text;
      // Periksa apakah format waktu sesuai dengan yang diharapkan (hh:mm)
      RegExp timeRegex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
      if (timeRegex.hasMatch(timeText)) {
        await db.insertNotification(
            notif.Notification(idMedicine: lastMedicineId, time: timeText));
      } else {
        // Jika format waktu tidak sesuai, tampilkan pesan kesalahan
        print('Invalid time format at index $i');
        // Keluar dari loop dan hentikan proses penambahan notifikasi
        break;
      }
    }

    List<notif.Notification> notifications =
        await db.getNotificationsByMedicineId(lastMedicineId);

    for (var element in notifications) {
      notif.NotificationApi.scheduledNotification(
        id: element.id!,
        title: "Waktunya minum obat $name",
        body: "Minum obat agar cepat sembuh :)",
        payload: name,
        scheduledDate: DateTime(int.parse(element.time.split(':')[0]),
            int.parse(element.time.split(':')[1]), 0),
      );
    }

    homeController.getAllMedicineData();
    Get.back();
  }
}
