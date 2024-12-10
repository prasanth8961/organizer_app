import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:organizer_app/Helper/api_service.dart';
import 'package:organizer_app/Model/event_data_model.dart';
import 'package:organizer_app/Screens/ListEvent/HelperWidget/event_details.dart';
import 'package:organizer_app/Utils/format_data.dart';
import 'package:organizer_app/Utils/not_found.dart';

class TabView extends StatefulWidget {
  final List<EventDataModel> event;
  const TabView({super.key, required this.event});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return widget.event.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: SingleChildScrollView(
              child: LayoutGrid(
                columnSizes: width > 600 ? [1.fr, 1.fr, 1.fr] : [1.fr, 1.fr],
                rowSizes: List.generate(widget.event.length, (_) => auto), //4
                columnGap: 12,
                rowGap: 8,
                children: List.generate(widget.event.length, (index) {
                  final eventData = widget.event[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                "${imageBaseUrl}ev_main_img/${eventData.mainEvent.mainImg.first}", // "https://tse2.mm.bing.net/th?id=OIP.cTL2SWZTmIRSnIU13VT-4AHaEa&pid=Api&P=0&h=180"
                              ),
                              // AssetImage("assets/event1.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventData.mainEvent.name.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                                    formatTimeStamp(eventData.mainEvent.regStart
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      eventData.mainEvent.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    height: 30,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 4, 40, 147),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EventDetailsScreen(
                                                      eventData: eventData)),
                                        );
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
                      ],
                    ),
                  );
                }),
              ),
            ),
          )
        : const NotFound();
  }
}
