import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ketodiet/screens/subscription/footer.dart';
import 'package:ketodiet/screens/subscription/memberships.dart';
import 'package:ketodiet/screens/subscription/testimonials.dart';
import 'package:ketodiet/widgets/video_player.dart';

class SubscriptionScreen extends StatefulWidget {
  Map<String, dynamic>? pageResponse;

  SubscriptionScreen({this.pageResponse, Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<String> appFeatures = [
    'Calorie Tracker',
    'Barcode Scanner',
    'Special Recipes',
    'Premium Tips',
    'Daily Food Recommendation',
    'Ask Questions Directly To Dr. Stephen Gullo'
  ];

  late Map<String, dynamic> membership;

  @override
  void initState() {
    super.initState();
    membership = widget.pageResponse?['subscription']?[0]['prices'][0];
  }

  bool isImageUrl(String url) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final extension = url.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  bool isVideoUrl(String url) {
    final videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'];
    final extension = url.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    print(
        'pageResponse>>>>>>>${widget.pageResponse?['subscription']?[0]['prices']}');

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Text(widget.pageResponse?['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abrilFatface(
                            textStyle: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ))),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(widget.pageResponse?['slogan1'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ))),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Stack(children: [
                      AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: isImageUrl(widget
                                          .pageResponse?['frontPage_pic'][0]) ==
                                      true
                                  ? Image.network(
                                      widget.pageResponse?['frontPage_pic'][0],
                                      fit: BoxFit.cover)
                                  : isVideoUrl(widget.pageResponse?['frontPage_pic']
                                              [0]) ==
                                          true
                                      ? VideoDisplay(
                                          videoUrl: widget.pageResponse?['frontPage_pic'][0])
                                      : Image.network(
                                          'http://diet.backend.marketmajesty.net/upload/recipe.jpg',
                                          fit: BoxFit.cover))),
                      Positioned(
                          right: 45.0,
                          bottom: 0.0,
                          child: Text(widget.pageResponse?['slogan2'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0)))
                    ]),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 40.0, right: 20.0, top: 8.0, bottom: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFD5D9E5),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Column(
                          children: [
                            Text(widget.pageResponse?['appFeatureTitle'] ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.abrilFatface(
                                    textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF424141),
                                ))),
                            const SizedBox(
                              height: 16.0,
                            ),
                            for (var i = 0;
                                i <
                                    (widget.pageResponse?['features'] ?? [])
                                        .length;
                                i++)
                              Row(
                                children: [
                                  const Icon(
                                      size: 10.0,
                                      Icons.check_circle,
                                      color: Colors.blue),
                                  const SizedBox(width: 4.0),
                                  Expanded(
                                      child: Text(
                                    widget.pageResponse?['features'][i],
                                    style: const TextStyle(
                                        color: Color(0xFF424141),
                                        fontSize: 14.0),
                                  )),
                                ],
                              ),
                          ],
                        )),
                    const SizedBox(
                      height: 16.0,
                    ),
                    (widget.pageResponse?['testimonial'] ?? []).length != 0
                        ? Testimonials(
                            testimonials:
                                (widget.pageResponse?['testimonial'] ?? []))
                        : const SizedBox(
                            height: 10.0,
                          ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Memberships(
                      paragraph: widget.pageResponse?['paragraph'],
                      paragraphTitle: widget.pageResponse?['paragraphTitle'],
                      isFooter: false,
                      memberships: List<Map<String, dynamic>>.from(widget
                          .pageResponse?['subscription'][0]?['prices']
                          .map((item) => item as Map<String, dynamic>)),
                      onChangePlan: (ms) => setState(() {
                        membership = ms;
                      }),
                    )
                  ],
                )),
          ))),
          SubscriptionFooter(
            membership: membership,
            mainState: widget.pageResponse,
          )
        ],
      ),
    ));
  }
}
