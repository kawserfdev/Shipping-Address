import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shipping/model/address_model.dart';
import 'package:shipping/model/all_countries_model.dart';
import 'package:shipping/model/cities_model.dart';
import 'package:shipping/provider/address_change_notifire.dart';
import 'package:shipping/provider/address_provider.dart';
import 'package:shipping/repository/address_repository.dart';

class ShippingAddressPage extends ConsumerStatefulWidget {
  final AddressModel? address;
  const ShippingAddressPage({Key? key, this.address}) : super(key: key);

  @override
  ConsumerState<ShippingAddressPage> createState() =>
      _ShippingAddressPageState();
}

class _ShippingAddressPageState extends ConsumerState<ShippingAddressPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(addressChangeNotifierProvider);
      final repo = ref.read(addressRepositoryProvider);
      notifier.initialize(widget.address, repo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(addressRepositoryProvider);
    final notifier = ref.watch(addressChangeNotifierProvider);
    const primaryColor = Color(0xFFB47839);
    const bgColor = Color(0xFFFFFFFF);
    const appbarColor= Color(0xFFFDF7F2);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140.0),
        child: ClipRRect(
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
                  // ======== Top Row ========
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.black87),
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
                          _buildStepItem("Shopping Cart", Icons.shopping_cart, true, primaryColor),
                          _buildDivider(primaryColor, true),
                          _buildStepItem("Shipping Address", Icons.location_on, true, primaryColor),
                          _buildDivider(primaryColor, false),
                          _buildStepItem("Payment", Icons.camera_alt, false, primaryColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: notifier.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('First Name:'),
                        _input(notifier.firstName, hint: 'Andru'),
                        const SizedBox(height: 12),
                        _label('Last Name:'),
                        _input(notifier.lastName, hint: 'Thomas'),
                        const SizedBox(height: 12),
                        _label('Email Address:'),
                        _input(
                          notifier.email,
                          hint: 'info@mail.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        _label('Phone Number:'),
                        _input(
                          notifier.phone,
                          hint: '+971 055 4836',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        _label('Street Address:'),
                        _input(notifier.addressLine, hint: 'Write Address'),
                        const SizedBox(height: 12),
                        _label('Building Name:'),
                        _input(
                          notifier.buildingName,
                          hint: 'Write Building Name',
                        ),
                        const SizedBox(height: 12),

                        // City + Postcode Row
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('City'),
                                  _dropdownCity(notifier),
                                ],
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
                                    notifier.postCode,
                                    hint: 'Post Code',
                                    compact: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Country + Region Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Country:'),
                                  _dropdownCountry(notifier, repo),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Region / State:'),
                                  _dropdownRegion(notifier),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Use existing/new
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Radio<bool>(
                                  value: true,
                                  groupValue: notifier.useExisting,
                                  onChanged: (v) =>
                                      notifier.useExisting = v ?? false,
                                  activeColor: notifier.accent,
                                ),
                                title: const Text('Use An Existing Address'),
                                onTap: () => notifier.useExisting = true,
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Radio<bool>(
                                  value: false,
                                  groupValue: notifier.useExisting,
                                  onChanged: (v) =>
                                      notifier.useExisting = v ?? false,
                                  activeColor: notifier.accent,
                                ),
                                title: const Text('Use A New Address'),
                                onTap: () => notifier.useExisting = false,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.grey.shade400),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
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
                                onPressed: notifier.isLoading
                                    ? null
                                    : () =>
                                          _onContinue(context, repo, notifier),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: notifier.accent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: notifier.isLoading
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Continue'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _progressItem(Icons.shopping_cart, 'Shopping Cart', accent, true),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          _progressItem(Icons.location_on, 'Shipping Address', accent, true),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          _progressItem(Icons.camera_alt, 'Payment', accent, false),
        ],
      ),
    );
  }

  Widget _progressItem(IconData icon, String label, Color accent, bool done) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: done ? accent : Colors.grey.shade300,
          radius: 18,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _input(
    TextEditingController controller, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool compact = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(
          vertical: compact ? 10 : 14,
          horizontal: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _dropdownCountry(
    AddressChangeNotifier notifier,
    AddressRepository repo,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GetCountry>(
          isExpanded: true,
          value: notifier.selectedCountry,
          items: notifier.countries
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.countryName ?? ""),
                ),
              )
              .toList(),
          onChanged: (v) => notifier.updateSelectedCountry(v, repo),
          hint: const Text('Select country'),
        ),
      ),
    );
  }

  Widget _dropdownCity(AddressChangeNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CityModel>(
          isExpanded: true,
          value: notifier.selectedCity,
          items: notifier.cities
              .map(
                (c) =>
                    DropdownMenuItem(value: c, child: Text(c.cityName ?? "")),
              )
              .toList(),
          onChanged: notifier.updateSelectedCity,
          hint: const Text('Select city'),
        ),
      ),
    );
  }

  Widget _dropdownRegion(AddressChangeNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CityModel>(
          isExpanded: true,
          value: notifier.selectedRegion,
          items: notifier.cities
              .map(
                (c) =>
                    DropdownMenuItem(value: c, child: Text(c.cityName ?? "")),
              )
              .toList(),
          onChanged: notifier.updateSelectedRegion,
          hint: const Text('Select Region'),
        ),
      ),
    );
  }

  Future<void> _onContinue(
    BuildContext context,
    AddressRepository repo,
    AddressChangeNotifier notifier,
  ) async {
    if (notifier.useExisting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select existing address not implemented'),
        ),
      );
      return;
    }
    if (!notifier.formKey.currentState!.validate()) return;

    notifier.isLoading = true;
    notifier.notifyListeners();

    try {
      final model = AddressModel(
        memberShippingAddressId: widget.address?.memberShippingAddressId ?? 0,
        memberId: widget.address?.memberId ?? 1004,
        firstName: notifier.firstName.text.trim(),
        lastName: notifier.lastName.text.trim(),
        email: notifier.email.text.trim(),
        mobileNo: notifier.phone.text.trim(),
        phoneCode: '+971',
        addressLine1: notifier.addressLine.text.trim(),
        addressLine2: notifier.buildingName.text.trim().isEmpty
            ? null
            : notifier.buildingName.text.trim(),
        cityId: notifier.selectedCity?.cityId ?? 0,
        countryId: notifier.selectedCountry?.countryId ?? 0,
        zipCode: notifier.postCode.text.trim(),
        isDefault: false,
      );

      if (widget.address == null) {
        await repo.createAddress(model);
      } else {
        await repo.updateAddress(model.memberShippingAddressId!, model);
      }

      if (context.mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      notifier.isLoading = false;
      notifier.notifyListeners();
    }
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

  // Text field builder
  Widget _buildTextField({required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFB58B54)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
