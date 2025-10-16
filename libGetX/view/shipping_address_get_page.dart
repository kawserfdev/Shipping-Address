import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';
import '../getmodel/address_model.dart';
import '../getmodel/all_countries_model.dart';
import '../getmodel/cities_model.dart';

class ShippingAddressPage extends StatefulWidget {
  final AddressModel? address;
  const ShippingAddressPage({super.key, this.address});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  late AddressController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddressController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.initialize(widget.address);

      controller.firstName.text = widget.address?.firstName ?? '';
      controller.lastName.text = widget.address?.lastName ?? '';
      controller.email.text = widget.address?.email ?? '';
      controller.phone.text = widget.address?.mobileNo ?? '';
      controller.addressLine.text = widget.address?.addressLine1 ?? '';
      controller.buildingName.text = widget.address?.addressLine2 ?? '';
      controller.postCode.text = widget.address?.zipCode ?? '';

      // Preselect country, city, region if available
      if (widget.address?.country != null) {
        final country = controller.countries.firstWhereOrNull(
          (c) => c.countryId == widget.address?.country!.countryId,
        );
        if (country != null) controller.selectedCountry.value = country;
      }

      if (widget.address?.city != null) {
        final city = controller.allCities.firstWhereOrNull(
          (c) => c.cityId == widget.address?.city!.cityId,
        );
        if (city != null) controller.selectedCity.value = city;
      }
    });
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
                      onTap: () => Navigator.pop(context),
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
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('First Name:'),
            _input(controller.firstName, hint: 'Andru'),
            const SizedBox(height: 12),
            _label('Last Name:'),
            _input(controller.lastName, hint: 'Thomas'),
            const SizedBox(height: 12),
            _label('Email Address:'),
            _input(controller.email, hint: 'info@mail.com'),
            const SizedBox(height: 12),
            _label('Phone Number:'),
            _input(controller.phone, hint: '+971 055 4836'),
            const SizedBox(height: 12),
            _label('Street Address:'),
            _input(controller.addressLine, hint: 'Write Address'),
            const SizedBox(height: 12),
            _label('Building Name:'),
            _input(controller.buildingName, hint: 'Write Building Name'),
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
                      _input(
                        controller.postCode,
                        hint: 'Post Code',
                        compact: true,
                      ),
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
                      _dropdownCountry(controller),
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
            _buildSubmitButtons(),
          ],
        ),
      ),
    );
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

  Widget _dropdownCountry(AddressController c) {
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
        onChanged: c.updateSelectedCountry,
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
        onChanged: c.updateSelectedCity,
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
        onChanged: c.updateSelectedRegion,
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

  Widget _buildSubmitButtons() {
    return Column(
      children: [
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (!controller.formKey.currentState!.validate()) return;
                  await _onContinue();
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step Item (Circle + Label)
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

  // Divider between steps
  Widget _buildDivider(Color activeColor, bool isActive) {
    return Expanded(
      child: Divider(
        thickness: 2,
        color: isActive ? activeColor : Colors.grey.shade400,
        height: 30,
      ),
    );
  }

  Future<void> _onContinue() async {
    controller.setLoading(true);

    try {
      final model = AddressModel(
        memberShippingAddressId: widget.address?.memberShippingAddressId ?? 0,
        memberId: widget.address?.memberId ?? 1004,
        firstName: controller.firstName.text,
        lastName: controller.lastName.text,
        email: controller.email.text,
        mobileNo: controller.phone.text,
        phoneCode: '+971',
        addressLine1: controller.addressLine.text,
        addressLine2: controller.buildingName.text,
        cityId: controller.selectedCity.value?.cityId,
        countryId: controller.selectedCountry.value?.countryId,
        zipCode: controller.postCode.text,
        isDefault: false,
      );
      if (widget.address != null) {
        await controller.repo?.updateAddress(
          model.memberShippingAddressId!,
          model,
        );
      } else {
        await controller.repo?.createAddress(model);
      }

      Get.snackbar('Success', 'Address updated successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed: $e');
    } finally {
      controller.setLoading(false);
    }
  }
}
