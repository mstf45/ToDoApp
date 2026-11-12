import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
final class RegisterState extends Equatable {
  const RegisterState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isSuccess = false,
  });

  final bool isLoading;
  final String errorMessage;
  final bool isSuccess;

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}
