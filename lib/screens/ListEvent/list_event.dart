import 'package:flutter/material.dart';
import 'package:organizer_app/Provider/event_provider.dart';
import 'package:organizer_app/Utils/const_color.dart';
import 'package:organizer_app/Utils/height_width.dart';
import 'package:organizer_app/Screens/ListEvent/HelperWidget/tab_view.dart';
import 'package:provider/provider.dart';
import '../../CommonWidgets/text_style.dart';

class ListEvent extends StatefulWidget {
  const ListEvent({super.key});

  @override
  State<ListEvent> createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchEvents();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchEvents() {
    Provider.of<EventProvider>(listen: false, context).getPendingEvents();
    Provider.of<EventProvider>(listen: false, context).getActiveEvents();
    Provider.of<EventProvider>(listen: false, context).getRejectedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(1.0, context),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * 0.045, bottom: 6),
            color: primaryColor,
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
              isScrollable: false,
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.grey.withOpacity(0.4),
              dividerColor: Colors.transparent,
              labelStyle: textStyle(16, Colors.black, FontWeight.bold),
              tabs: const [
                Tab(text: "Active"),
                Tab(text: "Pending"),
                Tab(text: "Rejected"),
              ],
            ),
          ),
          Expanded(
            child: Consumer<EventProvider>(
              builder: (context, eventDataProvider, child) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    TabView(event: eventDataProvider.activeEvents),
                    TabView(event: eventDataProvider.pendingEvents),
                    TabView(event: eventDataProvider.rejectedEvents),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
