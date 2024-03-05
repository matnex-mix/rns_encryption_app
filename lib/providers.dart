import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/user.dart';

final providerContainer = ProviderContainer();

final loggedInUserProvider = StateProvider<User?>((ref) => null);

final realOtpProvider = StateProvider<int?>((ref) => null);

final selectedModulosProvider = StateProvider<List<int>>((ref) => []);

final generateDurationProvider = StateProvider<String?>((ref) => null);
final validateDurationProvider = StateProvider<String?>((ref) => null);
