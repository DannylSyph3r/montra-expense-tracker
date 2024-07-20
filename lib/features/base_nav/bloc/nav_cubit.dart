import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit State
class BaseNavState {
  final int currentIndex;
  final bool isKeyboardVisible;

  BaseNavState({
    required this.currentIndex,
    this.isKeyboardVisible = false, 
  });

  BaseNavState copyWith({
    int? currentIndex,
    bool? isKeyboardVisible,
  }) {
    return BaseNavState(
      currentIndex: currentIndex ?? this.currentIndex,
      isKeyboardVisible: isKeyboardVisible ?? this.isKeyboardVisible,
    );
  }
}

// Cubit
class BaseNavCubit extends Cubit<BaseNavState> {
  BaseNavCubit() : super(BaseNavState(currentIndex: 0, isKeyboardVisible: false));

  void moveToPage(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void updateKeyboardVisibility(bool isVisible) {
    emit(state.copyWith(isKeyboardVisible: isVisible));
  }
}
