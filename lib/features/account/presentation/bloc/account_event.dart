// lib/features/account/presentation/bloc/account_event.dart

part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserProfile extends AccountEvent {
  final String firstName;
  final String lastName;
  final File? profileImage;

  const UpdateUserProfile({
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  @override
  List<Object?> get props => [firstName, lastName, profileImage];
}
