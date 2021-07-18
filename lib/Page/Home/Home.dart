import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Page/Home/GridView.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Shared/GradientColorList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final ApiController _apiController = Get.find<ApiController>();
  PageController? _pageViewController;
  TabController? _tabBarController;

  List<String> _headerName = [
    'Trending Now',
    'New Albums',
    'Top Charts',
    'Top Playlists',
  ];

  @override
  void initState() {
    _apiController.fetchHomePage();
    _pageViewController = PageController(initialPage: 0);
    _tabBarController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController!.dispose();
    _tabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("mehod rebuild");
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    Random random = Random();
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => PageView(
                onPageChanged: (page) {
                  _tabBarController!.animateTo(page);
                },
                controller: _pageViewController,
                physics: BouncingScrollPhysics(),
                children: [
                  HomeGridView(
                    list: _apiController.homePageList.value.newTrending!,
                  ),
                  HomeGridView(
                    list: _apiController.homePageList.value.newAlbums!,
                  ),
                  HomeGridView(
                    list: _apiController.homePageList.value.charts!,
                  ),
                  HomeGridView(
                    list: _apiController.homePageList.value.topPlaylists!,
                  ),
                ],
              )),
          _appBar(safeAreaHeight, random),
          _tabbar(safeAreaHeight)
        ],
      ),
    );
  }

  Positioned _tabbar(double safeAreaHeight) {
    return Positioned(
      top: safeAreaHeight + 70,
      right: 0,
      left: 2,
      height: 30,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: true,
        controller: _tabBarController,
        unselectedLabelColor: Color(0xFF333b66),
        tabs: _headerName.map((e) => Text(e)).toList(),
        labelStyle: GoogleFonts.nunito(
          color: Color(0xFF333b66),
          fontWeight: FontWeight.w900,
        ),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF340F41),
              Color(0xFF10A1A7),
            ],
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: (selectedtab) {
          _pageViewController!.animateToPage(selectedtab,
              duration: Duration(milliseconds: 200), curve: Curves.linear);
        },
      ),
    );
  }

  SizedBox _appBar(double safeAreaHeight, Random random) {
    return SizedBox(
      height: safeAreaHeight + 220,
      width: double.infinity,
      child: ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: AppbarClipper(),
        child: Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorList.colorList[random.nextInt(ColorList.colorList.length)],
                ColorList.colorList[random.nextInt(ColorList.colorList.length)],
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: safeAreaHeight,
                child: SvgPicture.asset(
                  'assets/appbar_music.svg',
                  height: safeAreaHeight + 120,
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
              Positioned(
                right: 0,
                top: safeAreaHeight,
                child: SvgPicture.asset(
                  'assets/appbar_round_music.svg',
                  height: safeAreaHeight + 140,
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
              Positioned(
                top: safeAreaHeight + 10,
                left: 20,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Music Player',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF333b66),
                          fontSize: 30),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: NeumorphicButton(
                            style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle(),
                              color: Colors.transparent,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.only(
                              top: 6,
                            ),
                            child: SvgPicture.asset(
                              'assets/search_icon.svg',
                              color: Color(0xFF333b66),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: NeumorphicButton(
                            style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle(),
                              color: Colors.transparent,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.only(
                                top: 8, left: 2, right: 2, bottom: 2),
                            child: SvgPicture.asset(
                              'assets/menu_icon.svg',
                              color: Color(0xFF333b66),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppbarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.quadraticBezierTo(size.width * 0.0021875, size.height * 0.3780000, 0,
        size.height * 0.5020000);
    path_0.cubicTo(
        size.width * 0.0437500,
        size.height * 0.6635000,
        size.width * 0.2312500,
        size.height * 0.6845000,
        size.width * 0.5012500,
        size.height * 0.6500000);
    path_0.cubicTo(
        size.width * 0.9175000,
        size.height * 0.6040000,
        size.width * 0.9487500,
        size.height * 0.8120000,
        size.width,
        size.height);
    path_0.quadraticBezierTo(
        size.width * 0.9975000, size.height * 0.7490000, size.width, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
