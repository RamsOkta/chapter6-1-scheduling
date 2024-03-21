import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:notifikasi_obat/app/data/medicine.dart';
import 'package:notifikasi_obat/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: controller.obx(
        (state) => state!.isEmpty
            ? Center(child: Text("Data Kosong"))
            : ListView.builder(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  Medicine medicine = state[index];
                  return ListTile(
                    title: Text(medicine.name),
                    subtitle:
                        Text("${medicine.frequency.toString()} kali sehari"),
                    onTap: () => Get.toNamed(Routes.DETAIL_MEDICINE,
                        arguments: medicine.id),
                  );
                },
              ),
        onLoading: Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text("Error: $error")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_SCHEDULE);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
