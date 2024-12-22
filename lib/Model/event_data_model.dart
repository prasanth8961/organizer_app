import 'dart:convert';

EventDataModel eventDataModelFromJson(String str) =>
    EventDataModel.fromJson(json.decode(str));

String eventDataModelToJson(EventDataModel data) => json.encode(data.toJson());

class EventDataModel {
  final MainEvent mainEvent;
  final List<SubEvent> subEvents;

  EventDataModel({
    required this.mainEvent,
    required this.subEvents,
  });

  factory EventDataModel.fromJson(Map<String, dynamic> json) => EventDataModel(
        mainEvent: MainEvent.fromJson(json["main_event"]),
        subEvents: List<SubEvent>.from(
            json["sub_events"].map((x) => SubEvent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_event": mainEvent.toJson(),
        "sub_events": List<dynamic>.from(subEvents.map((x) => x.toJson())),
      };
}

class MainEvent {
  final int mainEventId;
  final String name;
  final String location;
  final String orgId;
  final String description;
  final DateTime regStart;
  final DateTime regEnd;
  final String category;
  final String tags;
  final String audienceType;
  final int multiTickets;
  final String currency;
  final List<String> mainImg;
  final List<String> coverImg;
  final String status;

  MainEvent({
    required this.mainEventId,
    required this.name,
    required this.location,
    required this.orgId,
    required this.description,
    required this.regStart,
    required this.regEnd,
    required this.category,
    required this.tags,
    required this.audienceType,
    required this.multiTickets,
    required this.currency,
    required this.mainImg,
    required this.coverImg,
    required this.status,
  });

  factory MainEvent.fromJson(Map<String, dynamic> json) => MainEvent(
      mainEventId: json["main_event_id"],
      name: json["name"],
      location: json["location"],
      orgId: json["org_id"],
      description: json["description"],
      regStart: DateTime.parse(json["reg_start"]),
      regEnd: DateTime.parse(json["reg_end"]),
      category: json["category"],
      tags: json["tags"],
      audienceType: json["audience_type"],
      multiTickets: json["multi_tickets"],
      currency: json["currency"],
      mainImg: List<String>.from(json["main_img"].map((x) => x)),
      coverImg: List<String>.from(json["cover_img"].map((x) => x)),
      status: "pending");

  Map<String, dynamic> toJson() => {
        "main_event_id": mainEventId,
        "name": name,
        "location": location,
        "org_id": orgId,
        "description": description,
        "reg_start": regStart.toIso8601String(),
        "reg_end": regEnd.toIso8601String(),
        "category": category,
        "tags": tags,
        "audience_type": audienceType,
        "multi_tickets": multiTickets,
        "currency": currency,
        "main_img": List<dynamic>.from(mainImg.map((x) => x)),
        "cover_img": List<dynamic>.from(coverImg.map((x) => x)),
      };
}

class SubEvent {
  final int subEventId;
  final int mainEventId;
  final String name;
  final String description;
  final List<String> images;
  final String videoUrl;
  final DateTime startDate;
  final String startTime;
  final String endTime;
  final String hostName;
  final String countryCode;
  final String hostMobile;
  final String hostEmail;
  final String ticketType;
  final int ticketPrice;
  final int ticketQty;
  final String status;

  SubEvent({
    required this.subEventId,
    required this.mainEventId,
    required this.name,
    required this.description,
    required this.images,
    required this.videoUrl,
    required this.startDate,
    required this.startTime,
    required this.endTime,
    required this.hostName,
    required this.countryCode,
    required this.hostMobile,
    required this.hostEmail,
    required this.ticketType,
    required this.ticketPrice,
    required this.ticketQty,
    required this.status,
  });

  factory SubEvent.fromJson(Map<String, dynamic> json) => SubEvent(
        subEventId: json["sub_event_id"],
        mainEventId: json["main_event_id"],
        name: json["name"],
        description: json["description"],
        images: List<String>.from(json["images"].map((x) => x)),
        videoUrl: json["video_url"],
        startDate: DateTime.parse(json["start_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        hostName: json["host_name"],
        countryCode: json["country_code"],
        hostMobile: json["host_mobile"],
        hostEmail: json["host_email"],
        ticketType: json["ticket_type"],
        ticketPrice: json["ticket_price"],
        ticketQty: json["ticket_qty"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "sub_event_id": subEventId,
        "main_event_id": mainEventId,
        "name": name,
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "video_url": videoUrl,
        "start_date": startDate.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
        "host_name": hostName,
        "country_code": countryCode,
        "host_mobile": hostMobile,
        "host_email": hostEmail,
        "ticket_type": ticketType,
        "ticket_price": ticketPrice,
        "ticket_qty": ticketQty,
        "status": status,
      };
}
