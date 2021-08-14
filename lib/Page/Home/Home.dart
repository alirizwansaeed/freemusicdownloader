import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Models/Search/TopSearchModel.dart';
import 'package:freemusicdownloader/Page/Home/GridView.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:freemusicdownloader/Page/Setting/Setting.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../Shared/ColorList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final ApiController _apiController = Get.find<ApiController>();
  Random _random = Random();
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
    super.initState();

    _apiController.fetchHomePage();
    _pageViewController = PageController(initialPage: 0);
    _tabBarController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController!.dispose();
    _tabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    final Color _randomColor =
        ColorList.primaries[_random.nextInt(ColorList.primaries.length)];
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
          _appBar(safeAreaHeight, _random, _randomColor),
          _tabbar(safeAreaHeight),
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

  SizedBox _appBar(double safeAreaHeight, Random random, Color _randomColor) {
    return SizedBox(
      height: safeAreaHeight + 160,
      width: double.infinity,
      child: ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: AppbarClipper(),
        child: Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorList
                    .lightcolors[random.nextInt(ColorList.lightcolors.length)]
                    .withOpacity(.9),
                ColorList
                    .lightcolors[random.nextInt(ColorList.lightcolors.length)]
                    .withOpacity(.9),
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
                  cacheColorFilter: true,
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
                top: safeAreaHeight,
                left: 20,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Floovi Music',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF333b66),
                          fontSize: 30),
                    ),
                    Row(
                      children: [
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () async {
                            _apiController.topSearch(TopSearchModel());
                            await Future.delayed(Duration(milliseconds: 100),
                                () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: SearchBar(),
                                ),
                              );
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10),
                            height: 55,
                            width: 40,
                            child: SvgPicture.asset(
                              'assets/search_icon.svg',
                              color: Color(0xFF333b66),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Setting(
                                  randomColor: _randomColor,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 35,
                            width: 50,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: _randomColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/menu_icon.svg',
                              color: Colors.white,
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
    path_0.lineTo(0, size.height);
    path_0.quadraticBezierTo(size.width * 0.0193750, size.height * 0.8500000,
        size.width * 0.1212500, size.height * 0.8350000);
    path_0.quadraticBezierTo(size.width * 0.1962500, size.height * 0.8268750,
        size.width, size.height * 0.7475000);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(0, 0);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
