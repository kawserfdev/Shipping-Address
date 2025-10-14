import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shipping/model/address_model.dart';
import 'package:shipping/model/all_countries_model.dart';
import 'package:shipping/model/cities_model.dart';
import 'package:shipping/repository/address_repository.dart';

final addressChangeNotifierProvider = ChangeNotifierProvider<AddressChangeNotifier>((ref) {
  return AddressChangeNotifier();
});


class AddressChangeNotifier extends ChangeNotifier {
  // Form key and controllers
  final formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final addressLine = TextEditingController();
  final buildingName = TextEditingController();
  final postCode = TextEditingController();

  // States
  bool useExisting = false;
  bool isLoading = false;

  // Country and city data
  List<GetCountry> countries = [];
  List<CityModel> cities = [];
  GetCountry? selectedCountry;
  CityModel? selectedRegion;
  CityModel? selectedCity;

  final Color accent = const Color(0xFF9E7041);

  // Initialize with existing address if any
  void initialize(AddressModel? address, AddressRepository repo) async {
    if (address != null) {
      firstName.text = address.firstName ?? "";
      lastName.text = address.lastName ?? "";
      email.text = address.email ?? "";
      phone.text = address.mobileNo ?? "";
      addressLine.text = address.addressLine1 ?? "";
      postCode.text = address.zipCode ?? "";
    }
    await loadCountries(repo);
    await loadCity(repo);
    notifyListeners();
  }

  // Load country list
  Future<void> loadCountries(AddressRepository repo) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await repo.fetchCountries();
      countries = data;
      if (countries.isNotEmpty) selectedCountry ??= countries.first;

      // if (selectedCountry != null) {
      //   await loadCities(repo, selectedCountry!.countryId!);
      // }
    } catch (e) {
      debugPrint("Error loading countries: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
 // load city list
    Future<void> loadCity(AddressRepository repo) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await repo.fetchAllCities();
      cities = data;
      if (cities.isNotEmpty) selectedCity ??= cities.first;

      if (selectedCity != null) {
        await loadCities(repo, selectedCity!.cityId!);
      }
    } catch (e) {
      debugPrint("Error loading countries: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load city list by country
  Future<void> loadCities(AddressRepository repo, int countryId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await repo.fetchCitiesByCountry(countryId);
      cities = data;
      if (cities.isNotEmpty) selectedCity ??= cities.first;
    } catch (e) {
      debugPrint("Error loading cities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // Change country
  void updateSelectedCountry(GetCountry? country, AddressRepository repo) async {

    selectedCountry = country;
    selectedCity = null;
    notifyListeners();
    if (country?.countryId != null) {
      await loadCities(repo, country!.countryId!);
    }
  }

  // Change city
  void updateSelectedCity(CityModel? city) {
    selectedCity = city;
    notifyListeners();
  }

    // Change Region
  void updateSelectedRegion(CityModel? city) {
    selectedRegion = city;
    notifyListeners();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    addressLine.dispose();
    buildingName.dispose();
    postCode.dispose();
    super.dispose();
  }
}

