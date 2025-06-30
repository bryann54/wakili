import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullImageViewArgs {
  final List<HotelImage> hotelImages;
  final int initialIndex;

  FullImageViewArgs({required this.hotelImages, required this.initialIndex});
}

@RoutePage()
class FullImageScreen extends StatefulWidget {
  final FullImageViewArgs args;

  const FullImageScreen({super.key, required this.args});

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.args.initialIndex);
    currentIndex = widget.args.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.args.hotelImages.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.args.hotelImages[index].originalImage,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorListener: (value) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog.adaptive(
                            title: Text(
                              AppLocalizations.getString(context, 'error'),
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                            content: Text(value.toString()),
                          );
                        },
                      );
                    },
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "${currentIndex + 1} / ${widget.args.hotelImages.length}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
