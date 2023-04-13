import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ScrollUpdateList extends StatefulWidget {
  final Future<void> Function() onFetchMore;
  final Future<void> Function() onReFetch;
  final List<Widget> slivers;
  final ScrollController? scrollController;

  const ScrollUpdateList({
    Key? key,
    required this.onFetchMore,
    required this.onReFetch,
    required this.slivers,
    this.scrollController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ScrollUpdateListState();
  }
}

class ScrollUpdateListState extends State<ScrollUpdateList> {
  late final ScrollController scrollController;
  late final ScrollPhysics physics;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
    physics = GetPlatform.isAndroid
        ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
        : const AlwaysScrollableScrollPhysics();
  }

  @override
  void dispose() {
    scrollController.removeListener(updateScrollPosition);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollController.addListener(updateScrollPosition);
  }

  updateScrollPosition() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) widget.onFetchMore();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: physics,
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onReFetch,
        ),
        ...widget.slivers,
      ],
    );
  }
}
