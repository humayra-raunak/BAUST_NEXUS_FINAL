import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';

class AcademicResourcesScreen extends StatefulWidget {
  const AcademicResourcesScreen({super.key});
  @override
  State<AcademicResourcesScreen> createState() =>
      _AcademicResourcesScreenState();
}

class _AcademicResourcesScreenState extends State<AcademicResourcesScreen> {
  // ============ FILTER STATES FOR RESOURCES ============
  String _deptFilter = 'All';
  String _levelFilter = 'All';
  String _termFilter = 'All';
  String _typeFilter = 'All';

  // ============ RESOURCE UPLOAD CONTROLLERS ============
  final TextEditingController _resourceTitleController =
      TextEditingController();
  final TextEditingController _resourceCourseController =
      TextEditingController();
  String _resourceUploadType = 'Book';
  String _resourceUploadDept = 'CSE';
  String _resourceUploadLevel = 'Level 1';
  String _resourceUploadTerm = 'Term I';
  String? _selectedFileName;
  PlatformFile? _pickedFile;
  bool _isUploading = false;
  double _uploadProgress = 0;

  // ============ ROUTINE UPLOAD CONTROLLERS ============
  final TextEditingController _routineTitleController = TextEditingController();
  String _routineUploadDept = 'CSE';
  String _routineUploadLevel = 'Level 1';
  String _routineUploadTerm = 'Term I';
  String _routineUploadSection = 'A';
  String? _routineFileName;
  PlatformFile? _pickedRoutineFile;

  // ============ CT QUESTION UPLOAD CONTROLLERS ============
  final TextEditingController _ctTitleController = TextEditingController();
  final TextEditingController _ctCourseController = TextEditingController();
  String _ctUploadDept = 'CSE';
  String _ctUploadLevel = 'Level 1';
  String _ctUploadTerm = 'Term I';
  String _ctUploadSection = 'A';
  String? _ctFileName;
  PlatformFile? _pickedCTFile;

  // ============ ROUTINE VIEW SELECTION ============
  String _routineViewDept = 'All';
  String _routineViewLevel = 'All';
  String _routineViewTerm = 'All';
  String _routineViewSection = 'All';

  // ============ CT VIEW SELECTION ============
  String _ctViewDept = 'All';
  String _ctViewLevel = 'All';
  String _ctViewTerm = 'All';
  String _ctViewSection = 'All';

  // ============ RESOURCE TYPE LISTS ============
  final List<String> _allResourceTypes = [
    'All',
    'Book',
    'Slide',
    'Class Note',
    'Lab Manual',
    'Assignment',
    'Previous Year Question',
    'Project Report',
    'PPT',
    'Excel',
    'TXT',
    'PDF'
  ];

  final List<String> _uploadResourceTypes = [
    'Book',
    'Slide',
    'Class Note',
    'Lab Manual',
    'Assignment',
    'Previous Year Question',
    'Project Report',
    'PPT',
    'Excel',
    'TXT',
    'PDF'
  ];

  // ============ SUPABASE CLIENT ============
  final SupabaseClient _supabase = Supabase.instance.client;

  // ============ LOCAL STORAGE FOR ROUTINES & CT ============
  final List<Map<String, String>> _uploadedRoutines = [];
  final List<Map<String, String>> _uploadedCTQuestions = [];

  // ============ RESOURCES LIST STATE ============
  List<Map<String, dynamic>> _resourcesList = [];
  bool _isLoadingResources = true;

  // ============ LIFECYCLE METHODS ============
  @override
  void initState() {
    super.initState();
    _loadResourcesFromSupabase();
  }

  @override
  void dispose() {
    _resourceTitleController.dispose();
    _resourceCourseController.dispose();
    _routineTitleController.dispose();
    _ctTitleController.dispose();
    _ctCourseController.dispose();
    super.dispose();
  }

  // ============ LOAD RESOURCES FROM SUPABASE ============
  Future<void> _loadResourcesFromSupabase() async {
    try {
      setState(() {
        _isLoadingResources = true;
      });

      final data = await _supabase
          .from('resources')
          .select()
          .order('created_at', ascending: false);

      if (data.isNotEmpty) {
        setState(() {
          _resourcesList = data
              .map<Map<String, dynamic>>((r) => {
                    'id': r['id'],
                    'title': r['title'] ?? '',
                    'course': r['course'] ?? '',
                    'type': r['type'] ?? '',
                    'dept': r['department'] ?? 'CSE',
                    'level': r['level'] ?? 'Level 1',
                    'term': r['term'] ?? 'Term I',
                    'author': r['author'] ?? 'Unknown',
                    'size': r['file_size'] ?? 'N/A',
                    'file_url': r['file_url'] ?? '',
                    'file_name': r['file_name'] ?? '',
                  })
              .toList();
        });
      } else {
        _loadSampleResources();
      }

      setState(() {
        _isLoadingResources = false;
      });
    } catch (e) {
      debugPrint('Error loading from Supabase: $e');
      _loadSampleResources();
      setState(() {
        _isLoadingResources = false;
      });
    }
  }

