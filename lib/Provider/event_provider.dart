import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:organizer_app/Helper/api_service.dart';
import 'package:organizer_app/Model/event_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  List<EventDataModel> _activeEvents = [];
  List<EventDataModel> _pendingEvents = [];
  List<EventDataModel> _rejectedEvents = [];
  List<EventDataModel> _filteredEvents = [];
  List<EventDataModel> _allEvents = [];
  Map<String, dynamic> _dashboardData = {};

  List<EventDataModel> get activeEvents => _activeEvents;
  List<EventDataModel> get pendingEvents => _pendingEvents;
  List<EventDataModel> get rejectedEvents => _rejectedEvents;
  List<EventDataModel> get filteredEvents => _filteredEvents;
  List<EventDataModel> get allEvents => _allEvents;
  Map<String, dynamic> get dashboardData => _dashboardData;

  Future<String> submitEvent(
    File mainImage,
    List<File> coverImages,
    List<List<File>> subEventListImages,
    Map<String, dynamic> mainEventData,
    List<Map<String, dynamic>> subEventsData,
  ) async {
    try {
      var uri = Uri.parse("$baseUrl${Config.createEvent}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("accessToken")!;
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'main-img',
          mainImage.path,
        ),
      );

      for (var coverImage in coverImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'cover-img',
            coverImage.path,
          ),
        );
      }

      for (int subEventIndex = 0;
          subEventIndex < subEventListImages.length;
          subEventIndex++) {
        var subEventImages = subEventListImages[subEventIndex];
        for (int i = 0; i < subEventImages.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'sub-event-img${subEventIndex + 1}',
              subEventImages[i].path,
            ),
          );
        }
      }

      final data = {
        'name': mainEventData['name'],
        'location': mainEventData['location'],
        'description': mainEventData['description'],
        'reg_start_date': mainEventData['regStartDate'],
        'reg_end_date': mainEventData['regEndDate'],
        'latitude': mainEventData['latitude'],
        'longitude': mainEventData['longitude'],
        'category': mainEventData['category'],
        'tags': mainEventData['tags'],
        'audience_type': mainEventData['audienceType'],
        'multi_tickets': mainEventData['multiTickets'],
        'currency': mainEventData['currency'],
        'sub_events': subEventsData.map((subEvent) {
          return {
            'name': subEvent['name'],
            'description': subEvent['description'],
            'video_url': subEvent['video_url'],
            'start_date': subEvent['start_date'],
            'start_time': subEvent['start_time'],
            'end_time': subEvent['end_time'],
            'host_name': subEvent['host_name'],
            'country_code': subEvent['country_code'],
            'host_mobile': subEvent['host_mobile'],
            'host_email': subEvent['host_email'],
            'ticket_type': subEvent['ticket_type'],
            'ticket_price': subEvent['ticket_price'],
            'ticket_qty': subEvent['ticket_qty'],
          };
        }).toList(),
      };

      request.fields['data'] = json.encode(data);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var parsedResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return parsedResponse['message'];
      } else {
        return "${parsedResponse['message']}";
      }
    } catch (e) {
      return 'internal server error';
    }
  }

  Future<void> getAllEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken")!;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl${Config.getAllEvents}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _allEvents = List<EventDataModel>.from(
            (responseData["data"]).map((x) => EventDataModel.fromJson(x)));
        notifyListeners();
      }
    } catch (e) {
      _allEvents = [];
    }
    notifyListeners();
  }

  Future<void> getActiveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken")!;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl${Config.getActiveEvents}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _activeEvents = List<EventDataModel>.from(
            (responseData["data"]).map((x) => EventDataModel.fromJson(x)));
        notifyListeners();
      }
    } catch (e) {
      _activeEvents = [];
    }
    notifyListeners();
  }

  Future<void> getPendingEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken")!;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl${Config.getPendingEvents}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _pendingEvents = List<EventDataModel>.from(
            (responseData["data"]).map((x) => EventDataModel.fromJson(x)));
        notifyListeners();
      }
    } catch (e) {
      _pendingEvents = [];
    }
    notifyListeners();
  }

  Future<void> getRejectedEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken")!;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl${Config.getRejectedEvents}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _rejectedEvents = List<EventDataModel>.from(
            (responseData["data"]).map((x) => EventDataModel.fromJson(x)));
        notifyListeners();
      }
    } catch (e) {
      _rejectedEvents = [];
    }
    notifyListeners();
  }

  Future<void> searchEvent(String query) async {
    if (query.isEmpty) {
      _filteredEvents = [];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken")!;
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}organizer/events?search=$query"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _filteredEvents = List<EventDataModel>.from(
          (responseData["data"] ?? []).map((x) => EventDataModel.fromJson(x)),
        );
      } else {
        _filteredEvents = [];
      }
    } catch (e) {
      _filteredEvents = [];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> getDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken")!;
    try {
      final response = await http.get(
        Uri.parse("$baseUrl${Config.getDashboardData}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData["message"]);
      if (response.statusCode == 200) {
        _dashboardData = responseData["data"];
        notifyListeners();
      }
    } catch (e) {
      _dashboardData = {};
    }
    notifyListeners();
  }
}
