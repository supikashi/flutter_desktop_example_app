import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SystemApiTab extends StatefulWidget {
  const SystemApiTab({super.key});

  @override
  State<SystemApiTab> createState() => _SystemApiTabState();
}

class _SystemApiTabState extends State<SystemApiTab> {
  String _systemInfo = 'Системные данные не загружены';

  Future<void> _pickSystemFile() async {
    setState(() => _systemInfo = 'Вызов системного диалога macOS...');
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Нативный диалог выбора файла',
    );

    if (result != null) {
      setState(() => _systemInfo = 'Выбран файл:\n${result.files.single.path}');
    } else {
      setState(() => _systemInfo = 'Пользователь отменил выбор в Finder');
    }
  }

  Future<void> _getSystemInfo() async {
    setState(() => _systemInfo = 'Запрашиваем данные у ОС...');
    
    try {
      setState(() {
        _systemInfo = '''
[System Info]

• Операционная система: ${Platform.operatingSystem}
• Версия ОС: ${Platform.operatingSystemVersion}
• Архитектура: ${Platform.version}
• Количество ядер (логических): ${Platform.numberOfProcessors}
• Локаль системы: ${Platform.localeName}
''';
      });
    } catch (e) {
      setState(() => _systemInfo = 'Ошибка вызова системного API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Работа с системными API',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          
          ElevatedButton.icon(
            onPressed: _pickSystemFile,
            icon: const Icon(Icons.folder_open),
            label: const Text('Открыть системный Finder (macOS)'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          
          ElevatedButton.icon(
            onPressed: _getSystemInfo,
            icon: const Icon(Icons.computer),
            label: const Text('Получить информацию об ОС'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
              ]
            ),
            child: Text(
              _systemInfo,
              style: const TextStyle(
                fontFamily: 'Courier',
                color: Colors.greenAccent,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}