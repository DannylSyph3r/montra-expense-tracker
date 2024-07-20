import 'package:bloc/bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState(pageIndex: 0)) {
    on<SwitchPageIndex>(_onSwitchPageIndex);
  }

  void _onSwitchPageIndex(
      SwitchPageIndex event, Emitter<OnboardingState> emit) {
    emit(OnboardingState(pageIndex: event.index));
  }
}