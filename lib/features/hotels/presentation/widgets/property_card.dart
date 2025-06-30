import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:wakili/features/hotels/presentation/widgets/image_slider_corousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertyCard extends StatefulWidget {
  final PropertyModel hotel;

  const PropertyCard({super.key, required this.hotel});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool isFav = false;
  late FavouritesBloc favBloc;

  @override
  void initState() {
    super.initState();
    favBloc = context.read<FavouritesBloc>();
    favBloc.add(CheckIfFavEvent(hotel: widget.hotel));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavouritesBloc, FavouritesState>(
      listener: (context, state) {
        if (state is CheckIfFavSuccess) {
          if (state.hotel.serpapiPropertyDetailsLink ==
              widget.hotel.serpapiPropertyDetailsLink) {
            setState(() {
              isFav = state.isFav;
            });
          }
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: ImageSliderCarousel(
                    hotelImages: widget.hotel.images,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.pin_drop,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.hotel.locationRating}',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotel.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.hotel.totalRate?.lowest ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          isDarkTheme() ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${widget.hotel.checkInTime ?? ''} - ${widget.hotel.checkOutTime ?? ''}',
                        style: TextStyle(
                            color: isDarkTheme()
                                ? Colors.grey[400]
                                : Colors.grey[700]),
                      ),
                      Spacer(),
                      BlocBuilder<FavouritesBloc, FavouritesState>(
                          builder: (context, state) {
                        if (state is LoadingFavourites &&
                            state.hotel?.serpapiPropertyDetailsLink ==
                                widget.hotel.serpapiPropertyDetailsLink) {
                          return CircularProgressIndicator.adaptive();
                        }
                        return IconButton(
                            onPressed: () {
                              isFav
                                  ? favBloc.add(
                                      DeleteFavouriteEvent(model: widget.hotel))
                                  : favBloc.add(
                                      AddFavouriteEvent(model: widget.hotel));
                            },
                            icon: Icon(isFav
                                ? Icons.favorite
                                : Icons.favorite_border));
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
