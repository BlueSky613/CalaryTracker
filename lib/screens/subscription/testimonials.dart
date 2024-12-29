import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Testimonials extends StatefulWidget {
  List<dynamic>? testimonials;
  Testimonials({this.testimonials, Key? key}) : super(key: key);

  @override
  State<Testimonials> createState() => TestimonialsState();
}

class TestimonialsState extends State<Testimonials> {
  // final List<Map<String, dynamic>> testimonials = [
  //   {
  //     'avatar_url': 'https://placehold.jp/50x50.png',
  //     'content': 'Thank You Dr. Stephen Gullo - 1'
  //   },
  //   {
  //     'avatar_url': 'https://placehold.jp/50x50.png',
  //     'content': 'Thank You Dr. Stephen Gullo - 2'
  //   },
  //   {
  //     'avatar_url': 'https://placehold.jp/50x50.png',
  //     'content': 'Thank You Dr. Stephen Gullo - 3'
  //   },
  //   {
  //     'avatar_url': 'https://placehold.jp/50x50.png',
  //     'content': 'Thank You Dr. Stephen Gullo - 4'
  //   },
  // ];
  int avatarIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void handleAvatarTap(index) {
    setState(() {
      avatarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                const SizedBox(
                  height: 52.0,
                ),
                // for (var i = 0; i < (widget.testimonials ?? []).length; i++)
                //   Positioned(
                //     left: 40.0 * i,
                //     child: GestureDetector(
                //         onTap: () => handleAvatarTap(i),
                //         child: Container(
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             border: Border.all(
                //               color: Colors.black,
                //               width: 1.0,
                //             ),
                //           ),
                //           child: CircleAvatar(
                //             radius: 25.0,
                //             backgroundImage: NetworkImage(
                //                 widget.testimonials?[i]['avatar_url']),
                //           ),
                //         )),
                //   ),
                Container(
                  height: 70, // Adjust height based on your UI design
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.testimonials?.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: GestureDetector(
                          onTap: () => handleAvatarTap(i),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                  widget.testimonials?[i]['avatar_url'] ?? ''),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )),
        // Expanded(
        //     child: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //   child: Text(
        //     'Thousands Happy Testimonials',
        //     softWrap: true, // Allow text to wrap onto the next line
        //     style: GoogleFonts.abrilFatface(
        //         textStyle: const TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.normal,
        //       color: Color(0xFFFD3A84),
        //     )),
        //   ),
        // ))
        const SizedBox(
          width: double.infinity,
          height: 4.0,
        ),
        Stack(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 40.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF4400A4), Color(0xFF1A003E)],
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                          widget.testimonials?[avatarIndex]['avatar_url'] ?? ''),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.testimonials?[avatarIndex]['content'],
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ],
                )),
            // Positioned(
            //   top: 0,
            //   left: (17.5 + 40 * avatarIndex).toDouble(),
            //   child: CustomPaint(
            //     size: const Size(20, 18),
            //     painter: TrianglePainter(),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF4400A4)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
