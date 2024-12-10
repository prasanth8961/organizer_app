import 'package:flutter/material.dart';
import 'package:organizer_app/Helper/api_service.dart';
import 'package:organizer_app/Model/event_data_model.dart';
import 'package:organizer_app/Provider/event_provider.dart';
import 'package:organizer_app/Screens/ListEvent/HelperWidget/event_details.dart';
import 'package:organizer_app/Utils/const_color.dart';
import 'package:organizer_app/CommonWidgets/text_style.dart';
import 'package:organizer_app/Utils/format_data.dart';
import 'package:organizer_app/Utils/not_found.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<EventDataModel> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    Provider.of<EventProvider>(context, listen: false).getAllEvents();
    _filteredEvents = context.read<EventProvider>().allEvents;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    String query = _searchController.text;
    List<EventDataModel> result = [];

    if (query.isEmpty) {
      result = context.read<EventProvider>().allEvents;
    } else {
      result = context
          .read<EventProvider>()
          .allEvents
          .where((event) =>
              event.mainEvent.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredEvents = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
            child: Text(
          'Search Events',
          style: textStyle(25, Colors.white, FontWeight.w600),
        )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterItems(),
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<EventProvider>(
              builder: (context, searchEventProvider, child) {
                if (_filteredEvents.isEmpty) {
                  return const NotFound();
                }
                return ListView.builder(
                  itemCount: _filteredEvents.length,
                  itemBuilder: (context, index) {
                    final eventData = _filteredEvents[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "${imageBaseUrl}ev_main_img/${eventData.mainEvent.mainImg.first}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eventData.mainEvent.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range,
                                        color: Colors.purple,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatTimeStamp(eventData
                                            .mainEvent.regStart
                                            .toString()),
                                        style: const TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        eventData.mainEvent.location,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 4, 40, 147),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EventDetailsScreen(
                                                          eventData: eventData,
                                                        )));
                                          },
                                          child: const Center(
                                            child: Text(
                                              'View',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
