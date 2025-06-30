import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:wakili/features/hotels/presentation/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesList extends StatelessWidget {
  final List<PropertyModel> favourites;
  const FavouritesList({super.key, required this.favourites});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<FavouritesBloc>().add(ListFavouritesEvent());
      },
      child: BlocBuilder<FavouritesBloc, FavouritesState>(
        builder: (context, state) {
          if (state is LoadFavouritesError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.getString(context, state.error),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                IconButton(
                  onPressed:
                      () => context.read<FavouritesBloc>().add(
                        ListFavouritesEvent(),
                      ),
                  icon: Icon(Icons.replay_outlined),
                ),
              ],
            );
          }
          if (favourites.isEmpty) {
            return Center(
              child: Text(AppLocalizations.getString(context, 'noData')),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: favourites.length,
            itemBuilder:
                (context, index) => PropertyCard(hotel: favourites[index]),
          );
        },
      ),
    );
  }
}