  // ============ LOAD SAMPLE RESOURCES (FALLBACK) ============
  void _loadSampleResources() {
    _resourcesList = [
      {
        'title': 'Introduction to C Programming',
        'course': 'CSE 1101',
        'type': 'Book',
        'dept': 'CSE',
        'level': 'Level 1',
        'term': 'Term I',
        'author': 'Tamim Shahriar',
        'size': '2.5 MB'
      },
      {
        'title': 'Data Structures Lecture Slides',
        'course': 'CSE 2101',
        'type': 'Slide',
        'dept': 'CSE',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'Prof. Rahman',
        'size': '1.8 MB'
      },
      {
        'title': 'Digital Logic Design Lab Manual',
        'course': 'CSE 2102',
        'type': 'Lab Manual',
        'dept': 'CSE',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'CSE Dept',
        'size': '3.2 MB'
      },
      {
        'title': 'Circuit Analysis Class Notes',
        'course': 'EEE 1101',
        'type': 'Class Note',
        'dept': 'EEE',
        'level': 'Level 1',
        'term': 'Term I',
        'author': 'Dr. Karim',
        'size': '4.1 MB'
      },
      {
        'title': 'Thermodynamics Assignment',
        'course': 'ME 2101',
        'type': 'Assignment',
        'dept': 'ME',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'Prof. Hasan',
        'size': '1.2 MB'
      },
      {
        'title': 'CSE Previous Year Question 2024',
        'course': 'CSE 3201',
        'type': 'Previous Year Question',
        'dept': 'CSE',
        'level': 'Level 3',
        'term': 'Term II',
        'author': 'Exam Department',
        'size': '5.0 MB'
      },
      {
        'title': 'Structural Analysis Project Report',
        'course': 'CE 3101',
        'type': 'Project Report',
        'dept': 'CE',
        'level': 'Level 3',
        'term': 'Term I',
        'author': 'CE Dept',
        'size': '3.8 MB'
      },
      {
        'title': 'Database Management System PPT',
        'course': 'CSE 3101',
        'type': 'PPT',
        'dept': 'CSE',
        'level': 'Level 3',
        'term': 'Term I',
        'author': 'Prof. Ahmed',
        'size': '2.1 MB'
      },
      {
        'title': 'Student Data Excel Sheet',
        'course': 'ICT 2101',
        'type': 'Excel',
        'dept': 'ICT',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'ICT Dept',
        'size': '1.5 MB'
      },
      {
        'title': 'Computer Networking Notes',
        'course': 'CSE 3201',
        'type': 'TXT',
        'dept': 'CSE',
        'level': 'Level 3',
        'term': 'Term II',
        'author': 'Dr. Kabir',
        'size': '0.5 MB'
      },
      {
        'title': 'Digital Electronics PDF Guide',
        'course': 'EEE 2101',
        'type': 'PDF',
        'dept': 'EEE',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'EEE Dept',
        'size': '6.2 MB'
      },
      {
        'title': 'EEE Previous Year Question 2023',
        'course': 'EEE 3101',
        'type': 'Previous Year Question',
        'dept': 'EEE',
        'level': 'Level 3',
        'term': 'Term I',
        'author': 'Exam Department',
        'size': '4.5 MB'
      },
      {
        'title': 'Engineering Mathematics PDF',
        'course': 'MATH 1101',
        'type': 'PDF',
        'dept': 'CSE',
        'level': 'Level 1',
        'term': 'Term I',
        'author': 'Math Dept',
        'size': '3.0 MB'
      },
      {
        'title': 'Power Electronics Assignment',
        'course': 'EEE 2201',
        'type': 'Assignment',
        'dept': 'EEE',
        'level': 'Level 2',
        'term': 'Term II',
        'author': 'EEE Dept',
        'size': '2.8 MB'
      },
      {
        'title': 'Machine Design Project Report',
        'course': 'ME 3101',
        'type': 'Project Report',
        'dept': 'ME',
        'level': 'Level 3',
        'term': 'Term I',
        'author': 'ME Dept',
        'size': '7.5 MB'
      },
      {
        'title': 'Control Systems Lab Manual',
        'course': 'EEE 3102',
        'type': 'Lab Manual',
        'dept': 'EEE',
        'level': 'Level 3',
        'term': 'Term I',
        'author': 'EEE Dept',
        'size': '4.2 MB'
      },
      {
        'title': 'Data Communication PPT',
        'course': 'CSE 3202',
        'type': 'PPT',
        'dept': 'CSE',
        'level': 'Level 3',
        'term': 'Term II',
        'author': 'Prof. Karim',
        'size': '3.6 MB'
      },
      {
        'title': 'Thermodynamics Book',
        'course': 'ME 2102',
        'type': 'Book',
        'dept': 'ME',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'Yunus Cengel',
        'size': '8.1 MB'
      },
      {
        'title': 'Soil Mechanics Notes',
        'course': 'CE 2101',
        'type': 'Class Note',
        'dept': 'CE',
        'level': 'Level 2',
        'term': 'Term I',
        'author': 'CE Dept',
        'size': '3.4 MB'
      },
      {
        'title': 'ICT Previous Year 2022',
        'course': 'ICT 3101',
        'type': 'Previous Year Question',
        'dept': 'ICT',
        'level': 'Level 3',
        'term': 'Term I',
        'author': 'Exam Dept',
        'size': '4.8 MB'
      },
    ];
  }

