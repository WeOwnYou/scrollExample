import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_example/models/pizza_data.dart';

part 'scrolling_menu_event.dart';
part 'scrolling_menu_state.dart';

// class ScrollingMenuBloc extends ChangeNotifier {
//   final menuScrollController = ScrollController();
//   final categoriesScrollController = ScrollController();
//   FoodTitle selectedTitle = FoodTitle.pizza;
//   bool categoryChangedByHand = false;
//   final productWidgetHeight = 57.56;
//
//   ScrollingMenuBloc() {
//     categoriesScrollController.addListener(() {
//       if (categoryChangedByHand) return;
//       if (menuScrollController.position.pixels >=
//           80 +
//               (pizzas.length + combo.length + snacks.length + deserts.length) *
//                   57.56) {
//         selectedTitle = FoodTitle.drinks;
//         notifyListeners();
//       } else if (menuScrollController.position.pixels >=
//           80 + (pizzas.length + combo.length + snacks.length) * 57.56) {
//         selectedTitle = FoodTitle.deserts;
//         notifyListeners();
//       } else if (menuScrollController.position.pixels >=
//           80 + (pizzas.length + combo.length) * 57.56) {
//         selectedTitle = FoodTitle.snacks;
//         notifyListeners();
//       } else if (menuScrollController.position.pixels >=
//           80 + pizzas.length * 57.56) {
//         selectedTitle = FoodTitle.combo;
//         notifyListeners();
//       } else {
//         selectedTitle = FoodTitle.pizza;
//         notifyListeners();
//       }
//     });
//   }
//
//   Future<void> onCategoryChanged(
//       FoodTitle newCategory, int productIndex,) async {
//     if (newCategory == selectedTitle) return;
//     categoryChangedByHand = true;
//     selectedTitle = newCategory;
//     notifyListeners();
//     if (newCategory == FoodTitle.pizza) {
//       await menuScrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 700),
//         curve: Curves.easeIn,
//       );
//     } else {
//       await menuScrollController.animateTo(
//         80 + productIndex * 57.56,
//         duration: const Duration(milliseconds: 700),
//         curve: Curves.easeIn,
//       );
//     }
//     categoryChangedByHand = false;
//     notifyListeners();
//   }
// }
//
//
class ScrollingMenuBloc extends Bloc<ScrollingMenuEvent, ScrollingMenuState> {
  final menuScrollController = ScrollController();
  final categoriesScrollController = ScrollController();
  bool categoryChangedByHand = false;
  final productWidgetHeight = 57.56;
  double _padding = 0.0;

  // ignore: avoid_setters_without_getters
  set categoriesTextPadding(double value) {
    _padding = value;
  }

  double get categoriesTextPadding => _padding;

  ScrollingMenuBloc(BuildContext context) :super(ScrollingMenuState.initial()) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _padding = MediaQuery.of(context).size.width * 0.065;
    // });
    on<CategoryChangedEvent>(_onCategoryChanged);
    menuScrollController.addListener(() {
      FoodTitle title;
      if (categoryChangedByHand) return;
      if (menuScrollController.position.pixels >=
          80 +
              (pizzas.length + combo.length + snacks.length + deserts.length) *
                  57.56) {
        title = FoodTitle.drinks;
      } else if (menuScrollController.position.pixels >=
          80 + (pizzas.length + combo.length + snacks.length) * 57.56) {
        title = FoodTitle.deserts;
      } else if (menuScrollController.position.pixels >=
          80 + (pizzas.length + combo.length) * 57.56) {
        title = FoodTitle.snacks;
      } else if (menuScrollController.position.pixels >=
          80 + pizzas.length * 57.56) {
        title = FoodTitle.combo;
      } else {
        title = FoodTitle.pizza;
      }
      emit(state.copyWith(foodTitle: title));
      animateCategory(title.index);
    });
  }

  Future<void> _onCategoryChanged(
    CategoryChangedEvent event,
    Emitter<ScrollingMenuState> emit,
  ) async {
    categoryChangedByHand = true;
    emit(state.copyWith(foodTitle: event.foodTitle));
    if (event.foodTitle == FoodTitle.pizza) {
      await menuScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      await menuScrollController.animateTo(
        80 + event.productIndex * 57.56,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
    categoryChangedByHand = false;
    return emit(
      state.copyWith(
        productIndex: event.productIndex,
        foodTitle: event.foodTitle,
      ),
    );
  }

  void animateCategory(int index) {
    const fontFactor = 7;
    var animateCategoriesTo = 0.0;

    for (var i = 0; i < index; i++) {
      animateCategoriesTo += FoodTitle.values[i].name.length * fontFactor +
          _padding * 2.125;
      if (i == 0) {
        animateCategoriesTo -= _padding * 2.125;
      }
    }

    categoriesScrollController.animateTo(
      animateCategoriesTo >= categoriesScrollController.position.maxScrollExtent
          ? categoriesScrollController.position.maxScrollExtent
          : animateCategoriesTo,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
