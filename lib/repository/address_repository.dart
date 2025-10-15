import 'package:shipping/model/address_model.dart';
import 'package:shipping/model/address_by_default_model.dart';
import 'package:shipping/model/all_countries_model.dart';
import 'package:shipping/model/cities_model.dart';
import 'package:shipping/service/api_service.dart';

class AddressRepository {
  final ApiService api;
  AddressRepository(this.api);

  Future<List<AddressModel>> fetchAddresses(int memberId) => api.getAddressesByMember(memberId);
  Future<AddressModelByMemberDefault?> fetchDefaultAddress(int memberId) => api.getDefaultAddressByMember(memberId);
  Future<AddressModel> createAddress(AddressModel model) => api.addAddress(model);
  Future<AddressModel> updateAddress(int id, AddressModel model) => api.editAddress(id, model);
  Future<void> removeAddress(int id, int memberId) => api.deleteAddress(id, memberId);
  Future<List<GetCountry>> fetchCountries() => api.getAllCountries();
  Future<List<CityModel>> fetchAllCities() => api.getAllCities();
  Future<List<CityModel>> fetchCitiesByCountry(int countryId) => api.getCitiesByCountry(countryId);
  Future<CityModel> fetchCityById(int countryId) => api.getCityById(countryId);
}