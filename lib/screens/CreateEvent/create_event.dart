import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizer_app/CommonWidgets/text_style.dart';
import 'package:organizer_app/Provider/event_provider.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:organizer_app/Screens/CreateEvent/HelperWidget/curved_text_field.dart';
import 'package:organizer_app/Screens/CreateEvent/HelperWidget/dropdown_menu.dart';
import 'package:organizer_app/Utils/const_color.dart';
import 'package:organizer_app/Utils/loader.dart';
import 'package:organizer_app/Utils/scaffold_messenger.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  final PageController pageController;

  const CreateEvent({super.key, required this.pageController});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController regStartDateController = TextEditingController();
  TextEditingController regEndDateController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController audienceTypeController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  bool multiTickets = false;

  List<Map<String, dynamic>> tags = [
    {'name': 'Music', 'isSelected': false},
    {'name': 'Art', 'isSelected': false},
    {'name': 'Technology', 'isSelected': false},
    {'name': 'Business', 'isSelected': false},
    {'name': 'Education', 'isSelected': false},
    {'name': 'Sports', 'isSelected': false},
    {'name': 'Health', 'isSelected': false},
    {'name': 'Networking', 'isSelected': false},
    {'name': 'Conference', 'isSelected': false},
    {'name': 'Workshop', 'isSelected': false},
    {'name': 'Seminar', 'isSelected': false},
    {'name': 'Startup', 'isSelected': false},
    {'name': 'Fashion', 'isSelected': false},
    {'name': 'Food', 'isSelected': false},
    {'name': 'Photography', 'isSelected': false},
    {'name': 'Film', 'isSelected': false},
    {'name': 'Literature', 'isSelected': false},
    {'name': 'Environment', 'isSelected': false}
  ];

  List<Map<String, TextEditingController>> subEventControllers = [];

  @override
  void initState() {
    super.initState();
    // _addSubEvent();
  }

  void _addSubEvent() {
    setState(() {
      subEventControllers.add({
        'name': TextEditingController(),
        'description': TextEditingController(),
        'video_url': TextEditingController(),
        'start_date': TextEditingController(),
        'start_time': TextEditingController(),
        'end_time': TextEditingController(),
        'host_name': TextEditingController(),
        'country_code': TextEditingController(),
        'host_mobile': TextEditingController(),
        'host_email': TextEditingController(),
        'ticket_type': TextEditingController(),
        'ticket_price': TextEditingController(),
        'ticket_qty': TextEditingController(),
      });
    });
  }

  Future<void> _selectDate(BuildContext context, int? index,
      {bool isStartDate = false, bool isEndDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          regStartDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else if (isEndDate) {
          regEndDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          subEventControllers[index!]['start_date']!.text =
              DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, int index, String timeType) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final formattedTime = picked.format(context);
        if (timeType == 'start_time') {
          subEventControllers[index]['start_time']!.text = formattedTime;
        } else if (timeType == 'end_time') {
          subEventControllers[index]['end_time']!.text = formattedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Center(
            child: Text(
          "Create Event",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
      body: Consumer<ImagePickerProvider>(
        builder: (context, imagePickerProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainEventDetails(imagePickerProvider),
                    const SizedBox(height: 16),
                    _buildSubEvents(imagePickerProvider),
                    ElevatedButton(
                      onPressed: () {
                        imagePickerProvider.setSubEventImageList();
                        _addSubEvent();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF46BCC3),
                        minimumSize: Size(
                            MediaQuery.sizeOf(context).width * 0.4,
                            MediaQuery.sizeOf(context).height * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Add Sub-event ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainEventDetails(ImagePickerProvider imagePickerProvider) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Main Event Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CurvedTextField(
              controller: nameController,
              hint: 'Event Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter event name';
                }
                return null;
              },
            ),
            CustomDropDownMenu(
                controller: locationController,
                onChanged: (value) {
                  locationController.text = value!;
                },
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please host name';
                  }
                  return null;
                },
                hint: "Distric",
                items: const [
                  'Chennai',
                  'Coimbatore',
                  'Cuddalore',
                  'Dharmapuri',
                  'Dindigul',
                  'Erode',
                  'Kanchipuram',
                  'Kanyakumari',
                  'Karur',
                  'Krishnagiri',
                  'Madurai',
                  'Nagapattinam',
                  'Namakkal',
                  'Nilgiris',
                  'Perambalur',
                  'Pudukkottai',
                  'Ramanathapuram',
                  'Salem',
                  'Sivagangai',
                  'Thanjavur',
                  'Theni',
                  'Thiruvallur',
                  'Thiruvarur',
                  'Tiruchirappalli',
                  'Tirunelveli',
                  'Tiruppur',
                  'Vellore',
                  'Villupuram',
                  'Virudhunagar',
                ]),
            CurvedTextField(
              controller: descriptionController,
              hint: 'Description',
              maxLines: 3,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            CustomDropDownMenu(
                controller: categoryController,
                onChanged: (value) {
                  setState(() {
                    categoryController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
                hint: 'Category',
                items: const [
                  'Symposium',
                  'Workshop',
                  'Conference',
                  'Seminar',
                  'Webinar',
                  'Hackathon',
                  'Meetup',
                  'Networking Event',
                  'Panel Discussion',
                  'Exhibition',
                  'Trade Show',
                  'Lecture',
                  'Round Table',
                  'Training Session',
                  'Bootcamp',
                  'Product Launch',
                  'Fundraiser',
                  'Award Ceremony',
                  'Cultural Event',
                  'Sports Event'
                ]),
            CustomDropDownMenu(
                controller: audienceTypeController,
                onChanged: (value) {
                  audienceTypeController.text = value!;
                },
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please enter audience type';
                  }
                  return null;
                },
                hint: 'Audience Type',
                items: const [
                  'General Public',
                  'Students',
                  'Professionals',
                  'Academics',
                  'Families',
                  'Corporates',
                  'Teens',
                  'Seniors',
                  'Artists',
                  'Entrepreneurs',
                  'Tech Enthusiasts',
                  'Health and Wellness',
                  'Music Lovers',
                  'Sports Fans',
                  'Book Readers',
                  'Travelers',
                  'Foodies',
                  'Gamers',
                  'Community Leaders',
                  'Non-profit Organizations',
                ]),
            CheckboxListTile(
              title: const Text('Allow Multi Tickets'),
              value: multiTickets,
              onChanged: (value) => setState(() => multiTickets = value!),
            ),
            CustomDropDownMenu(
                controller: currencyController,
                onChanged: (value) {
                  setState(() {
                    currencyController.text = value ?? '';
                  });
                },
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please select currency';
                  }
                  return null;
                },
                hint: 'Currency',
                items: const ['INR', 'USD', 'EUR', 'JPY', 'MXN']),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Select Tags",
                  style: textStyle(18, Colors.black, FontWeight.w500)),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: tags.map((tag) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tag['isSelected'] = !tag['isSelected'];
                    });
                  },
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        color: tag['isSelected']
                            ? Colors.blue
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: secondaryColor)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Center(
                      child: Text(
                        tag['name'],
                        style: TextStyle(
                          color:
                              tag['isSelected'] ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _buildRegistrationPeriod(),
            const SizedBox(height: 16),
            _buildEventLocation(),
            const SizedBox(height: 16),
            _buildImagePicker(imagePickerProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationPeriod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Registration Period',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CurvedTextField(
          controller: regStartDateController,
          hint: 'Start Date',
          readOnly: true,
          validator: (p0) {
            if (p0!.isEmpty) {
              return 'Please select date';
            }
            return null;
          },
          onTap: () => _selectDate(context, 0, isStartDate: true),
        ),
        CurvedTextField(
          controller: regEndDateController,
          hint: 'End Date',
          readOnly: true,
          onTap: () => _selectDate(context, 0, isEndDate: true),
        ),
      ],
    );
  }

  Widget _buildEventLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CurvedTextField(
            controller: latitudeController,
            hint: 'Latitude',
            keyboardType: TextInputType.number),
        CurvedTextField(
            controller: longitudeController,
            hint: 'Longitude',
            keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _buildImagePicker(ImagePickerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (provider.mainEventImage != null)
          Stack(children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey, width: 1),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(provider.mainEventImage!),
                  )),
            ),
            Positioned(
                right: 0,
                child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => provider.removeMainImage())),
          ])
        else
          GestureDetector(
            onTap: () => provider.pickMainEventImage(),
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueGrey, width: 1),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.black38, size: 50),
                    Text(
                      'Pick Main Image',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        //<----------- Display cover images if picked-------->
        const Text('Cover Images'),
        const SizedBox(height: 8),
        Wrap(spacing: 10.0, runSpacing: 10.0, children: [
          ...provider.mainEventCoverImages.map((image) {
            return Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueGrey, width: 1),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(image),
                      )),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => provider.removeCoverImage(
                      0,
                      provider.mainEventCoverImages.indexOf(image),
                    ),
                  ),
                ),
              ],
            );
          }),
          provider.mainEventCoverImages.length < 6
              ? GestureDetector(
                  onTap: () => provider.pickCoverImage(0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueGrey, width: 1),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.black38, size: 25),
                          Text(
                            'Pick Image',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ])
      ],
    );
  }

  Widget _buildSubEvents(ImagePickerProvider provider) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Sub-events',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...List.generate(subEventControllers.length, (index) {
        if (index >= 0 && index < subEventControllers.length) {
          return Stack(children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Plese enter event name';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['name']!,
                        hint: 'Sub-event Name'),
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['description']!,
                        hint: 'Sub-event Description',
                        maxLines: 3),
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter video url';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['video_url']!,
                        hint: 'Video URL'),
                    CurvedTextField(
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please enter start date';
                        }
                        return null;
                      },
                      controller: subEventControllers[index]['start_date']!,
                      hint: 'Start Date',
                      readOnly: true,
                      onTap: () => _selectDate(context, index),
                    ),
                    CurvedTextField(
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please select start time';
                        }
                        return null;
                      },
                      controller: subEventControllers[index]['start_time']!,
                      hint: 'Start Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, index, 'start_time'),
                    ),
                    CurvedTextField(
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please select end time';
                        }
                        return null;
                      },
                      controller: subEventControllers[index]['end_time']!,
                      hint: 'End Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, index, 'end_time'),
                    ),
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please host name';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['host_name']!,
                        hint: 'Host Name'),
                    CurvedTextField(
                        controller: subEventControllers[index]['country_code']!,
                        keyboardType: TextInputType.number,
                        hint: 'Country Code'),
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['host_mobile']!,
                        keyboardType: TextInputType.number,
                        hint: 'Host Mobile'),
                    TextFormField(
                      controller: subEventControllers[index]['host_email']!,
                      cursorColor: Colors.black,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Host Email',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.04,
                          fontFamily: "verdana_regular",
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomDropDownMenu(
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'Please select ticket type';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['ticket_type']!,
                        onChanged: (value) {
                          subEventControllers[index]['ticket_type']!.text =
                              value!;
                        },
                        hint: 'Ticket Type',
                        items: const [
                          'General Admission',
                          'VIP',
                          'Early Bird',
                          'Student',
                          'Senior Citizen',
                          'Group Discount',
                          'Standard',
                          'Premium',
                          'Reserved Seating',
                          'Press Pass',
                        ]),
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['ticket_price']!,
                        hint: 'Ticket Price',
                        keyboardType: TextInputType.number),
                    CurvedTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                        controller: subEventControllers[index]['ticket_qty']!,
                        keyboardType: TextInputType.number,
                        hint: 'Ticket Quantity'),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cover Images'),
                          const SizedBox(height: 8),
                          (provider.subEventCoverImages.isNotEmpty &&
                                  provider
                                      .subEventCoverImages[index].isNotEmpty)
                              ? Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: [
                                      ...provider.subEventCoverImages[index]
                                          .map((image) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Colors.blueGrey,
                                                      width: 1),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(image),
                                                  )),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: IconButton(
                                                  icon: const Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red),
                                                  onPressed: () =>
                                                      provider.removeCoverImage(
                                                        index,
                                                        provider
                                                            .subEventCoverImages[
                                                                index]
                                                            .indexOf(image),
                                                        deleteMainEventCoverImage:
                                                            false,
                                                      )),
                                            ),
                                          ],
                                        );
                                      }),
                                      provider.subEventCoverImages[index]
                                                  .length <
                                              6
                                          ? GestureDetector(
                                              onTap: () =>
                                                  provider.pickCoverImage(index,
                                                      isMainEventCoverImages:
                                                          false),
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Colors.blueGrey,
                                                      width: 1),
                                                ),
                                                child: const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add,
                                                          color: Colors.black38,
                                                          size: 25),
                                                      Text(
                                                        'Pick Image',
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ])
                              : GestureDetector(
                                  onTap: () => provider.pickCoverImage(index,
                                      isMainEventCoverImages: false),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 1),
                                    ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add,
                                              color: Colors.black38, size: 25),
                                          Text(
                                            'Pick Image',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ]),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 25, color: Colors.red),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("sub event removed")),
                      );
                      setState(() {
                        if (subEventControllers.isNotEmpty) {
                          subEventControllers.removeAt(index);
                        }
                      });
                    }),
              ),
            ),
          ]);
        }
        return const SizedBox();
      }),
    ]);
  }

  String getSelectedTags() {
    return tags
        .where((tag) => tag['isSelected'])
        .map((tag) => tag['name'])
        .join(', ');
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF46BCC3),
          minimumSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.07),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          if (!(_formKey.currentState?.validate() ?? false)) return;

          if (subEventControllers.isEmpty) {
            showCustomSnackBar(context, 'Minimum one subevent is mandatary',
                isError: true);
            return;
          }

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Loader(),
          );

          try {
            final imagePickerProvider = context.read<ImagePickerProvider>();
            final eventProvider = context.read<EventProvider>();

            if (imagePickerProvider.mainEventImage == null) {
              _showSnackBar(context, "Please select an image.");
              return;
            }

            final mainEventData = _buildMainEventData();
            final subEventsData = _buildSubEventsData();
            final message = await eventProvider.submitEvent(
              imagePickerProvider.mainEventImage!,
              imagePickerProvider.mainEventCoverImages,
              imagePickerProvider.subEventCoverImages,
              mainEventData,
              subEventsData,
            );
            _handleSubmissionResult(context, message, imagePickerProvider);
          } catch (e) {
            _showSnackBar(context, "Please try again.");
          }
        },
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Map<String, dynamic> _buildMainEventData() {
    return {
      'name': nameController.text,
      'location': locationController.text,
      'description': descriptionController.text,
      'category': categoryController.text,
      'audienceType': audienceTypeController.text,
      'multiTickets': multiTickets,
      'currency': currencyController.text,
      'tags': getSelectedTags(),
      'regStartDate': regStartDateController.text,
      'regEndDate': regEndDateController.text,
      'latitude': latitudeController.text,
      'longitude': longitudeController.text,
    };
  }

  List<Map<String, dynamic>> _buildSubEventsData() {
    return subEventControllers.map((subEvent) {
      return {
        'name': subEvent['name']!.text,
        'description': subEvent['description']!.text,
        'video_url': subEvent['video_url']!.text,
        'start_date': subEvent['start_date']!.text,
        'start_time': subEvent['start_time']!.text,
        'end_time': subEvent['end_time']!.text,
        'host_name': subEvent['host_name']!.text,
        'country_code': subEvent['country_code']!.text,
        'host_mobile': subEvent['host_mobile']!.text,
        'host_email': subEvent['host_email']!.text,
        'ticket_type': subEvent['ticket_type']!.text,
        'ticket_price': subEvent['ticket_price']!.text,
        'ticket_qty': subEvent['ticket_qty']!.text,
      };
    }).toList();
  }

  void _handleSubmissionResult(BuildContext context, String message,
      ImagePickerProvider imagePickerProvider) {
    const List<String> errorMessages = [
      "Upload required files",
      "Enter all fields",
      "Enter all fields",
      "Internal server error",
    ];

    FocusScope.of(context).unfocus();

    if (message == "Events and sub events uploaded") {
      showCustomSnackBar(context, message);
      imagePickerProvider.clearImages();
      widget.pageController.jumpToPage(3);
    } else if (errorMessages.contains(message)) {
      showCustomSnackBar(context, message);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      showCustomSnackBar(context, message);
    }
  }
}
