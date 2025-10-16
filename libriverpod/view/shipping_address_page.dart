import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/address_model.dart';
import '../model/address_model_by_default_mbr.dart';
import '../model/all_countries_model.dart';
import '../model/cities_model.dart';
import '../provider/address_change_notifire.dart';
import '../provider/address_provider.dart';
import '../repository/address_repository.dart';
import '../utils/app_colors.dart';

class ShippingAddressPage extends ConsumerStatefulWidget {
  final AddressModelByMemberDefault? address;
  const ShippingAddressPage({Key? key, this.address}) : super(key: key);

  @override
  ConsumerState<ShippingAddressPage> createState() =>
      _ShippingAddressPageState();
}

class _ShippingAddressPageState extends ConsumerState<ShippingAddressPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(addressChangeNotifierProvider);
      final repo = ref.read(addressRepositoryProvider);
      notifier.initialize(widget.address, repo,context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(addressRepositoryProvider);
    final notifier = ref.watch(addressChangeNotifierProvider);
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: AppBar(
              backgroundColor: AppColors.appbarColor,
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
                            onTap: () {}, // => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black45),
                                color: Colors.white.withOpacity(0.9),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.notifications_rounded,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: AppColors.appbarColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 11,
                          horizontal: 17,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: [
                            _buildStepItem(
                              "Shopping Cart",
                              Icons.shopping_cart,
                              true,
                              AppColors.primaryColor,
                            ),
                            _buildDivider(AppColors.primaryColor, true),
                            _buildStepItem(
                              "Shipping Address",
                              Icons.location_on,
                              true,
                              AppColors.primaryColor,
                            ),
                            _buildDivider(AppColors.primaryColor, false),
                            _buildStepItem(
                              "Payment",
                              Icons.camera_alt,
                              false,
                              AppColors.primaryColor,
                            ),
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

                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Radio<bool>(
                                    value: true,
                                    groupValue: notifier.useExisting,
                                    onChanged: (v) =>
                                        notifier.setUseExisting(v ?? false),
                                    activeColor: notifier.accent,
                                  ),
                                  title: const Text('Use An Existing Address'),
                                  onTap: () => notifier.setUseExisting(true),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Radio<bool>(
                                    value: false,
                                    groupValue: notifier.useExisting,
                                    onChanged: (v) =>
                                        notifier.setUseExisting(v ?? false),
                                    activeColor: notifier.accent,
                                  ),
                                  title: const Text('Use A New Address'),
                                  onTap: () => notifier.setUseExisting(false),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: notifier.isLoading
                                      ? null
                                      : () {
                                          if (notifier.addressModel != null) {
                                            notifier.deleteAddress(repo);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Address Delete Successful',
                                                ),
                                              ),
                                            );
                                             notifier.loadAddress(repo,context);
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Address is null',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF7CECE),
                                    side: BorderSide(
                                      color: Colors.red.shade400,
                                    ),
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
                                      : const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: notifier.isLoading
                                      ? null
                                      : () => _onContinue(
                                          context,
                                          repo,
                                          notifier,
                                        ),
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
        child: DropdownButton<int>(
          isExpanded: true,
          value: notifier.selectedCity?.cityId,
          items: notifier.allCities
              .map(
                (c) => DropdownMenuItem<int>(
                  value: c.cityId,
                  child: Text(c.cityName ?? ""),
                ),
              )
              .toList(),
          onChanged: (value) {
            final selected = notifier.allCities.firstWhere(
              (c) => c.cityId == value,
              orElse: () => CityModel(),
            );
            notifier.updateSelectedCity(selected);
          },
          hint: const Text('Select City'),
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
        child: DropdownButton<int>(
          isExpanded: true,
          value: notifier.selectedRegion?.cityId,
          items: notifier.cities
              .map(
                (c) => DropdownMenuItem<int>(
                  value: c.cityId,
                  child: Text(c.cityName ?? ""),
                ),
              )
              .toList(),
          onChanged: (value) {
            final selected = notifier.cities.firstWhere(
              (c) => c.cityId == value,
              orElse: () => CityModel(),
            );
            notifier.updateSelectedRegion(selected);
          },
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
    if (notifier.selectedCountry == null || notifier.selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select country and city')),
      );
      return;
    }
    if (!notifier.formKey.currentState!.validate()) return;

    notifier.setLoading(true);

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
        isDefault: true,
      );

      debugPrint("Address Payload ${jsonEncode(model)}");

      if (notifier.useExisting == false) {
        await repo.createAddress(model);
        debugPrint("Address added Successful");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Address added Successful')));
        notifier.allClear();
        notifier.loadAddress(repo,context);
      } else {
        await repo.updateAddress(model.memberShippingAddressId!, model);
        // model = null;
        debugPrint("Address added Successful");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Address Edit Successful')));
        notifier.allClear();
        notifier.loadAddress(repo,context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      notifier.setLoading(false);
    }
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
            fontSize: 12.5,
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

  // (unused helper removed)
}
