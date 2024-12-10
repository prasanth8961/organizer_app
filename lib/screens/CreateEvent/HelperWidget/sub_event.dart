import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:organizer_app/Screens/CreateEvent/HelperWidget/curved_text_field.dart';
import 'package:provider/provider.dart';

class SubEvent extends StatefulWidget {
  const SubEvent({super.key});

  @override
  State<SubEvent> createState() => _SubEventState();
}

class _SubEventState extends State<SubEvent> {
  List<Map<String, TextEditingController>> subEventControllers = [];

  @override
  void initState() {
    super.initState();
    _addSubEvent();
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

  TextEditingController regStartDateController = TextEditingController();
  TextEditingController regEndDateController = TextEditingController();
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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final provider = Provider.of<ImagePickerProvider>(context, listen: false);
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
                        controller: subEventControllers[index]['name']!,
                        hint: 'Sub-event Name'),
                    CurvedTextField(
                        controller: subEventControllers[index]['description']!,
                        hint: 'Sub-event Description',
                        maxLines: 3),
                    CurvedTextField(
                        controller: subEventControllers[index]['video_url']!,
                        hint: 'Video URL'),
                    CurvedTextField(
                      controller: subEventControllers[index]['start_date']!,
                      hint: 'Start Date',
                      readOnly: true,
                      onTap: () => _selectDate(context, index),
                    ),
                    CurvedTextField(
                      controller: subEventControllers[index]['start_time']!,
                      hint: 'Start Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, index, 'start_time'),
                    ),
                    CurvedTextField(
                      controller: subEventControllers[index]['end_time']!,
                      hint: 'End Time',
                      readOnly: true,
                      onTap: () => _selectTime(context, index, 'end_time'),
                    ),
                    CurvedTextField(
                        controller: subEventControllers[index]['host_name']!,
                        hint: 'Host Name'),
                    CurvedTextField(
                        controller: subEventControllers[index]['country_code']!,
                        hint: 'Country Code'),
                    CurvedTextField(
                        controller: subEventControllers[index]['host_mobile']!,
                        hint: 'Host Mobile'),
                    CurvedTextField(
                        controller: subEventControllers[index]['host_email']!,
                        hint: 'Host Email'),
                    CurvedTextField(
                        controller: subEventControllers[index]['ticket_type']!,
                        hint: 'Ticket Type'),
                    CurvedTextField(
                        controller: subEventControllers[index]['ticket_price']!,
                        hint: 'Ticket Price'),
                    CurvedTextField(
                        controller: subEventControllers[index]['ticket_qty']!,
                        hint: 'Ticket Quantity'),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display cover images if picked
                          const Text('Cover Images'),
                          const SizedBox(height: 8),
                          (provider.subEventCoverImages[index].isNotEmpty)
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
                                      GestureDetector(
                                        onTap: () => provider.pickCoverImage(
                                            index,
                                            isMainEventCoverImages: false),
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
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                      ),
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
      ElevatedButton(
        onPressed: () {
          provider.setSubEventImageList();
          _addSubEvent();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF46BCC3),
          minimumSize: Size(screenWidth * 0.4, screenHeight * 0.07),
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
    ]);
  }
}
