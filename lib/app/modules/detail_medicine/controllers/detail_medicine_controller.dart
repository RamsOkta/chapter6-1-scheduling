import 'package:get/get.dart';
import 'package:notifikasi_obat/app/data/medicine.dart';
import 'package:notifikasi_obat/app/data/notification.dart';
import 'package:notifikasi_obat/app/helper/DbHelper.dart';
import 'package:notifikasi_obat/app/modules/home/controllers/home_controller.dart';
import 'package:notifikasi_obat/app/utils/notification_api.dart' as notif;

class DetailMedicineController extends GetxController {
  var db = DbHelper();
  HomeController homeController = Get.find();
  late List<Notification> listNotification = [];

  Future<Medicine> getMedicineData(int id) async {
    return await db.queryOneMedicine(id);
  }

  Future<List<Notification>> getNotificationData(int id) async {
    listNotification = await db.getNotificationsByMedicineId(id);
    return listNotification;
  }

  void deleteMedicine(int id) async {
    listNotification.forEach((element) {
      notif.NotificationApi.cancelNotification(element.id!);
    });
    await db.deleteMedicine(id);
    await db.deleteNotificationByMedicineId(id);

    homeController.getAllMedicineData();
    Get.back();
  }
}
