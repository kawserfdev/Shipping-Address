import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../getmodel/address_model.dart';
import '../getmodel/all_countries_model.dart';
import '../getmodel/cities_model.dart';
import '../getservice/api_service.dart';

class AddressController extends GetxController {
  var addresses = <AddressModel>[].obs;
  final ApiService apiService = ApiService();
  var error = RxnString();
  final formKey = GlobalKey<FormState>();
  RxBool isEditMode = false.obs;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addressLine = TextEditingController();
  TextEditingController buildingName = TextEditingController();
  TextEditingController postCode = TextEditingController();

  var useExisting = false.obs;
  var isLoading = false.obs;

  var countries = <GetCountry>[].obs;
  var cities = <CityModel>[].obs;
  var allCities = <CityModel>[].obs;
  // RxInt countryId = 2.obs;
  // RxInt cityId = 3.obs;

  var selectedCountry = Rxn<GetCountry>();
  var selectedRegion = Rxn<CityModel>();
  var selectedCity = Rxn<CityModel>();

  final Color accent = const Color(0xFF9E7041);

  Future<void> initialize() async {
    await load(1004);
    await loadCountries();
    await loadAllCities();

    // if (countries.value.isNotEmpty) {
    //   countries.value.first.countryId = countryId.value;
    // }
    // if (allCities.value.isNotEmpty) {
    //   allCities.value.first.cityId = cityId.value;
    // }
  }

  Future<void> load(int memberId) async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await apiService.getAddressesByMember(memberId);
      addresses.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddress(int memberId) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

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
        cityId: selectedCity.value?.cityId,
        countryId: selectedCountry.value?.countryId,
        zipCode: postCode.text.trim(),
        isDefault: false,
      );

      await apiService.addAddress(newAddress);
      await load(memberId);

      Get.snackbar(
        "Success",
        "Address added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> loadDefault(int memberId) async {
  //   try {
  //     isLoading.value = true;
  //     error.value = null;
  //     final address = await apiService.getDefaultAddressByMember(memberId);
  //     defaultAddress.value = address;
  //   } catch (e) {
  //     error.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> updateAddress(int id, int memberId) async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final updatedAddress = AddressModel(
        memberShippingAddressId: id,
        memberId: memberId,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        mobileNo: phone.text.trim(),
        phoneCode: "+971",
        addressLine1: addressLine.text.trim(),
        addressLine2: buildingName.text.trim(),
        cityId: selectedCity.value?.cityId,
        countryId: selectedCountry.value?.countryId,
        zipCode: postCode.text.trim(),
        isDefault: true,
      );

      await apiService.editAddress(id, updatedAddress);
      await load(memberId);

      Get.snackbar(
        "Success",
        "Address updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> delete(int id, int memberId) async {
    try {
      await apiService.deleteAddress(id, memberId);
      await load(memberId);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> loadCountries() async {
    try {
      isLoading.value = true;
      final data = await apiService.getAllCountries();
      countries.assignAll(data);

      if (countries.isNotEmpty && selectedCountry.value == null) {
        selectedCountry.value = countries.first;
      }

      if (selectedCountry.value != null) {
        await loadCities(selectedCountry.value!.countryId!);
      }
    } catch (e) {
      debugPrint("Error loading countries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllCities() async {
    try {
      isLoading.value = true;
      allCities.assignAll(await apiService.getAllCities());
    } catch (e) {
      debugPrint("Error loading all cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCity(int cityId) async {
    try {
      isLoading.value = true;
      final city = await apiService.getCityById(cityId);
      selectedRegion.value = city;
    } catch (e) {
      debugPrint("Error loading city: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCities(int countryId) async {
    try {
      isLoading.value = true;
      final data = await apiService.getCitiesByCountry(countryId);
      cities.assignAll(data);

      if (cities.isNotEmpty && selectedRegion.value == null) {
        selectedRegion.value = cities.first;
      }
    } catch (e) {
      debugPrint("Error loading cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSelectedCountry(GetCountry? country) async {
    selectedCountry.value = country;
    selectedRegion.value = null;

    if (country?.countryId != null) {
      await loadCities(country!.countryId!);
    }
  }

  void updateSelectedCity(CityModel? city) => selectedCity.value = city;
  void updateSelectedRegion(CityModel? city) => selectedRegion.value = city;

  void setUseExisting(bool value) => useExisting.value = value;
  void setLoading(bool value) => isLoading.value = value;
  void setEditMode(bool value) => isEditMode.value = value;

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    addressLine.dispose();
    buildingName.dispose();
    postCode.dispose();
    super.onClose();
  }
}
