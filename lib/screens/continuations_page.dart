import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:parchments_flutter/components/menu_drawer.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/components/parchments_app_bar.dart';
import 'package:parchments_flutter/components/parchment_sorting.dart';
import 'package:parchments_flutter/components/write_button.dart';
import 'package:parchments_flutter/constants/fonts.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/models/sorting/alphabetic_sort.dart';
import 'package:parchments_flutter/models/sorting/sort.dart';
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
  bool _activeSorting = false;
  final int _pageSize = 5;
  Sort _activeSort = AlphabeticSort();

  final _pagingController = PagingController<int, Parchment>(firstPageKey: 0);
  AnimationController _animationController;
  Animation _firstAnimation;
  Animation _secondAnimation;
  Animation _thirdAnimation;

  @override
  void initState() {
    super.initState();
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.ongoing || status == PagingStatus.completed) {
        setState(() {
          _activeSorting = true;
        });
      }
    });
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
      final newParchments = await HttpService.getContinuations(widget.parchment, _activeSort, pageKey);
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
    _pagingController.refresh();
  }

  Future<void> _changeSort(Sort sort) async {
    _activeSort = sort;
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ParchmentsAppBar(breadcrumbsActive: false,),
      drawer: MenuDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: RefreshIndicator(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _activeSorting
                    ? Container(
                      padding: EdgeInsets.only(top: 30, left: 30, right: 30,),
                      child: ParchmentSorting(callback: _changeSort)
                    )
                    : Container()
              ),
              PagedSliverList.separated(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Parchment>(
                    itemBuilder: (context, item, index) => Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: ParchmentCard(
                        parchment: item,
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 150),
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
              )
            ],
          ),
          onRefresh: _refresh,
        ),
      ),
    );
  }
}