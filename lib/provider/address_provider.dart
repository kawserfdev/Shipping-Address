import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:shipping/model/address_model.dart';
import 'package:shipping/repository/address_repository.dart';
import 'package:shipping/service/api_service.dart';
import 'package:shipping/provider/address_change_notifire.dart';

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

// Address change notifier provider (for the shipping address form)
final addressChangeNotifierProvider =
    ChangeNotifierProvider<AddressChangeNotifier>((ref) {
  return AddressChangeNotifier();
});

// Addresses list state notifier
class AddressesNotifier extends StateNotifier<AsyncValue<List<AddressModel>>> {
  final AddressRepository repo;
  AddressesNotifier(this.repo) : super(const AsyncValue.loading());

  Future<void> load(int memberId) async {
    try {
      state = const AsyncValue.loading();
      final list = await repo.fetchAddresses(memberId);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(int id, int memberId) async {
    try {
      await repo.removeAddress(id, memberId);
      // refresh
      await load(memberId);
    } catch (e) {
      // handle error (could update state with error)
    }
  }
}

final addressesProvider =
    StateNotifierProvider<AddressesNotifier, AsyncValue<List<AddressModel>>>((
      ref,
    ) {
      final repo = ref.watch(addressRepositoryProvider);
      return AddressesNotifier(repo);
    });
