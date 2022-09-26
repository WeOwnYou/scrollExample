import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_example/models/pizza_data.dart';
import 'package:scroll_example/scrolling_menu_example/bloc/scrolling_menu_bloc.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  PersistentHeaderDelegate({required this.child});
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      width: 100,
      child: Center(child: child),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 100;

  @override
  // TODO: implement minExtent
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allProducts = <String>[
      ...pizzas,
      ...combo,
      ...snacks,
      ...deserts,
      ...drinks
    ];
    final controllerProducts =
        context.read<ScrollingMenuBloc>().menuScrollController;
    final productWidgetHeight =
        context.read<ScrollingMenuBloc>().productWidgetHeight;
    return Scaffold(
      body: CustomScrollView(
        controller: controllerProducts,
        slivers: [
          const SliverAppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            pinned: true,
            actions: [
              Center(
                child: Text(
                  'Moscow',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Spacer(),
              Icon(
                Icons.search,
                color: Colors.black,
              ),
            ],
          ),
          const SliverAppBar(elevation: 0, flexibleSpace: Text('21')),
          SliverList(delegate: SliverChildBuilderDelegate((_,__){
            return const FlutterLogo();
          },childCount: 5),),
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeaderDelegate(
              child: FractionallySizedBox(
                heightFactor: 0.3,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: context
                      .read<ScrollingMenuBloc>()
                      .categoriesScrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return _BuildCategoryFoodWidget(
                      title: FoodTitle.values[index],
                    );
                  },
                  itemCount: FoodTitle.values.length,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: allProducts
                  .map(
                    (product) => Card(
                      margin: EdgeInsets.symmetric(
                        vertical: productWidgetHeight * 0.06,
                      ),
                      child: SizedBox(
                        height: productWidgetHeight * 0.88,
                        width: double.infinity,
                        child: Center(child: Text(product)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class _BuildCategoryFoodWidget extends StatelessWidget {
  final FoodTitle title;

  const _BuildCategoryFoodWidget({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTitle = context.select<ScrollingMenuBloc, FoodTitle>(
      (vm) =>
          // vm.selectedTitle,
          vm.state.selectedTitle,
    );
    final padding = context.read<ScrollingMenuBloc>().categoriesTextPadding =
        MediaQuery.of(context).size.width * 0.065;
    // final padding = context.read<ScrollingMenuBloc>().categoriesTextPadding;
    // final padding = MediaQuery.of(context).size.width * 0.065;
    return GestureDetector(
      onTap: () {
        int scrollTo;
        switch (title) {
          case FoodTitle.pizza:
            scrollTo = 0;
            break;
          case FoodTitle.combo:
            scrollTo = pizzas.length;
            break;
          case FoodTitle.snacks:
            scrollTo = pizzas.length + combo.length;
            break;
          case FoodTitle.deserts:
            scrollTo = pizzas.length + combo.length + snacks.length;
            break;
          case FoodTitle.drinks:
            scrollTo =
                pizzas.length + combo.length + snacks.length + deserts.length;
            break;
        }
        context
            .read<ScrollingMenuBloc>()
            // .onCategoryChanged(title, scrollTo);
            .add(CategoryChangedEvent(title, scrollTo));
        context.read<ScrollingMenuBloc>().animateCategory(title.index);
      },
      child: Padding(
        padding: EdgeInsets.only(left: padding / 8),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: selectedTitle == title ? Colors.orangeAccent : Colors.grey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Text(
              title.name.replaceFirst(
                title.name[0],
                title.name[0].toUpperCase(),
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
