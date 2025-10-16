import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import '../model/address_model.dart';
import '../repository/address_repository.dart';
import '../service/api_service.dart';
import 'address_change_notifire.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// ApiService provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiService(client);
});
// Repository
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(ref.watch(apiServiceProvider));
});

// Address change notifier provider 
final addressChangeNotifierProvider =
    ChangeNotifierProvider<AddressChangeNotifier>((ref) {
  return AddressChangeNotifier();
});

