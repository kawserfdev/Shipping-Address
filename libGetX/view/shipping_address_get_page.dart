import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import '../getmodel/address_model.dart';
import '../getmodel/all_countries_model.dart';
import '../getmodel/cities_model.dart';
import '../getservice/api_service.dart';

class ShippingAddressPage extends StatefulWidget {
  final AddressModel? address;
  const ShippingAddressPage({super.key, this.address});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  AddressController controller = Get.put(AddressController());
  final formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addressLine = TextEditingController();
  TextEditingController buildingName = TextEditingController();
  TextEditingController postCode = TextEditingController();
  int memberId = 1004;
  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      debugPrint("Address Print${jsonEncode(widget.address)}");
      // controller.initialize();
      firstName.text = widget.address?.firstName ?? '';
      lastName.text = widget.address?.lastName ?? '';
      email.text = widget.address?.email ?? '';
      phone.text = widget.address?.mobileNo ?? '';
      addressLine.text = widget.address?.addressLine1 ?? '';
      buildingName.text = widget.address?.addressLine2 ?? '';
      postCode.text = widget.address?.zipCode ?? '';
      controller.selectedCountry.value = controller.countries.value
          .firstWhereOrNull(
            (c) => c.countryId == widget.address?.country?.countryId,
          );
      controller.selectedCity.value = controller.allCities.firstWhereOrNull(
        (c) => c.cityId == widget.address?.city?.cityId,
      );
      controller.selectedRegion.value = controller.cities.firstWhereOrNull(
        (c) => c.cityId == widget.address?.city?.cityId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFB47839);
    const bgColor = Color(0xFFFFFFFF);
    const appbarColor = Color(0xFFFDF7F2);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(145.0),
          child: _buildAppBar(appbarColor, primaryColor),
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.countries.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildForm(context);
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar(Color appbarColor, Color primaryColor) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: AppBar(
        backgroundColor: appbarColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: appbarColor,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 2),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Icon(
                      Icons.notification_add_outlined,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),

