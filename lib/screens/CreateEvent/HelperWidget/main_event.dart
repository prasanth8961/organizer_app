import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:organizer_app/Screens/CreateEvent/HelperWidget/curved_text_field.dart';
import 'package:organizer_app/Screens/CreateEvent/HelperWidget/dropdown_menu.dart';
import 'package:provider/provider.dart';

class MainEvent extends StatefulWidget {
  const MainEvent({super.key});

  @override
  State<MainEvent> createState() => _MainEventState();
}

class _MainEventState extends State<MainEvent> {
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

  List<Map<String, TextEditingController>> subEventControllers = [];

  bool multiTickets = false;
  List<String> tags = [];

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
    final imagePickerProvider =
        Provider.of<ImagePickerProvider>(context, listen: false);
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
            CurvedTextField(controller: nameController, hint: 'Event Name'),
            CurvedTextField(controller: locationController, hint: 'Location'),
            CurvedTextField(
                controller: descriptionController,
                hint: 'Description',
                maxLines: 3),
            CustomDropDownMenu(
                controller: categoryController,
                onChanged: (value) {
                  setState(() {
                    categoryController.text = value ?? '';
                  });
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
            CurvedTextField(
                controller: audienceTypeController, hint: 'Audience Type'),
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
                hint: 'Currency',
                items: const ['INR', 'USD', 'EUR', 'JPY', 'MXN']),
            CurvedTextField(
              controller: TextEditingController(text: tags.join(', ')),
              hint: 'Tags (comma separated)',
              onChanged: (value) =>
                  tags = value.split(',').map((tag) => tag.trim()).toList(),
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

  Widget _buildImagePicker(ImagePickerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Display main image if picked
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
        // Display cover images if picked
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
          GestureDetector(
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
          ),
        ])
      ],
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
}
