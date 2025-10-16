import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/address_model.dart';
import '../model/all_countries_model.dart';
import '../model/cities_model.dart';
import '../repository/address_repository.dart';

class AddressChangeNotifier extends ChangeNotifier {
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
  AddressModelByMemberDefault? addressModel;
  List<GetCountry> countries = [];
  List<CityModel> cities = [];
  List<CityModel> allCities = [];

  GetCountry? selectedCountry;
  CityModel? selectedRegion;
  CityModel? selectedCity;

  final Color accent = const Color(0xFFB47839);

  void initialize(
    AddressModelByMemberDefault? address,
    AddressRepository repo, BuildContext context
  ) async {
    await loadCountries(repo);
    await loadAllCities(repo);
    await loadAddress(repo,context);
    if (address != null) {
      _populateFields(address);
    }
    notifyListeners();
  }

  Future<void> loadAddress(AddressRepository repo, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await repo.fetchDefaultAddress(1004);

      if (data != null) {
        addressModel = data;
        _populateFields(addressModel!);
        if (addressModel!=null) {
          ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Default Address Loaded')));
        }else{
           ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No Default Address Found')));
        }
        
        debugPrint("Loaded Default Address: ${jsonEncode(addressModel)}");
      } else {
        debugPrint("No addresses found for member: 1004");
      }
    } catch (e, stack) {
      debugPrint("Error loading address: $e");
      debugPrint(stack.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(AddressRepository repo) async {
    try {
      isLoading = true;
      notifyListeners();

      final addressId = addressModel?.memberShippingAddressId;
      final memberId = addressModel?.memberId;

      if (addressId == null || memberId == null) {
        throw Exception('Invalid address data');
      }

      await repo.removeAddress(addressId, memberId);

      addressModel = null;
      allClear();
    } catch (e, stack) {
      debugPrint(" Error deleting address: $e");
      debugPrint(stack.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _populateFields(AddressModelByMemberDefault address) {
    firstName.text = address.firstName ?? "";
    lastName.text = address.lastName ?? "";
    email.text = address.email ?? "";
    phone.text = address.mobileNo ?? "";
    addressLine.text = address.addressLine1 ?? "";
    buildingName.text = address.addressLine2 ?? "";
    postCode.text = address.zipCode ?? "";
  }

  void allClear() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phone.clear();
    addressLine.clear();
    buildingName.clear();
    postCode.clear();
    cities = [];
    addressModel = null;
  }

  // Load country list
  Future<void> loadCountries(AddressRepository repo) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await repo.fetchCountries();
      countries = data;
      if (countries.isNotEmpty) selectedCountry ??= countries.first;
      debugPrint("Country ${countries}");
      if (selectedCountry != null) {
        debugPrint("Selected Country ${selectedCountry}");
        await loadCities(repo, selectedCountry!.countryId!);
      }
    } catch (e) {
      debugPrint("Error loading countries: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Load City list
  Future<void> loadAllCities(AddressRepository repo) async {
    try {
      isLoading = true;
      notifyListeners();
      allCities = await repo.fetchAllCities();
    } catch (e) {
      debugPrint("Error loading all cities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // load city list
  Future<void> loadCity(AddressRepository repo, int cityId) async {
    try {
      isLoading = true;
      notifyListeners();

      final city = await repo.fetchCityById(cityId);

      selectedRegion = city;
    } catch (e) {
      debugPrint("Error loading city: $e");
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
      cities = await repo.fetchCitiesByCountry(countryId);
      if (cities.isNotEmpty) selectedRegion ??= cities.first;
    } catch (e) {
      debugPrint("Error loading cities: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Change country
  Future<void> updateSelectedCountry(
    GetCountry? country,
    AddressRepository repo,
  ) async {
    selectedCountry = country;
    selectedRegion = null;
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

  void setUseExisting(bool value) {
    useExisting = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
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