              // ======== Bottom Progress Section ========
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: appbarColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStepItem(
                        "Shopping Cart",
                        Icons.shopping_cart,
                        true,
                        primaryColor,
                      ),
                      _buildDivider(primaryColor, true),
                      _buildStepItem(
                        "Shipping Address",
                        Icons.location_on,
                        true,
                        primaryColor,
                      ),
                      _buildDivider(primaryColor, false),
                      _buildStepItem(
                        "Payment",
                        Icons.camera_alt,
                        false,
                        primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('First Name:'),
              _input(firstName, hint: 'Andru'),
              const SizedBox(height: 12),
              _label('Last Name:'),
              _input(lastName, hint: 'Thomas'),
              const SizedBox(height: 12),
              _label('Email Address:'),
              _input(email, hint: 'info@mail.com'),
              const SizedBox(height: 12),
              _label('Phone Number:'),
              _input(phone, hint: '+971 055 4836'),
              const SizedBox(height: 12),
              _label('Street Address:'),
              _input(addressLine, hint: 'Write Address'),
              const SizedBox(height: 12),
              _label('Building Name:'),
              _input(buildingName, hint: 'Write Building Name'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_label('City'), _dropdownCity(controller)],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Post Code:'),
                        _input(postCode, hint: 'Post Code', compact: true),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Country:'),
                        _dropdownCountry(context, controller),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Region / State:'),
                        _dropdownRegion(controller),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Radio<bool>(
                        value: true,
                        groupValue: controller.useExisting.value,
                        onChanged: (v) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.setUseExisting(v ?? false);
                          });
                        },
                        activeColor: controller.accent,
                      ),
                      title: const Text('Use An Existing Address'),
                      onTap: () => controller.setUseExisting(true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Radio<bool>(
                        value: false,
                        groupValue: controller.useExisting.value,
                        onChanged: (v) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.setUseExisting(v ?? false);
                          });
                        },
                        activeColor: controller.accent,
                      ),
                      title: const Text('Use A New Address'),
                      onTap: () => controller.setUseExisting(false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              _buildSubmitButtons(controller),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _clearAllFields() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phone.clear();
    addressLine.clear();
    buildingName.clear();
    postCode.clear();

    controller.selectedCountry.value = null;
    controller.selectedCity.value = null;
    controller.selectedRegion.value = null;
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _input(
    TextEditingController controller, {
    String? hint,
    bool compact = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
          vertical: compact ? 10 : 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _dropdownCountry(BuildContext context, AddressController c) {
    return Obx(
      () => DropdownButtonFormField<GetCountry>(
        value: c.selectedCountry.value,
        items: c.countries
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    e.countryName ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            c.updateSelectedCountry(value);
          });
        },
        decoration: _dropdownDecoration(),
        hint: const Text('Select Country'),
      ),
    );
  }

  Widget _dropdownCity(AddressController c) {
    return Obx(
      () => DropdownButtonFormField<CityModel>(
        value: c.selectedCity.value,
        items: c.allCities
            .map(
              (e) => DropdownMenuItem(value: e, child: Text(e.cityName ?? "")),
            )
            .toList(),
        onChanged: (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            c.updateSelectedCity(value);
          });
        },
        decoration: _dropdownDecoration(),
        hint: const Text('Select City'),
      ),
    );
  }

  Widget _dropdownRegion(AddressController c) {
    return Obx(
      () => DropdownButtonFormField<CityModel>(
        value: c.selectedRegion.value,
        items: c.cities
            .map(
              (e) => DropdownMenuItem(value: e, child: Text(e.cityName ?? "")),
            )
            .toList(),
        onChanged: (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            c.updateSelectedRegion(value);
          });
        },
        decoration: _dropdownDecoration(),
        hint: const Text('Select Region'),
      ),
    );
  }

  InputDecoration _dropdownDecoration() => InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    filled: true,
    fillColor: Colors.white,
  );

  Widget _buildSubmitButtons(AddressController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;

                        await _onContinue(controller);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        controller.isEditMode.value
                            ? 'Update Address'
                            : 'Add Address',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepItem(
    String title,
    IconData icon,
    bool isActive,
    Color activeColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? activeColor : Colors.grey.shade300,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Color activeColor, bool isActive) {
    return Expanded(
      child: Divider(
        thickness: 2,
        color: isActive ? activeColor : Colors.grey.shade400,
        height: 30,
      ),
    );
  }

  Future<void> _onContinue(AddressController controller) async {
    controller.setLoading(true);

    try {
      if (controller.isEditMode.value) {
        controller.isLoading.value = true;

        final updatedAddress = AddressModel(
          memberShippingAddressId: widget.address?.memberShippingAddressId,
          memberId: memberId,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          email: email.text.trim(),
          mobileNo: phone.text.trim(),
          phoneCode: "+971",
          addressLine1: addressLine.text.trim(),
          addressLine2: buildingName.text.trim(),
          cityId: controller.selectedCity.value?.cityId,
          countryId: controller.selectedCountry.value?.countryId,
          zipCode: postCode.text.trim(),
          isDefault: true,
        );

        await apiService.editAddress(
          widget.address!.memberShippingAddressId!,
          updatedAddress,
        );

        _clearAllFields(); // clear form fields

        Get.snackbar(
          "Success",
          "Address updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
        );
        await controller.load(memberId);
        // Get.back();
      } else {
        controller.isLoading.value = true;

        final newAddress = AddressModel(
          memberShippingAddressId: 0,
          memberId: memberId,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          email: email.text.trim(),
          mobileNo: phone.text.trim(),
          phoneCode: "+971",
          addressLine1: addressLine.text.trim(),
          addressLine2: buildingName.text.trim(),
          cityId: controller.selectedCity.value?.cityId,
          countryId: controller.selectedCountry.value?.countryId,
          zipCode: postCode.text.trim(),
          isDefault: false,
        );

        await apiService.addAddress(newAddress);

        _clearAllFields(); // clear form fields
        await controller.load(memberId);
        Get.snackbar(
          "Success",
          "Address added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
        );

        // Get.back();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      controller.setLoading(false);
      controller.isLoading.value = false;
    }
  }
}