  // ============ FILE PICKING ============
  Future<void> _pickFile(void Function(void Function()) setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      setDialogState(() {
        _pickedFile = result.files.single;
        _selectedFileName = _pickedFile!.name;
        if (_resourceTitleController.text.isEmpty) {
          _resourceTitleController.text = _pickedFile!.name.split('.').first;
        }
      });
    } catch (e) {
      debugPrint('Pick error: $e');
    }
  }

  Future<PlatformFile?> _pickDialogFile(
      void Function(void Function()) setDialogState) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return null;
      return result.files.single;
    } catch (e) {
      debugPrint('Pick error: $e');
      return null;
    }
  }

  // ============ UPLOAD TO SUPABASE STORAGE ============
  Future<void> _uploadResourceToSupabase(
      void Function(void Function()) setDialogState, BuildContext ctx) async {
    if (_pickedFile == null ||
        _resourceTitleController.text.isEmpty ||
        _resourceCourseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a file and fill all fields'),
            backgroundColor: AppColors.warning),
      );
      return;
    }

    // Capture user data before async operations
    final userName = context.read<AuthService>().currentUser?.name ?? 'You';
    final userId = context.read<AuthService>().currentUser?.id ?? 'unknown';

    try {
      setDialogState(() {
        _isUploading = true;
        _uploadProgress = 10;
      });

      // Generate unique file name
      final uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}';

      String? fileUrl;

      // --- Step 1: Upload to Supabase Storage ---
      try {
        final fileBytes = _pickedFile!.bytes ??
            (await File(_pickedFile!.path!).readAsBytes());
        if (fileBytes.isNotEmpty) {
          await _supabase.storage.from('resources').uploadBinary(
                uniqueFileName,
                fileBytes,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else if (_pickedFile!.path != null) {
          await _supabase.storage.from('resources').upload(
                uniqueFileName,
                File(_pickedFile!.path!),
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
      } catch (storageError) {
        debugPrint('Supabase Storage Error Details: $storageError');
        String errorMsg = storageError.toString();
        if (errorMsg.contains('403') ||
            errorMsg.contains('Permission denied')) {
          errorMsg =
              "Permission Denied: Please add the 'authenticated' role to your Storage INSERT policy.";
        }
        throw 'Storage Error: $errorMsg';
      }

      setDialogState(() {
        _uploadProgress = 60;
      });

      fileUrl =
          _supabase.storage.from('resources').getPublicUrl(uniqueFileName);

      // --- Step 2: Insert into Database Table ---
      await _supabase.from('resources').insert({
        'title': _resourceTitleController.text,
        'course': _resourceCourseController.text,
        'type': _resourceUploadType,
        'file_name': _pickedFile!.name,
        'file_url': fileUrl,
        'file_size': _formatFileSize(_pickedFile!.size),
        'author': userName,
        'department': _resourceUploadDept,
        'level': _resourceUploadLevel,
        'term': _resourceUploadTerm,
        'uploaded_by': userId,
        'created_at': DateTime.now().toIso8601String(),
      });

      setDialogState(() {
        _isUploading = false;
        _uploadProgress = 100;
      });

      await _loadResourcesFromSupabase();

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Expanded(child: Text('✅ Upload successful!')),
          ]),
          backgroundColor: AppColors.success,
        ),
      );

      _resourceTitleController.clear();
      _resourceCourseController.clear();
      _selectedFileName = null;
      _pickedFile = null;
    } catch (e) {
      setDialogState(() {
        _isUploading = false;
      });
      debugPrint('Upload error detailed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('❌ ${e.toString().replaceAll('Exception:', '')}'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ));
      }
    }
  }

  // ============ DOWNLOAD FILE FROM SUPABASE ============
  Future<void> _downloadFile(String fileUrl, String title) async {
    try {
      if (fileUrl.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No file available for download'),
                backgroundColor: AppColors.warning),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.downloading, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('📥 Downloading: $title')),
            ]),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      Uri uri = Uri.parse(fileUrl);
      String fileName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last.split('?').first
          : 'downloaded_file';
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      List<int> bytes;

      final response = await http.get(uri);
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        bytes = response.bodyBytes;
      } else {
        final storagePath = fileUrl.split('/').last.split('?').first;
        final downloadedBytes =
            await _supabase.storage.from('resources').download(storagePath);
        if (downloadedBytes.isEmpty) {
          throw 'Failed to download file from storage';
        }
        bytes = downloadedBytes;
      }

      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text('✅ Opening: $title')),
            ]),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open file: ${result.message}'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      debugPrint('Download error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _openLocalFile(String filePath, String title) async {
    if (filePath.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No local file attached'),
              backgroundColor: AppColors.warning),
        );
      }
      return;
    }

    if (!await File(filePath).exists()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('File not found on device'),
              backgroundColor: AppColors.error),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.downloading, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('📥 Opening: $title')),
          ]),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to open the file: ${result.message}'),
            backgroundColor: AppColors.error),
      );
    }
  }

  Future<String?> _savePickedFileToAppDir(PlatformFile file) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final safeFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final path = '${dir.path}/$safeFileName';
      final targetFile = File(path);

      if (file.bytes != null && file.bytes!.isNotEmpty) {
        await targetFile.writeAsBytes(file.bytes!);
        return path;
      }

      if (file.path != null && file.path!.isNotEmpty) {
        final sourceFile = File(file.path!);
        if (await sourceFile.exists()) {
          await sourceFile.copy(path);
          return path;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Save file error: $e');
      return null;
    }
  }

  // ============ UPLOAD ROUTINE (LOCAL) ============
  Future<void> _uploadRoutine() async {
    if (_routineTitleController.text.isEmpty || _pickedRoutineFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add a title and choose a routine file'),
            backgroundColor: AppColors.warning),
      );
      return;
    }

    final savedPath = await _savePickedFileToAppDir(_pickedRoutineFile!);
    if (!mounted) return;
    if (savedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to save routine file locally'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() {
      _uploadedRoutines.insert(0, {
        'title': _routineTitleController.text,
        'department': _routineUploadDept,
        'level': _routineUploadLevel,
        'term': _routineUploadTerm,
        'section': _routineUploadSection,
        'file_name': _routineFileName ?? 'Routine File',
        'file_path': savedPath,
      });
    });
    _routineTitleController.clear();
    _routineFileName = null;
    _pickedRoutineFile = null;
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Routine uploaded!'),
        backgroundColor: AppColors.success));
  }

  // ============ UPLOAD CT QUESTION (LOCAL) ============
  Future<void> _uploadCTQuestion() async {
    if (_ctTitleController.text.isEmpty ||
        _ctCourseController.text.isEmpty ||
        _pickedCTFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete all CT fields and choose a file'),
            backgroundColor: AppColors.warning),
      );
      return;
    }

    final savedPath = await _savePickedFileToAppDir(_pickedCTFile!);
    if (!mounted) return;
    if (savedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to save CT file locally'),
            backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() {
      _uploadedCTQuestions.insert(0, {
        'title': _ctTitleController.text,
        'course': _ctCourseController.text,
        'department': _ctUploadDept,
        'level': _ctUploadLevel,
        'term': _ctUploadTerm,
        'section': _ctUploadSection,
        'file_name': _ctFileName ?? 'CT File',
        'file_path': savedPath,
      });
    });
    _ctTitleController.clear();
    _ctCourseController.clear();
    _ctFileName = null;
    _pickedCTFile = null;
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ CT Question uploaded!'),
        backgroundColor: AppColors.success));
  }

  // ============ FORMAT FILE SIZE ============
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // ============ DELETE RESOURCE ============
  Future<void> _deleteResource(Map<String, dynamic> resource) async {
    final user = context.read<AuthService>().currentUser;
    if (user?.role != 'teacher' && user?.role != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Only teachers and admins can delete resources'),
            backgroundColor: AppColors.warning),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resource'),
        content:
            Text('Are you sure you want to delete "${resource['title']}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      // Delete from storage
      final fileName = resource['file_url']?.toString().split('/').last;
      if (fileName != null) {
        await _supabase.storage.from('resources').remove([fileName]);
      }
      // Delete from database
      await _supabase.from('resources').delete().eq('id', resource['id']);
      // Remove from local list
      setState(() {
        _resourcesList.removeWhere((r) => r['id'] == resource['id']);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Resource deleted'),
              backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete: $e'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  // ============ DELETE ROUTINE ============
  void _deleteRoutine(int index) {
    final user = context.read<AuthService>().currentUser;
    if (user?.role != 'teacher' && user?.role != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Only teachers and admins can delete routines'),
            backgroundColor: AppColors.warning),
      );
      return;
    }
    setState(() {
      _uploadedRoutines.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Routine deleted'), backgroundColor: AppColors.success),
    );
  }

  // ============ DELETE CT ============
  void _deleteCT(int index) {
    final user = context.read<AuthService>().currentUser;
    if (user?.role != 'teacher' && user?.role != 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Only teachers and admins can delete CT questions'),
            backgroundColor: AppColors.warning),
      );
      return;
    }
    setState(() {
      _uploadedCTQuestions.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('CT question deleted'),
          backgroundColor: AppColors.success),
    );
  }

  // ============ MAIN BUILD METHOD ============
  @override
  Widget build(BuildContext context) {
    final filteredResources = _resourcesList
        .where((r) =>
            (_deptFilter == 'All' || r['dept'] == _deptFilter) &&
            (_levelFilter == 'All' || r['level'] == _levelFilter) &&
            (_termFilter == 'All' || r['term'] == _termFilter) &&
            (_typeFilter == 'All' || r['type'] == _typeFilter))
        .toList();

    final currentUser = context.watch<AuthService>().currentUser;
    final canUpload =
        currentUser?.role == 'teacher' || currentUser?.role == 'admin';
    final tabs = [
      const Tab(text: 'Resources', icon: Icon(Icons.menu_book, size: 20)),
      const Tab(text: 'Routine', icon: Icon(Icons.schedule, size: 20)),
      const Tab(text: 'CT Questions', icon: Icon(Icons.quiz, size: 20)),
      if (canUpload)
        const Tab(text: 'Upload', icon: Icon(Icons.upload_file, size: 20)),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: Text('Academic Resources',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 17)),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            _buildResourcesTab(filteredResources),
            _buildRoutineTab(),
            _buildCTQuestionsTab(),
            if (canUpload) _buildUploadTab(),
          ],
        ),
      ),
    );
  }

  // ✅ ALL REMAINING BUILD METHODS GO HERE
  // _buildResourcesTab, _buildRoutineTab, _buildCTQuestionsTab, _buildUploadTab
  // _showResourceUploadDialog, _showRoutineUploadDialog, _showCTUploadDialog
  // _chip, _dd, _dayColor, _dayHeader, _rRow, _ctRow, _icon, _upCard
  // _showEditRoutineDialog
  Widget _buildResourcesTab(List<Map<String, dynamic>> filtered) {
    if (_isLoadingResources) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    return Column(children: [
      Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(children: [
                _chip(
                    'Dept',
                    _deptFilter,
                    AppConstants.departments
                        .map((d) => d['name'].toString())
                        .toList(),
                    (v) => setState(() => _deptFilter = v)),
                _chip(
                    'Level',
                    _levelFilter,
                    ['All', 'Level 1', 'Level 2', 'Level 3', 'Level 4'],
                    (v) => setState(() => _levelFilter = v)),
                _chip('Term', _termFilter, ['All', 'Term I', 'Term II'],
                    (v) => setState(() => _termFilter = v)),
                _chip('Type', _typeFilter, _allResourceTypes,
                    (v) => setState(() => _typeFilter = v)),
              ]))),
      Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text('No resources',
                      style: GoogleFonts.poppins(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (c, i) {
                    final r = filtered[i];
                    return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text(
                                      _icon(r['type']?.toString() ?? ''),
                                      style: const TextStyle(fontSize: 22)))),
                          title: Text(r['title']?.toString() ?? '',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              '${r['course']} • ${r['level']} ${r['term']} • ${r['type']} • ${r['size']}',
                              style: GoogleFonts.poppins(fontSize: 11)),
                          onTap: () async {
                            final localPath = r['file_path']?.toString() ?? '';
                            final title = r['title']?.toString() ?? '';
                            if (localPath.isNotEmpty) {
                              await _openLocalFile(localPath, title);
                            } else {
                              await _downloadFile(
                                  r['file_url']?.toString() ?? '', title);
                            }
                          },
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                                icon: const Icon(Icons.download,
                                    color: AppColors.primary, size: 28),
                                onPressed: () => _downloadFile(
                                    r['file_url']?.toString() ?? '',
                                    r['title']?.toString() ?? '')),
                            if (context
                                        .watch<AuthService>()
                                        .currentUser
                                        ?.role ==
                                    'teacher' ||
                                context
                                        .watch<AuthService>()
                                        .currentUser
                                        ?.role ==
                                    'admin')
                              IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 28),
                                  onPressed: () => _deleteResource(r)),
                          ]),
                        ));
                  })),
    ]);
  }

  // ============ ROUTINE TAB (SAME AS BEFORE) ============
  Widget _buildRoutineTab() {
    final filteredRoutines = _uploadedRoutines
        .where((r) =>
            (_routineViewDept == 'All' ||
                r['department'] == _routineViewDept) &&
            (_routineViewLevel == 'All' || r['level'] == _routineViewLevel) &&
            (_routineViewTerm == 'All' || r['term'] == _routineViewTerm) &&
            (_routineViewSection == 'All' ||
                r['section'] == _routineViewSection))
        .toList();

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(children: [
                    _chip(
                        'Dept',
                        _routineViewDept,
                        [
                          'All',
                          ...AppConstants.departments
                              .map((d) => d['name'].toString())
                        ],
                        (v) => setState(() => _routineViewDept = v)),
                    _chip(
                        'Level',
                        _routineViewLevel,
                        ['All', 'Level 1', 'Level 2', 'Level 3', 'Level 4'],
                        (v) => setState(() => _routineViewLevel = v)),
                    _chip(
                        'Term',
                        _routineViewTerm,
                        ['All', 'Term I', 'Term II'],
                        (v) => setState(() => _routineViewTerm = v)),
                    _chip(
                        'Section',
                        _routineViewSection,
                        ['All', 'A', 'B', 'C'],
                        (v) => setState(() => _routineViewSection = v)),
                  ]))),
          if (context.watch<AuthService>().currentUser?.role == 'teacher' ||
              context.watch<AuthService>().currentUser?.role == 'admin')
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showRoutineUploadDialog,
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: Text('Upload Routine',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                )),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
                child: Text('📅 Class Routine',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primary),
                onPressed: _showEditRoutineDialog,
                tooltip: 'Edit'),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            _dd(
                'Level',
                _routineViewLevel,
                ['All', 'Level 1', 'Level 2', 'Level 3', 'Level 4'],
                (v) => setState(() => _routineViewLevel = v!)),
            const SizedBox(width: 8),
            _dd('Term', _routineViewTerm, ['All', 'Term I', 'Term II'],
                (v) => setState(() => _routineViewTerm = v!)),
            const SizedBox(width: 8),
            _dd('Section', _routineViewSection, ['All', 'A', 'B', 'C'],
                (v) => setState(() => _routineViewSection = v!)),
          ]),
          const SizedBox(height: 16),
          Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu']
                  .map((d) => Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              color: _dayColor(d),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text(d,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))))))
                  .toList()),
          const SizedBox(height: 4),
          Row(
              children: ['Fri', 'Sat']
                  .map((d) => Expanded(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text('$d (Off)',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))))))
                  .toList()),
          const SizedBox(height: 16),
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                      '$_routineViewLevel - $_routineViewTerm - Section $_routineViewSection',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))))),
                      const SizedBox(width: 8),
                      Container(
                          decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(10)),
                          child: IconButton(
                              icon: const Icon(Icons.download,
                                  color: Colors.white, size: 22),
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content:
                                          Text('📥 Downloading Routine...'),
                                      backgroundColor: AppColors.success)),
                              tooltip: 'Download Routine PDF')),
                    ]),
                    const SizedBox(height: 4),
                    Text('Friday & Saturday - Weekend Off',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.error,
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 16),
                    // Sunday
                    _dayHeader('Sunday'),
                    _rRow('8:00 - 08:50 AM', 'CSE 1101', 'English', 'Room 301'),
                    _rRow(
                        '09:00 - 09:50 AM', 'CSE 1102', 'Physics', 'Room 302'),
                    _rRow('10:00 - 10:50 AM', 'MATH 1101', 'Mathematics',
                        'Room 303'),
                    _rRow('10:50 - 11:30 AM', '---', '☕ Break Time', '---',
                        isBreak: true),
                    _rRow('11:30 - 12:20 PM', 'CSE 1103', 'Programming Lab',
                        'Room 308',
                        isLab: true),
                    _rRow('12:30 - 01:20 PM', 'CSE 1104', 'Programming Lab',
                        'Room 308',
                        isLab: true),
                    _rRow('01:30 - 02:20 PM', 'CSE 1105', 'Programming Lab',
                        'Room 308',
                        isLab: true),
                    const Divider(height: 20, thickness: 2),
                    // Monday
                    _dayHeader('Monday'),
                    _rRow('8:00 - 08:50 AM', 'EEE 1101', 'Circuit Analysis',
                        'Room 401'),
                    _rRow('09:00 - 09:50 AM', 'EEE 1102', 'Electronics',
                        'Room 402'),
                    _rRow('10:00 - 10:50 AM', 'CHEM 1101', 'Chemistry',
                        'Room 403'),
                    _rRow('10:50 - 11:30 AM', '---', '☕ Break Time', '---',
                        isBreak: true),
                    _rRow('11:30 - 12:20 PM', 'EEE 1103', 'Electronics Lab',
                        'Lab 2',
                        isLab: true),
                    _rRow('12:30 - 01:20 PM', 'EEE 1104', 'Electronics Lab',
                        'Lab 2',
                        isLab: true),
                    _rRow('01:30 - 02:20 PM', 'EEE 1105', 'Electronics Lab',
                        'Lab 2',
                        isLab: true),
                    const Divider(height: 20, thickness: 2),
                    // Tuesday
                    _dayHeader('Tuesday'),
                    _rRow('8:00 - 08:50 AM', 'ME 1101', 'Thermodynamics',
                        'Room 501'),
                    _rRow(
                        '09:00 - 09:50 AM', 'ME 1102', 'Mechanics', 'Room 502'),
                    _rRow('10:00 - 10:50 AM', 'MATH 1102', 'Calculus II',
                        'Room 503'),
                    _rRow('10:50 - 11:30 AM', '---', '☕ Break Time', '---',
                        isBreak: true),
                    _rRow('11:30 - 12:20 PM', 'ME 1103', 'Workshop Lab',
                        'Workshop',
                        isLab: true),
                    _rRow('12:30 - 01:20 PM', 'ME 1104', 'Workshop Lab',
                        'Workshop',
                        isLab: true),
                    _rRow('01:30 - 02:20 PM', 'ME 1105', 'Workshop Lab',
                        'Workshop',
                        isLab: true),
                    const Divider(height: 20, thickness: 2),
                    // Wednesday
                    _dayHeader('Wednesday'),
                    _rRow('8:00 - 08:50 AM', 'CE 1101', 'Civil Engineering',
                        'Room 601'),
                    _rRow(
                        '09:00 - 09:50 AM', 'CE 1102', 'Surveying', 'Room 602'),
                    _rRow('10:00 - 10:50 AM', 'HUM 1101', 'Sociology',
                        'Room 603'),
                    _rRow('10:50 - 11:30 AM', '---', '☕ Break Time', '---',
                        isBreak: true),
                    _rRow(
                        '11:30 - 12:20 PM', 'CE 1103', 'Surveying Lab', 'Field',
                        isLab: true),
                    _rRow(
                        '12:30 - 01:20 PM', 'CE 1104', 'Surveying Lab', 'Field',
                        isLab: true),
                    _rRow(
                        '01:30 - 02:20 PM', 'CE 1105', 'Surveying Lab', 'Field',
                        isLab: true),
                    const Divider(height: 20, thickness: 2),
                    // Thursday
                    _dayHeader('Thursday'),
                    _rRow('8:00 - 08:50 AM', 'ICT 1101', 'ICT Fundamentals',
                        'Room 701'),
                    _rRow(
                        '09:00 - 09:50 AM', 'ICT 1102', 'Database', 'Room 702'),
                    _rRow('10:00 - 10:50 AM', 'STAT 1101', 'Statistics',
                        'Room 703'),
                    _rRow('10:50 - 11:30 AM', '---', '☕ Break Time', '---',
                        isBreak: true),
                    _rRow(
                        '11:30 - 12:20 PM', 'ICT 1103', 'Computer Lab', 'Lab 3',
                        isLab: true),
                    _rRow(
                        '12:30 - 01:20 PM', 'ICT 1104', 'Computer Lab', 'Lab 3',
                        isLab: true),
                    _rRow(
                        '01:30 - 02:20 PM', 'ICT 1105', 'Computer Lab', 'Lab 3',
                        isLab: true),
                  ]))),
          if (filteredRoutines.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('📁 Uploaded Routines',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            ...filteredRoutines.map((r) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.schedule,
                      color: AppColors.primary, size: 28),
                  title: Text(r['title']!,
                      style: GoogleFonts.poppins(fontSize: 14)),
                  subtitle: Text(
                      '${r['department']} - ${r['level']} - ${r['term']} - Sec ${r['section']}',
                      style: GoogleFonts.poppins(fontSize: 11)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        icon: const Icon(Icons.download,
                            color: AppColors.primary),
                        onPressed: () => _openLocalFile(
                            r['file_path']?.toString() ?? '',
                            r['title']?.toString() ?? '')),
                    if (context.watch<AuthService>().currentUser?.role ==
                            'teacher' ||
                        context.watch<AuthService>().currentUser?.role ==
                            'admin')
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteRoutine(_uploadedRoutines.indexOf(r))),
                  ]),
                ))),
          ] else ...[
            const SizedBox(height: 24),
            Text('No uploaded routines for this level/term/section yet.',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 80),
        ]));
  }

  // ============ CT QUESTIONS TAB ============
  Widget _buildCTQuestionsTab() {
    final filteredCT = _uploadedCTQuestions
        .where((q) =>
            (_ctViewDept == 'All' || q['department'] == _ctViewDept) &&
            (_ctViewLevel == 'All' || q['level'] == _ctViewLevel) &&
            (_ctViewTerm == 'All' || q['term'] == _ctViewTerm) &&
            (_ctViewSection == 'All' || q['section'] == _ctViewSection))
        .toList();

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(children: [
                    _chip(
                        'Dept',
                        _ctViewDept,
                        [
                          'All',
                          ...AppConstants.departments
                              .map((d) => d['name'].toString())
                        ],
                        (v) => setState(() => _ctViewDept = v)),
                    _chip(
                        'Level',
                        _ctViewLevel,
                        ['All', 'Level 1', 'Level 2', 'Level 3', 'Level 4'],
                        (v) => setState(() => _ctViewLevel = v)),
                    _chip('Term', _ctViewTerm, ['All', 'Term I', 'Term II'],
                        (v) => setState(() => _ctViewTerm = v)),
                    _chip('Section', _ctViewSection, ['All', 'A', 'B', 'C'],
                        (v) => setState(() => _ctViewSection = v)),
                  ]))),
          if (context.watch<AuthService>().currentUser?.role == 'teacher' ||
              context.watch<AuthService>().currentUser?.role == 'admin')
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showCTUploadDialog,
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: Text('Upload CT Question',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                )),
          const SizedBox(height: 24),
          Text('📝 View CT Questions',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            _dd(
                'Level',
                _ctViewLevel,
                ['All', 'Level 1', 'Level 2', 'Level 3', 'Level 4'],
                (v) => setState(() => _ctViewLevel = v!)),
            const SizedBox(width: 8),
            _dd('Term', _ctViewTerm, ['All', 'Term I', 'Term II'],
                (v) => setState(() => _ctViewTerm = v!)),
            const SizedBox(width: 8),
            _dd('Section', _ctViewSection, ['All', 'A', 'B', 'C'],
                (v) => setState(() => _ctViewSection = v!)),
          ]),
          const SizedBox(height: 16),
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                      'CT Questions: $_ctViewLevel - $_ctViewTerm - Section $_ctViewSection',
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))))),
                      const SizedBox(width: 8),
                      Container(
                          decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(10)),
                          child: IconButton(
                              icon: const Icon(Icons.download,
                                  color: Colors.white, size: 22),
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                          '📥 Downloading CT Questions...'),
                                      backgroundColor: AppColors.success)),
                              tooltip: 'Download CT PDF')),
                    ]),
                    const SizedBox(height: 16),
                    _ctRow('Week 1', '22 Feb, Thu', 'CSE 1101',
                        'Programming Basics'),
                    _ctRow('Week 2', '1 Mar, Thu', 'CSE 1102',
                        'Physics Fundamentals'),
                    _ctRow('Week 3', '8 Mar, Thu', 'MATH 1101', 'Calculus'),
                    _ctRow(
                        'Week 4', '15 Mar, Thu', 'CSE 1103', 'Digital Logic'),
                    _ctRow(
                        'Week 5', '22 Mar, Thu', 'CSE 1104', 'English Grammar'),
                    _ctRow('Week 6', '29 Mar, Thu', 'EEE 1101',
                        'Circuit Analysis'),
                  ]))),
          if (filteredCT.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('📁 Uploaded CT Questions',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            ...filteredCT.map((q) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.quiz,
                      color: AppColors.warning, size: 28),
                  title: Text(q['title']!,
                      style: GoogleFonts.poppins(fontSize: 14)),
                  subtitle: Text(
                      '${q['department']} - ${q['course']} - ${q['level']} ${q['term']} Sec ${q['section']}',
                      style: GoogleFonts.poppins(fontSize: 11)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        icon: const Icon(Icons.download,
                            color: AppColors.warning),
                        onPressed: () => _openLocalFile(
                            q['file_path']?.toString() ?? '',
                            q['title']?.toString() ?? '')),
                    if (context.watch<AuthService>().currentUser?.role ==
                            'teacher' ||
                        context.watch<AuthService>().currentUser?.role ==
                            'admin')
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteCT(_uploadedCTQuestions.indexOf(q))),
                  ]),
                ))),
          ] else ...[
            const SizedBox(height: 24),
            Text('No uploaded CT questions for this level/term/section yet.',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColors.textSecondary)),
          ],
        ]));
  }

  // ============ UPLOAD TAB ============
  Widget _buildUploadTab() => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        _upCard(
            Icons.menu_book,
            '📚 Upload Resource',
            'Books, slides, notes etc.\nSupports: PDF, Word, Excel, PPT',
            AppColors.cse,
            _showResourceUploadDialog),
        const SizedBox(height: 14),
        _upCard(
            Icons.schedule,
            '📅 Upload Routine',
            'Class routine with Level, Term, Section',
            AppColors.primary,
            _showRoutineUploadDialog),
        const SizedBox(height: 14),
        _upCard(
            Icons.quiz,
            '📝 Upload CT Question',
            'CT question papers with details',
            AppColors.warning,
            _showCTUploadDialog),
      ]));

  // ============ UPLOAD DIALOGS ============
  void _showResourceUploadDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(children: [
            const Icon(Icons.upload_file, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text('Upload Resource',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold))
          ]),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Title
              TextField(
                  controller: _resourceTitleController,
                  decoration: InputDecoration(
                      labelText: 'Resource Title',
                      hintText: 'e.g., C Programming Notes',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.title))),
              const SizedBox(height: 12),
              // Course Code
              TextField(
                  controller: _resourceCourseController,
                  decoration: InputDecoration(
                      labelText: 'Course Code',
                      hintText: 'e.g., CSE 1101',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.book))),
              const SizedBox(height: 12),
              // Type
              DropdownButtonFormField<String>(
                initialValue: _resourceUploadType,
                decoration: InputDecoration(
                    labelText: 'Resource Type',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.category)),
                items: _uploadResourceTypes
                    .map((t) => DropdownMenuItem(
                        value: t,
                        child: Row(children: [
                          Text(_icon(t), style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(t, style: GoogleFonts.poppins())
                        ])))
                    .toList(),
                onChanged: (v) =>
                    setDialogState(() => _resourceUploadType = v!),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth < 480
                            ? constraints.maxWidth
                            : 160,
                        child: DropdownButtonFormField<String>(
                          initialValue: _resourceUploadDept,
                          decoration: InputDecoration(
                              labelText: 'Department',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          items: AppConstants.departments
                              .map((d) => d['name'].toString())
                              .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t, style: GoogleFonts.poppins())))
                              .toList(),
                          onChanged: (v) =>
                              setDialogState(() => _resourceUploadDept = v!),
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth < 480
                            ? constraints.maxWidth
                            : 140,
                        child: DropdownButtonFormField<String>(
                          initialValue: _resourceUploadLevel,
                          decoration: InputDecoration(
                              labelText: 'Level',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          items: ['Level 1', 'Level 2', 'Level 3', 'Level 4']
                              .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t, style: GoogleFonts.poppins())))
                              .toList(),
                          onChanged: (v) =>
                              setDialogState(() => _resourceUploadLevel = v!),
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth < 480
                            ? constraints.maxWidth
                            : 140,
                        child: DropdownButtonFormField<String>(
                          initialValue: _resourceUploadTerm,
                          decoration: InputDecoration(
                              labelText: 'Term',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          items: ['Term I', 'Term II']
                              .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t, style: GoogleFonts.poppins())))
                              .toList(),
                          onChanged: (v) =>
                              setDialogState(() => _resourceUploadTerm = v!),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              // FILE PICKER BUTTON
              OutlinedButton.icon(
                onPressed: () => _pickFile(setDialogState),
                icon: Icon(_isUploading ? Icons.upload : Icons.attach_file,
                    size: 18),
                label: Text(
                    _selectedFileName ?? 'Choose File (PDF, Word, Excel, PPT)',
                    style: GoogleFonts.poppins(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    side:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              if (_isUploading) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                    value: _uploadProgress / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.primary),
                const SizedBox(height: 4),
                Text('Uploading... ${_uploadProgress.toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
              if (_selectedFileName != null && !_isUploading) ...[
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.success, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                      child: Text('📎 $_selectedFileName',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.success)))
                ]),
              ],
              const SizedBox(height: 12),
              // Info Box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.info, color: AppColors.info, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(
                          'Supported: Book, Slide, PDF, Word, Excel, PPT, TXT, Lab Manual, Assignment, Previous Year Question',
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: AppColors.info))),
                ]),
              ),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel', style: GoogleFonts.poppins())),
            ElevatedButton.icon(
              onPressed: _isUploading
                  ? null
                  : () => _uploadResourceToSupabase(setDialogState, ctx),
              icon: const Icon(Icons.cloud_upload, size: 18),
              label: Text('Upload',
                  style: GoogleFonts.poppins(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoutineUploadDialog() => showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text('📅 Upload Routine',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: _routineTitleController,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  SizedBox(
                      width: 140,
                      child: _ddBox(
                          'Dept',
                          _routineUploadDept,
                          AppConstants.departments
                              .map((d) => d['name'].toString())
                              .toList(),
                          (v) =>
                              setDialogState(() => _routineUploadDept = v!))),
                  SizedBox(
                      width: 110,
                      child: _ddBox(
                          'Lvl',
                          _routineUploadLevel,
                          ['Level 1', 'Level 2', 'Level 3', 'Level 4'],
                          (v) =>
                              setDialogState(() => _routineUploadLevel = v!))),
                  SizedBox(
                      width: 110,
                      child: _ddBox(
                          'Term',
                          _routineUploadTerm,
                          ['Term I', 'Term II'],
                          (v) =>
                              setDialogState(() => _routineUploadTerm = v!))),
                  SizedBox(
                      width: 110,
                      child: _ddBox(
                          'Sec',
                          _routineUploadSection,
                          ['A', 'B', 'C'],
                          (v) => setDialogState(
                              () => _routineUploadSection = v!))),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final file = await _pickDialogFile(setDialogState);
                  if (file != null) {
                    setDialogState(() {
                      _pickedRoutineFile = file;
                      _routineFileName = file.name;
                    });
                  }
                },
                icon: const Icon(Icons.attach_file, size: 18),
                label: Text(_routineFileName ?? 'Choose Routine File',
                    style: GoogleFonts.poppins(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    side:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel', style: GoogleFonts.poppins())),
              ElevatedButton(
                  onPressed: _uploadRoutine,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child: Text('Upload',
                      style: GoogleFonts.poppins(color: Colors.white))),
            ],
          ),
        ),
      );

  void _showCTUploadDialog() => showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text('📝 Upload CT Question',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: _ctTitleController,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)))),
              const SizedBox(height: 10),
              TextField(
                  controller: _ctCourseController,
                  decoration: InputDecoration(
                      labelText: 'Course Code',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)))),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  SizedBox(
                      width: 140,
                      child: _ddBox(
                          'Dept',
                          _ctUploadDept,
                          AppConstants.departments
                              .map((d) => d['name'].toString())
                              .toList(),
                          (v) => setDialogState(() => _ctUploadDept = v!))),
                  SizedBox(
                      width: 110,
                      child: _ddBox(
                          'Lvl',
                          _ctUploadLevel,
                          ['Level 1', 'Level 2', 'Level 3', 'Level 4'],
                          (v) => setDialogState(() => _ctUploadLevel = v!))),
                  SizedBox(
                      width: 110,
                      child: _ddBox(
                          'Term',
                          _ctUploadTerm,
                          ['Term I', 'Term II'],
                          (v) => setDialogState(() => _ctUploadTerm = v!))),
                  SizedBox(
                      width: 110,
                      child: _ddBox('Sec', _ctUploadSection, ['A', 'B', 'C'],
                          (v) => setDialogState(() => _ctUploadSection = v!))),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final file = await _pickDialogFile(setDialogState);
                  if (file != null) {
                    setDialogState(() {
                      _pickedCTFile = file;
                      _ctFileName = file.name;
                    });
                  }
                },
                icon: const Icon(Icons.attach_file, size: 18),
                label: Text(_ctFileName ?? 'Choose CT File',
                    style: GoogleFonts.poppins(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    side:
                        const BorderSide(color: AppColors.warning, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel', style: GoogleFonts.poppins())),
              ElevatedButton(
                  onPressed: _uploadCTQuestion,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning),
                  child: Text('Upload',
                      style: GoogleFonts.poppins(color: Colors.white))),
            ],
          ),
        ),
      );

  // ============ HELPER WIDGETS ============
  Widget _upCard(
          IconData ic, String t, String s, Color c, VoidCallback tap) =>
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(ic, color: c, size: 28)),
              title: Text(t,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              subtitle: Text(s, style: GoogleFonts.poppins(fontSize: 12)),
              trailing: Icon(Icons.arrow_forward_ios, color: c, size: 18),
              onTap: tap));

  Widget _chip(String l, String v, List<String> o, Function(String) s) =>
      PopupMenuButton<String>(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onSelected: s,
          child: Chip(
              label: Text(v, style: GoogleFonts.poppins(fontSize: 10)),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1)),
          itemBuilder: (c) => o
              .map((x) => PopupMenuItem(
                  value: x,
                  child: Text(x, style: GoogleFonts.poppins(fontSize: 12))))
              .toList());

  Widget _dd(String l, String v, List<String> i, Function(String?) o) =>
      Expanded(
          child: DropdownButtonFormField<String>(
              initialValue: v,
              decoration: InputDecoration(
                  labelText: l,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
              items: i
                  .map((x) => DropdownMenuItem(
                      value: x,
                      child: Text(x, style: GoogleFonts.poppins(fontSize: 12))))
                  .toList(),
              onChanged: o));

  Widget _ddBox(String l, String v, List<String> i, Function(String?) o) =>
      DropdownButtonFormField<String>(
        initialValue: v,
        decoration: InputDecoration(
            labelText: l,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
        items: i
            .map((x) => DropdownMenuItem(
                value: x,
                child: Text(x, style: GoogleFonts.poppins(fontSize: 12))))
            .toList(),
        onChanged: o,
      );

  Color _dayColor(String d) {
    switch (d) {
      case 'Sun':
        return AppColors.primary;
      case 'Mon':
        return AppColors.info;
      case 'Tue':
        return AppColors.success;
      case 'Wed':
        return AppColors.warning;
      case 'Thu':
        return Colors.deepPurple;
      default:
        return AppColors.primary;
    }
  }

  Widget _dayHeader(String day) => Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8, top: 4),
      decoration: BoxDecoration(
          color: _dayColor(day.substring(0, 3)).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: _dayColor(day.substring(0, 3)).withValues(alpha: 0.3))),
      child: Row(children: [
        Icon(Icons.today, size: 16, color: _dayColor(day.substring(0, 3))),
        const SizedBox(width: 8),
        Text(day,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _dayColor(day.substring(0, 3))))
      ]));

  Widget _rRow(String time, String code, String sub, String room,
          {bool isBreak = false, bool isLab = false}) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            SizedBox(
                width: 110,
                child: Text(time,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isBreak ? AppColors.error : AppColors.primary))),
            Expanded(
                child: Text(code == '---' ? sub : '$code - $sub',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: isBreak
                            ? AppColors.error
                            : AppColors.textSecondary))),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: isBreak
                        ? AppColors.error.withValues(alpha: 0.1)
                        : isLab
                            ? AppColors.warning.withValues(alpha: 0.1)
                            : AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(room,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isBreak
                            ? AppColors.error
                            : isLab
                                ? AppColors.warning
                                : AppColors.success)))
          ]));

  Widget _ctRow(String w, String d, String c, String t) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(
            width: 60,
            child: Text(w,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w600))),
        SizedBox(
            width: 95,
            child: Text(d,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textSecondary))),
        Expanded(
            child: Text('$c - $t', style: GoogleFonts.poppins(fontSize: 12)))
      ]));

  String _icon(String t) {
    switch (t) {
      case 'Book':
        return '📘';
      case 'Slide':
        return '📊';
      case 'Class Note':
        return '📝';
      case 'Lab Manual':
        return '📗';
      case 'Assignment':
        return '📋';
      case 'Previous Year Question':
        return '📄';
      case 'Project Report':
        return '📑';
      case 'PPT':
        return '📙';
      case 'Excel':
        return '📈';
      case 'TXT':
        return '📃';
      case 'PDF':
        return '📕';
      default:
        return '📁';
    }
  }

  void _showEditRoutineDialog() {
    final t = TextEditingController(text: '8:00 - 08:50 AM'),
        c = TextEditingController(text: 'CSE 1101'),
        s = TextEditingController(text: 'English'),
        r = TextEditingController(text: 'Room 301');
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Row(children: [
                  const Icon(Icons.edit, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Edit Routine',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold))
                ]),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                      controller: t,
                      decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)))),
                  const SizedBox(height: 8),
                  TextField(
                      controller: c,
                      decoration: InputDecoration(
                          labelText: 'Course Code',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)))),
                  const SizedBox(height: 8),
                  TextField(
                      controller: s,
                      decoration: InputDecoration(
                          labelText: 'Subject',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)))),
                  const SizedBox(height: 8),
                  TextField(
                      controller: r,
                      decoration: InputDecoration(
                          labelText: 'Room',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))))
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('✅ Routine updated!'),
                                backgroundColor: AppColors.success));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                      child: Text('Save',
                          style: GoogleFonts.poppins(color: Colors.white)))
                ]));
  }
}
