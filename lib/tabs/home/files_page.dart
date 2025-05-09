import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  List<FileModel> _files = [];

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files Page'),
      ),
      body: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_files[index].title),
            subtitle: Text(_files[index].date),
            trailing: Text(_files[index].summary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileDetails(file: _files[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> fetchFiles() async {
    final storage = FirebaseStorage.instance;
    final filesRef = storage.ref().child('files');

    final files = await filesRef.list().then((result) {
      return result.items;
    });

    List<FileModel> fileModels = [];

    for (var file in files) {
      final fileRef = filesRef.child(file.name);
      final fileMetadata = await fileRef.getMetadata();
      final fileDownloadUrl = await fileRef.getDownloadURL();

      final fileModel = FileModel(
        title: file.name,
        date: fileMetadata.timeCreated.toString(),
        summary: 'This is a summary of the file',
        downloadUrl: fileDownloadUrl,
      );

      fileModels.add(fileModel);
    }

    setState(() {
      _files = fileModels;
    });
  }
}

class FileModel {
  final String title;
  final String date;
  final String summary;
  final String downloadUrl;

  FileModel({
    required this.title,
    required this.date,
    required this.summary,
    required this.downloadUrl,
  });
}

class FileDetails extends StatelessWidget {
  final FileModel file;

  const FileDetails({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${file.title}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${file.date}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Summary: ${file.summary}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle file download
              },
              child: const Text('Download'),
            ),
          ],
        ),
      ),
    );
  }
}