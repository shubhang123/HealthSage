import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  final String fileName;
  final IconData icon;

  FileCard({required this.fileName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          color: const Color(0xFF386cf1).withAlpha(200),
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    fileName,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
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

class FileList extends StatelessWidget {
  final List<FileCard> files;

  FileList({required this.files});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        return files[index];
      },
    );
  }
}

class FileListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<FileCard> files = [
      FileCard(fileName: 'Report1.txt', icon: Icons.file_copy),
      FileCard(fileName: 'Report2.txt', icon: Icons.file_copy),
      FileCard(fileName: 'Report3.txt', icon: Icons.file_copy),
      FileCard(fileName: 'report4.txt', icon: Icons.file_copy),
      FileCard(fileName: 'Report5.txt', icon: Icons.file_copy),
      FileCard(fileName: 'Report6.txt', icon: Icons.file_copy),
      FileCard(fileName: 'Report7.txt', icon: Icons.file_copy),
      FileCard(fileName: 'File2.txt', icon: Icons.file_copy),
      FileCard(fileName: 'File3.txt', icon: Icons.file_copy),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FileList(files: files),
      ),
    );
  }
}
