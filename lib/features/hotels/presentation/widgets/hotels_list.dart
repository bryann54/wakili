import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/common/utils/date_utils.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:wakili/features/hotels/presentation/bloc/hotels_bloc.dart';
import 'package:wakili/features/hotels/presentation/widgets/hotels_shimmer.dart';
import 'package:wakili/features/hotels/presentation/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelsList extends StatelessWidget {
  final ScrollController controller;
  const HotelsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hotelsBloc = context.read<HotelsBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        hotelsBloc.add(ListHotelsEvent(
          params: GetHotelsParams(
              checkInDate: formatDateObj(getCurrentDateTime()),
              checkOutDate: formatDateObj(addDays(1, getCurrentDateTime()))),
        ));
      },
      child: BlocBuilder<HotelsBloc, HotelsState>(builder: (context, state) {
        if (state is HotelsLoadingState) {
          return HotelsShimmer();
        } else if (state is ListHotelsError) {
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
                  onPressed: () => hotelsBloc.add(ListHotelsEvent(
                        params: GetHotelsParams(
                            checkInDate: formatDateObj(getCurrentDateTime()),
                            checkOutDate: formatDateObj(
                                addDays(1, getCurrentDateTime()))),
                      )),
                  icon: Icon(Icons.replay_outlined))
            ],
          );
        } else if (state is ListHotelsSuccess || hotelsBloc.hotels.isNotEmpty) {
          late List<PropertyModel> hotels;
          if (state is ListHotelsSuccess) {
            hotels = state.hotels;
          } else {
            hotels = hotelsBloc.hotels;
          }
          if (hotels.isEmpty) {
            return Center(
                child: Text(AppLocalizations.getString(context, 'noData')));
          }
          return ListView.separated(
            controller: controller,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: hotels.length,
            padding: const EdgeInsets.only(top: 20),
            itemBuilder: (context, index) => PropertyCard(hotel: hotels[index]),
          );
        }
        return Center(
            child: Text(AppLocalizations.getString(context, 'noData')));
      }),
    );
  }
}
