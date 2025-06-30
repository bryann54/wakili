import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:wakili/features/hotels/presentation/pages/full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSliderCarousel extends StatelessWidget {
  final List<HotelImage> hotelImages;
  final double width;
  final double height;
  final String? placeholder;
  final double? aspectRatio;
  final bool? clickable;

  const ImageSliderCarousel(
      {super.key,
      required this.hotelImages,
      required this.width,
      required this.height,
      this.placeholder,
      this.aspectRatio,
      this.clickable});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: aspectRatio ?? 2.0,
        enlargeCenterPage: true,
      ),
      items: hotelImages
          .map((item) => Center(
                child: InkWell(
                  onTap: (clickable ?? true)
                      ? () => context.router.push(FullImageRoute(
                            args: FullImageViewArgs(
                                hotelImages: hotelImages,
                                initialIndex: hotelImages.indexOf(item)),
                          ))
                      : null,
                  child: CachedNetworkImage(
                    imageUrl:
                        item.thumbnail ?? 'https://via.placeholder.com/400x200',
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) => SizedBox(
                      height: width,
                      width: height,
                      child: Text(error.toString()),
                    ),
                    fit: BoxFit.cover,
                    width: 1000, // Assuming a wider view
                  ),
                ),
              ))
          .toList(),
    );
  }
}
