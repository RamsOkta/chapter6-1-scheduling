import 'package:get/get.dart';
import 'package:notifikasi_obat/app/data/medicine.dart';
import 'package:notifikasi_obat/app/helper/DbHelper.dart';

class HomeController extends GetxController with StateMixin<List<Medicine>> {
  var db = DbHelper();
  List<Medicine> listMedicines = <Medicine>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllMedicineData();
  }

  Future<void> getAllMedicineData() async {
    try {
      change(null, status: RxStatus.loading());
      listMedicines.clear();
      final List<Medicine> medicines = await db.queryAllRowsMedicine();
      listMedicines.addAll(medicines);
      if (listMedicines.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(listMedicines, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error("Failed to load medicine data: $e"));
    }
  }
}
