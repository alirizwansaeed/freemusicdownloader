import 'package:delayed_display/delayed_display.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatelessWidget {
  Setting({Key? key}) : super(key: key);
  final ExpandableController _controllerStreaming =
      ExpandableController(initialExpanded: false);
  final ExpandableController _controllerfeedback =
      ExpandableController(initialExpanded: false);
  final ExpandableController _controllerAboutUs =
      ExpandableController(initialExpanded: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SafeArea(
                  child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: 60,
                padding: EdgeInsets.only(top: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.keyboard_backspace,
                  color: Colors.white,
                  size: 40,
                ),
              )),
            ),
            SizedBox(
              height: 30,
            ),
            _streamingQuality(),
            _feedback(),
            _aboutUs()
          ],
        ),
      ),
    );
  }

  ExpandableNotifier _aboutUs() {
    return ExpandableNotifier(
      controller: _controllerAboutUs,
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _controllerAboutUs.toggle();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white,
                height: 50,
                width: double.infinity,
                child: Text(
                  'About Us',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333b66),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expandable(
              collapsed: SizedBox.shrink(),
              expanded: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text('Developed By',
                              style: GoogleFonts.nunito())),
                      Row(children: [
                        Text(
                          'Rai Ali Rizwan',
                        )
                      ]),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  ExpandableNotifier _feedback() {
    return ExpandableNotifier(
      controller: _controllerfeedback,
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _controllerfeedback.toggle();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white,
                height: 50,
                width: double.infinity,
                child: Text(
                  'FeedBack',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333b66),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expandable(
              collapsed: SizedBox.shrink(),
              expanded: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 150,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF333b66).withOpacity(.5)),
                  autofocus: true,
                  cursorColor: Colors.black,
                  cursorWidth: 2,
                  cursorHeight: 25,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.quicksand(
                      color: Color(0xFF333b66).withOpacity(.5),
                      fontSize: 14,
                    ),
                    hintText: 'Type Feedback,',
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ExpandableNotifier _streamingQuality() {
    return ExpandableNotifier(
      controller: _controllerStreaming,
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _controllerStreaming.toggle();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Streaming Quailty',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF333b66),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '96kbps',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expandable(
              collapsed: SizedBox.shrink(),
              expanded: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Super Duper High',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333b66),
                              fontSize: 14),
                        ),
                        Text(
                          '320kbps',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Really High',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333b66),
                              fontSize: 14),
                        ),
                        Text(
                          '160kbps',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pretty High',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333b66),
                              fontSize: 14),
                        ),
                        Text(
                          '96kbps',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
