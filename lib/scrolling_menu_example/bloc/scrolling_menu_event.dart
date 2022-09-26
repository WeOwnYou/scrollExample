part of 'scrolling_menu_bloc.dart';

abstract class ScrollingMenuEvent {
  const ScrollingMenuEvent();
}

class CategoryChangedEvent extends ScrollingMenuEvent{
  final FoodTitle foodTitle;
  final int productIndex;
  const CategoryChangedEvent(this.foodTitle, this.productIndex);
}
