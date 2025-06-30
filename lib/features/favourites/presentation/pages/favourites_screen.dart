import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wakili/features/favourites/presentation/widgets/favourites_list.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final List<PropertyModel> favs = [];
  @override
  void initState() {
    super.initState();
    context.read<FavouritesBloc>().add(ListFavouritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getString(context, 'favourites')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocListener<FavouritesBloc, FavouritesState>(
          listener: (context, state) {
            if (state is AddFavouritesError) {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: Text(
                      AppLocalizations.getString(context, state.error),
                    ),
                  );
                },
              );
            } else if (state is LoadFavouritesSuccess ||
                state is AddFavouritesSuccess ||
                state is DeleteFavouritesSuccess) {
              setState(() {
                favs.clear();
                if (state is LoadFavouritesSuccess) {
                  favs.addAll(state.favs);
                } else if (state is AddFavouritesSuccess) {
                  favs.addAll(state.favs);
                } else if (state is DeleteFavouritesSuccess) {
                  favs.addAll(state.favs);
                }
              });
            }
          },
          child: FavouritesList(favourites: favs),
        ),
      ),
    );
  }
}
