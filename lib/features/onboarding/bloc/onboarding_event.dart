import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class SwitchPageIndex extends OnboardingEvent {
  final int index;

  const SwitchPageIndex({required this.index});

  @override
  List<Object?> get props => [index];
}
