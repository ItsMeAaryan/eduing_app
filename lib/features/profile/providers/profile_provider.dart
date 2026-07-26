import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  final String name;
  final String email;
  final String phone;
  final int completion;

  const ProfileState({
    this.name = 'Aaryan Sharma',
    this.email = 'aaryan@example.com',
    this.phone = '+91 98765 43210',
    this.completion = 72,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    int? completion,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      completion: completion ?? this.completion,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});
