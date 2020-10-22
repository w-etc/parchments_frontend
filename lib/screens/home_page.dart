import 'package:flutter/material.dart';
import 'package:parchments_flutter/components/painters/diamond_painter.dart';
import 'package:parchments_flutter/components/parchment_card/parchment_card.dart';
import 'package:parchments_flutter/components/parchments_navigation_bar.dart';
import 'package:parchments_flutter/components/search_bar.dart';
import 'package:parchments_flutter/models/parchment.dart';
import 'package:parchments_flutter/services/http_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _pageSize = 5;
  final _pagingController = PagingController<int, Parchment>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newParchments = await HttpService.getCoreParchments(pageKey);
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
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ParchmentsNavigationBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            SearchBar(),
            Expanded(
              child: PagedListView.separated(
                padding: EdgeInsets.only(left: 30, right: 30,),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Parchment>(
                  itemBuilder: (context, item, index) => ParchmentCard(
                    parchment: item,
                  ),
                ),
                separatorBuilder: (context, index) => Container(
                    alignment: Alignment.center,
                    child: CustomPaint(
                      painter: DiamondPainter(length: 10),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}