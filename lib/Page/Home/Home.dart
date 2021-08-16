import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            _appBar(safeAreaHeight, _random, _randomColor),
            _tabbar(safeAreaHeight),
            Obx(() => Expanded(
                  child: PageView(
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
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _tabbar(double safeAreaHeight) {
    return Container(
      height: 30,
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 7),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        indicatorColor: Color(0xFFFC2201),
        labelColor: Color(0xFF333b66),
        isScrollable: true,
        controller: _tabBarController,
        unselectedLabelColor: Colors.grey,
        tabs: _headerName.map((e) => Text(e)).toList(),
        onTap: (selectedtab) {
          _pageViewController!.animateToPage(selectedtab,
              duration: Duration(milliseconds: 200), curve: Curves.linear);
        },
      ),
    );
  }

  Widget _appBar(double safeAreaHeight, Random random, Color _randomColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Floovi',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
                fontWeight: FontWeight.w900,
                color: Color(0xFF333b66),
                fontSize: 30),
          ),
        ),
        Row(
          children: [
            Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () async {
                _apiController.topSearch(TopSearchModel());
                await Future.delayed(Duration(milliseconds: 100), () {
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
                decoration: BoxDecoration(
                  color: Color(0xFF333b66),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.ellipsisH,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
