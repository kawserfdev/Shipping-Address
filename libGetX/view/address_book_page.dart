import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import '../getmodel/address_model.dart';
import '../routes/app_routes.dart';

class MyAddressBook extends GetView<AddressController> {
  const MyAddressBook({super.key});

  @override
  Widget build(BuildContext context) {
    int memberId = 1004;
    final controller = Get.find<AddressController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.load(memberId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('My Address Book'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.load(memberId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.addresses.isEmpty) {
          return const Center(child: Text('No addresses found.'));
        }

        return RefreshIndicator(
          onRefresh: () => controller.load(memberId),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.addresses.length,
            itemBuilder: (_, index) {
              final AddressModel address = controller.addresses[index];
              return GestureDetector(
                onTap: () {
                  controller.setEditMode(true);
                  Get.toNamed(Routes.address, arguments: address);
                },
                child: _buildAddressCard(
                  context,
                  controller,
                  address,
                  memberId,
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.setEditMode(false);
          Get.offNamed(Routes.address);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    AddressController controller,
    AddressModel address,
    int memberId,
  ) {
    final isDefault = address.isDefault ?? false;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          "${address.firstName ?? ''} ${address.lastName ?? ''}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              address.addressLine1 ?? '',
              style: const TextStyle(color: Colors.black54),
            ),
            if (address.addressLine2 != null &&
                address.addressLine2!.isNotEmpty)
              Text(
                address.addressLine2!,
                style: const TextStyle(color: Colors.black54),
              ),
            const SizedBox(height: 4),
            Text(
              "${address.city?.cityName ?? ''}, ${address.country?.countryName ?? ''} - ${address.zipCode ?? ''}",
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text("📞 ${address.mobileNo ?? ''}"),
            if (isDefault)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "Default Address",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete' && address.memberShippingAddressId != null) {
              Get.dialog(
                AlertDialog(
                  title: const Text('Delete Address'),
                  content: const Text(
                    'Are you sure you want to delete this address?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.delete(
                          address.memberShippingAddressId!,
                          memberId,
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }else{
              controller.setEditMode(true);
                  Get.toNamed(Routes.address, arguments: address);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
