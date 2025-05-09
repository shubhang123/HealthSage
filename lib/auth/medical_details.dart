import 'dart:io';
import 'package:authapp/auth/upload_docs.dart';
import 'package:authapp/tabs/home/dashboard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

import '../tabs/home/home_page.dart';

class MedicalDetailsScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String Id;

  MedicalDetailsScreen({required this.Id, Key? key}) : super(key: key);

  @override
  State<MedicalDetailsScreen> createState() => _MedicalDetailsScreenState();
}

class _MedicalDetailsScreenState extends State<MedicalDetailsScreen> {
  final ImagePicker _picker = ImagePicker();
  String imageUrl = "";
  String pdfUrl = "";
  String bloodGroup = "";
  //String chronicConditions = "";
  //String allergies = "";
  //String surgeries = "";
  String weight = "";
  String height = "";

  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController surgeriesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController chronicConditionsController =
      TextEditingController();

  List<String> _selectedChronicConditions = [];
  List<String> _selectedAllergies = [];
  List<String> _selectedSurgeries = [];

  final _formkey = GlobalKey<FormState>();

  Future<void> _confirmUpload(String fileType, Function uploadFunction) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm $fileType Upload',
          style: TextStyle(color: Colors.white), // Change font color to white
        ),
        content: Text(
          'Are you sure you want to upload this $fileType?',
          style: TextStyle(color: Colors.white), // Change font color to white
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel',
                style: TextStyle(
                    color: Colors.white)), // Change font color to white
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Upload',
                style: TextStyle(
                    color: Colors.white)), // Change font color to white
          ),
        ],
        backgroundColor: Colors
            .black, // Optional: change background color to black for better contrast
      ),
    );

    if (confirmed) {
      await uploadFunction();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            '$fileType Uploaded',
            style: TextStyle(color: Colors.white), // Change font color to white
          ),
          content: Text(
            'Your $fileType has been successfully uploaded. You can upload more reports if needed.',
            style: TextStyle(color: Colors.white), // Change font color to white
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK',
                  style: TextStyle(
                      color: Colors.white)), // Change font color to white
            ),
          ],
          backgroundColor: Colors
              .black, // Optional: change background color to black for better contrast
        ),
      );
    }
  }

  Future<bool> _fileExists(String fileName, int fileSize, String path) async {
    ListResult result = await FirebaseStorage.instance.ref(path).listAll();
    for (var item in result.items) {
      FullMetadata metadata = await item.getMetadata();
      if (metadata.name == fileName && metadata.size == fileSize) {
        return true;
      }
    }
    return false;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      int fileSize = await File(image.path).length();
      bool exists = await _fileExists(image.name, fileSize, 'user_images');

      if (exists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Image Exists',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'An image with the same name and size already exists. Please choose a different image.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      bool confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Confirm Image Upload',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to upload this image?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Upload', style: TextStyle(color: Colors.white)),
            ),
          ],
          backgroundColor: Colors.black,
        ),
      );

      if (confirmed) {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('user_images/${image.name}');
        UploadTask uploadTask = storageReference.putFile(File(image.path));
        await uploadTask.whenComplete(() => null);
        String downloadUrl = await storageReference.getDownloadURL();
        setState(() {
          this.imageUrl = downloadUrl;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Image Uploaded',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Your image has been successfully uploaded. You can upload more reports if needed.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
            backgroundColor: Colors.black,
          ),
        );
      }
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      int fileSize = await file.length();
      bool exists =
          await _fileExists(result.files.single.name, fileSize, 'user_pdfs');

      if (exists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'PDF Exists',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'A PDF with the same name and size already exists. Please choose a different PDF.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      bool confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Confirm PDF Upload',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to upload this PDF?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Upload', style: TextStyle(color: Colors.white)),
            ),
          ],
          backgroundColor: Colors.black,
        ),
      );

      if (confirmed) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('user_pdfs/${result.files.single.name}');
        UploadTask uploadTask = storageReference.putFile(file);
        await uploadTask.whenComplete(() => null);
        String downloadUrl = await storageReference.getDownloadURL();
        setState(() {
          this.pdfUrl = downloadUrl;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'PDF Uploaded',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Your PDF has been successfully uploaded. You can upload more reports if needed.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
            backgroundColor: Colors.black,
          ),
        );
      }
    }
  }

  saveMedicalDetails() async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.Id)
            .update({
          'bloodGroup': bloodGroup,
          'chronicConditions': _selectedChronicConditions,
          'allergies': _selectedAllergies,
          'surgeries': _selectedSurgeries,
          'weight': weight,
          'height': height,
          'imageUrl': imageUrl,
          'pdfUrl': pdfUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Medical details saved successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardScreen(
                    userId: widget.Id,
                  )),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          content: Text(
            "Failed to save medical details: $e",
            style: const TextStyle(fontSize: 18.0),
          ),
        ));
      }
    }
  }

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: bloodGroup.isNotEmpty ? bloodGroup : null,
                        items: bloodGroups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(
                              group,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            bloodGroup = value!;
                          });
                        },
                        dropdownColor: Colors.deepPurple.withOpacity(0.8),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.purple.withOpacity(0.3),
                          prefixIcon: const Icon(Icons.bloodtype_outlined,
                              color: Colors.white),
                          hintText: 'Blood Group',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your blood group';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: weightController,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          prefixIcon: const Icon(Icons.monitor_weight_outlined),
                          hintText: 'Weight (in kg)',
                          hintStyle: TextStyle(color: Colors.white),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: heightController,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.2),
                          prefixIcon: const Icon(Icons.height_outlined),
                          hintText: 'Height (in cm)',
                          hintStyle: TextStyle(color: Colors.white),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your height';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Medical Information',
                  style: GoogleFonts.lato(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  items: [
                    MultiSelectItem('Diabetes', 'Diabetes'),
                    MultiSelectItem('Hypertension', 'Hypertension'),
                    MultiSelectItem('Asthma', 'Asthma'),
                  ],
                  title: const Text('Chronic Conditions'),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.medical_services,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: Text(
                    'Select Chronic Conditions',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (values) {
                    _selectedChronicConditions = values.cast<String>();
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  items: [
                    MultiSelectItem('Peanuts', 'Peanuts'),
                    MultiSelectItem('Seafood', 'Seafood'),
                    MultiSelectItem('Pollen', 'Pollen'),
                  ],
                  title: const Text('Allergies'),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: Text(
                    'Select Allergies',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (values) {
                    _selectedAllergies = values.cast<String>();
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  items: [
                    MultiSelectItem('Appendectomy', 'Appendectomy'),
                    MultiSelectItem(
                        'Gallbladder Removal', 'Gallbladder Removal'),
                    MultiSelectItem('C-Section', 'C-Section'),
                  ],
                  title: const Text('Surgeries'),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  buttonIcon: Icon(
                    Icons.local_hospital,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: Text(
                    'Select Surgeries',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  onConfirm: (values) {
                    _selectedSurgeries = values.cast<String>();
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                    print('User chose to scan images');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 60),
                  ),
                  child: Text(
                    'Scan Medical Record',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.grey[350],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _pickPdf();
                    print('User chose to upload PDF');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 60),
                  ),
                  child: Text(
                    'Upload PDF',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.grey[350],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minWidth: double.infinity,
                  height: 60,
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        bloodGroup = bloodGroup;
                        weight = weightController.text;
                        height = heightController.text;
                      });
                      saveMedicalDetails();
                    }
                  },
                  child: Text(
                    'Save Medical Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.grey[350],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
