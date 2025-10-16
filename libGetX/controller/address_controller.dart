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
  RxBool isEditMode = false.obs;
  var useExisting = false.obs;
  var isLoading = false.obs;
  var countries = <GetCountry>[].obs;
  var cities = <CityModel>[].obs;
  var allCities = <CityModel>[].obs;

  var selectedCountry = Rxn<GetCountry>();
  var selectedRegion = Rxn<CityModel>();
  var selectedCity = Rxn<CityModel>();

  final Color accent = const Color(0xFF9E7041);

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    await load(1004);
    await loadCountries();
    await loadAllCities();
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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await loadCities(country!.countryId!);
      });
    }
  }

  void updateSelectedCity(CityModel? city) => selectedCity.value = city;
  void updateSelectedRegion(CityModel? city) => selectedRegion.value = city;

  void setUseExisting(bool value) => useExisting.value = value;
  void setLoading(bool value) => isLoading.value = value;
  void setEditMode(bool value) => isEditMode.value = value;

  // @override
  // void onClose() {
  //   firstName.dispose();
  //   lastName.dispose();
  //   email.dispose();
  //   phone.dispose();
  //   addressLine.dispose();
  //   buildingName.dispose();
  //   postCode.dispose();
  //   super.onClose();
  // }
}
