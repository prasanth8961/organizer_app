import 'package:flutter/material.dart';
import 'package:organizer_app/Provider/event_provider.dart';
import 'package:organizer_app/Provider/user_data_provider.dart';
import 'package:organizer_app/Utils/const_color.dart';
import 'package:organizer_app/CommonWidgets/text_style.dart';
import 'package:organizer_app/Utils/format_data.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EventProvider>(context, listen: false).getAllEvents();
      Provider.of<UserDataProvider>(context, listen: false).fetchUserData();
      Provider.of<EventProvider>(context, listen: false).getDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EventProvider>(context, listen: false).getDashboardData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: textStyle(22, Colors.white, FontWeight.w600),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${context.read<UserDataProvider>().userData.isEmpty ? 'Organizer!' : context.read<UserDataProvider>().userData.first.fullName}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Consumer<EventProvider>(
              builder: (context, eventDataProvider, child) {
                Map<String, dynamic> dashboardData =
                    eventDataProvider.dashboardData;
                if (eventDataProvider.dashboardData.isEmpty) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard("Pending Events", "0",
                              const Color.fromARGB(255, 136, 127, 114)),
                          _buildSummaryCard("Completed Events", "0",
                              const Color.fromARGB(255, 124, 155, 125)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard("Booked Count", "0",
                              const Color.fromARGB(255, 147, 121, 152)),
                          _buildSummaryCard("Active Events", "0",
                              const Color.fromARGB(255, 111, 121, 139)),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard(
                              "Pending Events",
                              "${dashboardData["pendingEventsCount"]}",
                              const Color.fromARGB(255, 139, 129, 116)),
                          _buildSummaryCard(
                              "Completed Events",
                              "${dashboardData["completedEventsCount"]}",
                              const Color.fromARGB(255, 123, 152, 124)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryCard(
                              "Booked Count",
                              "${dashboardData["bookedCount"]}",
                              const Color.fromARGB(255, 93, 72, 97)),
                          _buildSummaryCard(
                              "Active Events",
                              "${dashboardData["activeEventsCount"]}",
                              const Color.fromARGB(255, 91, 101, 119)),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Events Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Consumer<EventProvider>(
              builder: (context, eventDataProvider, child) {
                final allEvents = eventDataProvider.allEvents;
                if (allEvents.isNotEmpty) {
                  return Column(
                    children: List.generate(allEvents.length, (index) {
                      final eventData = allEvents[index];
                      return _buildEventOverview(
                        eventName: eventData.mainEvent.name,
                        date: formatTimeStamp(
                            eventData.mainEvent.regStart.toString()),
                        status: eventData.mainEvent.status,
                        location: eventData.mainEvent.location,
                      );
                    }),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventOverview({
    required String eventName,
    required String date,
    required String status,
    required String location,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          eventName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Date: $date"),
            Text("Location: $location"),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "active":
        return Colors.blueAccent;
      case "completed":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
