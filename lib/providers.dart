import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/user.dart';

final providerContainer = ProviderContainer();

final loggedInUserProvider = StateProvider<User?>((ref) => null);
