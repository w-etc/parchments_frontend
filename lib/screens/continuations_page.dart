import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:parchments_flutter/components/menu_drawer.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/components/parchments_app_bar.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';

class ContinuationsPage extends StatefulWidget {
  final Parchment parchment;

  const ContinuationsPage({
    Key key,
    @required this.parchment,
  }): super(key: key);

  @override
  _ContinuationsPageState createState() => _ContinuationsPageState();
}

class _ContinuationsPageState extends State<ContinuationsPage> with TickerProviderStateMixin {
  final int _pageSize = 5;

  final _pagingController = PagingController<int, Parchment>(firstPageKey: 0);
  AnimationController _animationController;
  Animation _firstAnimation;
  Animation _secondAnimation;
  Animation _thirdAnimation;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _firstAnimation = Tween(
        begin: 0.0,
        end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.2, 0.6)));
    _secondAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.6, 1.0)));
    _thirdAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.6, 1.0)));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newParchments = await HttpService.getContinuations(widget.parchment, pageKey);
      final isLastPage = newParchments.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newParchments);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newParchments, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refresh() async {
    _fetchPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParchmentsAppBar(breadcrumbsActive: false,),
      drawer: MenuDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: RefreshIndicator(
          child: PagedListView.separated(
            padding: EdgeInsets.only(top: 50, left: 30, right: 30,),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Parchment>(
                itemBuilder: (context, item, index) => ParchmentCard(
                  parchment: item,
                ),
                noItemsFoundIndicatorBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FadeTransition(
                          opacity: _firstAnimation,
                          child: Container(
                            child: Text('Nothing follows...', style: TextStyle(fontSize: 28, fontFamily: CINZEL,),),
                          ),
                        ),
                        FadeTransition(
                          opacity: _secondAnimation,
                          child: Container(
                            padding: EdgeInsets.only(top: 50, bottom: 50,),
                            child: Text('Be the first', style: TextStyle(fontSize: 28, fontFamily: CINZEL,),),
                          ),
                        ),
                        FadeTransition(
                          opacity: _thirdAnimation,
                          child: Container(
                            child: WriteButton(parchment: widget.parchment, replaceRoute: true),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
            separatorBuilder: (context, index) => Container(
                alignment: Alignment.center,
                child: CustomPaint(
                  painter: DiamondPainter(length: 10),
                )
            ),
          ),
          onRefresh: _refresh,
        ),
      ),
    );
  }
}