part of 'scrolling_menu_bloc.dart';

class ScrollingMenuState {
  final FoodTitle selectedTitle;
  final int productIndex;
  ScrollingMenuState._({
    required this.selectedTitle,
    required this.productIndex,
  });
  ScrollingMenuState.initial()
      : this._(selectedTitle: FoodTitle.pizza, productIndex: 0);
  ScrollingMenuState.update({
    required FoodTitle foodTitle,
    required int productIndex,
  }) : this._(selectedTitle: foodTitle, productIndex: productIndex);

  ScrollingMenuState copyWith({FoodTitle? foodTitle, int? productIndex}) {
    return ScrollingMenuState._(
      selectedTitle: foodTitle ?? selectedTitle,
      productIndex: productIndex ?? this.productIndex,
    );
  }
}
