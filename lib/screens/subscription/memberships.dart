import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Memberships extends StatefulWidget {
  String? paragraphTitle;
  String? paragraph;
  void Function(Map<String, dynamic>)? onChangePlan;
  List<Map<String, dynamic>>? memberships;
  bool? isFooter;
  Memberships(
      {this.paragraph,
      this.paragraphTitle,
      this.onChangePlan,
      this.memberships,
      this.isFooter,
      Key? key})
      : super(key: key);

  @override
  State<Memberships> createState() => MembershipsState();
}

class MembershipsState extends State<Memberships> {
  int membershipIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void handleMembershipTap(index) {
    setState(() {
      membershipIndex = index;
    });
    widget.onChangePlan!(widget.memberships![index]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isFooter == true
        ? Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              'Start Your Weight-Loss Journey Today',
              style: TextStyle(color: Color(0xFFFD3A84), fontSize: 14),
            ),
            SizedBox(
                width: double.infinity,
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.memberships!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => handleMembershipTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: membershipIndex == index
                                  ? const Color(0xFF002EAB)
                                  : const Color(0xFFD5D9E5)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          width: 160.0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${widget.memberships![index]['duration']} Premium',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: membershipIndex == index
                                              ? Colors.white
                                              : const Color(0xFF424141))),
                                  const Expanded(
                                      child: SizedBox(
                                    width: double.infinity,
                                  )),
                                  Text(
                                      '\$${widget.memberships![index]['price']}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.abrilFatface(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: membershipIndex == index
                                                  ? Colors.white
                                                  : const Color(0xFF424141)))),
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 12.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                )),
          ])
        : Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              'Start Your Weight-Loss Journey Today',
              style: TextStyle(color: Color(0xFFFD3A84), fontSize: 14),
            ),
            SizedBox(
                width: double.infinity,
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.memberships!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => handleMembershipTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: membershipIndex == index
                                  ? const Color(0xFF002EAB)
                                  : const Color(0xFFD5D9E5)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          width: 160.0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${widget.memberships![index]['duration']} Premium',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: membershipIndex == index
                                              ? Colors.white
                                              : const Color(0xFF424141))),
                                  const Expanded(
                                      child: SizedBox(
                                    width: double.infinity,
                                  )),
                                  Text(
                                      '\$${widget.memberships![index]['price']}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.abrilFatface(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: membershipIndex == index
                                                  ? Colors.white
                                                  : const Color(0xFF424141)))),
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 12.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                )),
            const SizedBox(
              width: double.infinity,
              height: 16.0,
            ),
            SizedBox(
                width: double.infinity,
                child: Text(widget.paragraphTitle ?? '',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.abrilFatface(
                        textStyle: const TextStyle(
                            fontSize: 16, color: Colors.black)))),
            const SizedBox(
              width: double.infinity,
              height: 12.0,
            ),
            Text(widget.paragraph ?? '',
                style: GoogleFonts.dmSans(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.black))),
            const SizedBox(
              width: double.infinity,
              height: 40.0,
            ),
          ]);
  }
}
