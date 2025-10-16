import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../address_repository/address_repository.dart';
import '../getmodel/address_model.dart';
import '../getmodel/all_countries_model.dart';
import '../getmodel/cities_model.dart';

class AddressController extends GetxController {
  final AddressRepository? repo;
  AddressController(this.repo);

  var addresses = <AddressModel>[].obs;
  var error = RxnString();
  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final addressLine = TextEditingController();
  final buildingName = TextEditingController();
  final postCode = TextEditingController();

  var useExisting = false.obs;
  var isLoading = false.obs;

  var countries = <GetCountry>[].obs;
  var cities = <CityModel>[].obs;
  var allCities = <CityModel>[].obs;

  var selectedCountry = Rxn<GetCountry>();
  var selectedRegion = Rxn<CityModel>();
  var selectedCity = Rxn<CityModel>();

  final Color accent = const Color(0xFF9E7041);

  Future<void> initialize(AddressModel? address) async {
    if (address != null) {
      firstName.text = address.firstName ?? "";
      lastName.text = address.lastName ?? "";
      email.text = address.email ?? "";
      phone.text = address.mobileNo ?? "";
      addressLine.text = address.addressLine1 ?? "";
      postCode.text = address.zipCode ?? "";
    }
    await load(1004);
    await loadCountries();
    await loadAllCities();
    
  }

  Future<void> load(int memberId) async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await repo?.fetchAddresses(memberId);
      addresses.assignAll(list!);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> delete(int id, int memberId) async {
    try {
      await repo?.removeAddress(id, memberId);
      await load(memberId);
    } catch (e) {
      error.value = e.toString();
    }
  }




  Future<void> loadCountries() async {
    try {
      isLoading.value = true;
      final data = await repo?.fetchCountries();
      countries.assignAll(data!);

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
      allCities.assignAll(await repo!.fetchAllCities());
    } catch (e) {
      debugPrint("Error loading all cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCity( int cityId) async {
    try {
      isLoading.value = true;
      final city = await repo?.fetchCityById(cityId);
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
      final data = await repo?.fetchCitiesByCountry(countryId);
      cities.assignAll(data!);

      if (cities.isNotEmpty && selectedRegion.value == null) {
        selectedRegion.value = cities.first;
      }
    } catch (e) {
      debugPrint("Error loading cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSelectedCountry(
    GetCountry? country,
  ) async {
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
