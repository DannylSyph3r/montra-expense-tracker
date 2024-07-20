import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int pageIndex;

  const OnboardingState({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}
