import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shipping/model/address_model.dart';
import 'package:shipping/model/address_model_by_default_mbr.dart';
import 'package:shipping/model/all_countries_model.dart';
import 'package:shipping/model/cities_model.dart';

const String kBaseUrl = 'https://iconiccollectors.r-y-x.net';


class ApiService {
  
  final http.Client client;
  ApiService(this.client);


  Uri _uri(String path, [Map<String, dynamic>? query]) {
    if (query == null) return Uri.parse('$kBaseUrl$path');
    return Uri.parse('$kBaseUrl$path').replace(queryParameters: query.map((k, v) => MapEntry(k, v.toString())));
  }

  // GET Addresses by member
  Future<List<AddressModel>> getAddressesByMember(int memberId) async {
    final res = await client.get(_uri('/api/membershipAddress/GetByMember/$memberId'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load addresses: ${res.statusCode}');
  }

  // GET Default Address by member
  Future<AddressModelByMemberDefault?> getDefaultAddressByMember(int memberId) async {
    final res = await client.get(_uri('/api/membershipAddress/GetByMemberDefault/$memberId'));
    if (res.statusCode == 204) return null;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      if (data == null) return null;
      return AddressModelByMemberDefault.fromJson(data);
    }
    throw Exception('Failed to load default address: ${res.statusCode}');
  }

  // POST Add Address
  Future<AddressModel> addAddress(AddressModel model) async {
    final res = await client.post(_uri('/api/membershipAddress/Add'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(model.toJson()));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return AddressModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to add address: ${res.statusCode}');
  }

  // PUT Edit Address
  Future<AddressModel> editAddress(int id, AddressModel model) async {
    final res = await client.put(_uri('/api/membershipAddress/Edit/$id'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(model.toJson()));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return AddressModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to edit address: ${res.statusCode}');
  }

  // DELETE Address
  Future<void> deleteAddress(int id, int memberId) async {
    final res = await client.delete(_uri('/api/membershipAddress/delete/$id/$memberId'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    }
    throw Exception('Failed to delete address: ${res.statusCode}');
  }

  // Countries
  Future<List<GetCountry>> getAllCountries() async {
    final res = await client.get(_uri('/api/countries/all'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => GetCountry.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load countries: ${res.statusCode}');
  }

  // Cities (all)
  Future<List<CityModel>> getAllCities() async {
    final res = await client.get(_uri('/api/cities/GetAll'));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => CityModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load cities: ${res.statusCode}');
  }

  // Cities by country (assuming query param countryId)
  Future<List<CityModel>> getCitiesByCountry(int countryId) async {
    final res = await client.get(_uri('/api/cities/GetAllByCountry', {'countryId': countryId}));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => CityModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load cities by country: ${res.statusCode}');
  }
}
