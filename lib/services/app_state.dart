import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_model.dart';
import '../models/feedback_model.dart';
import '../models/chat_message_model.dart';

const List<String> kBarangays = [
  'Aguila',
  'Anus',
  'Aya',
  'Bagong Pook',
  'Balagtasin',
  'Balagtasin I',
  'Banay-Banay I',
  'Banay-Banay II',
  'Bigain I',
  'Bigain II',
  'Bigain South',
  'Calansayan',
  'Dagatan',
  'Don Luis',
  'Galamay-Amo',
  'Lalayat',
  'Lapolapo I',
  'Lapolapo II',
  'Lepote',
  'Lumil',
  'Mojon-Tampoy',
  'Natunuan',
  'Palanca',
  'Pinagtung-Ulan',
  'Poblacion Barangay I',
  'Poblacion Barangay II',
  'Poblacion Barangay III',
  'Poblacion Barangay IV',
  'Sabang',
  'Salaban',
  'Santo Cristo',
  'Taysan',
  'Tugtug',
];

class AppState with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Session State
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userBarangay = 'Sabang';

  // Preferences
  bool _isDarkMode = false;

  // Child Data
  List<ChildModel> _children = [];
  String? _selectedChildId;

  // Progress Tracker Map (ChildID -> List of Vaccine/Milestone IDs)
  Map<String, List<String>> _completedVaccines = {};
  Map<String, List<String>> _completedMilestones = {};

  // Feedback Messages
  List<FeedbackModel> _feedbacks = [];

  // Chat Messages
  List<ChatMessage> _chatMessages = [];
  List<ChatMessage> get chatMessages => _chatMessages;

  // Registered Parents Profiles List
  List<Map<String, String>> _registeredParents = [];

  AppState() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    
    // One-time clear of dummy/mock data to start fresh as requested by user
    if (!(_prefs.getBool('didClearDummyDataV4') ?? false)) {
      await _prefs.remove('childrenList');
      await _prefs.remove('registeredParents');
      await _prefs.remove('completedVaccines');
      await _prefs.remove('completedMilestones');
      await _prefs.remove('selectedChildId');
      
      // Reset session state
      await _prefs.setBool('isLoggedIn', false);
      await _prefs.remove('userName');
      await _prefs.remove('userEmail');
      await _prefs.remove('userBarangay');
      
      _isLoggedIn = false;
      _userName = '';
      _userEmail = '';
      _userBarangay = 'Sabang';
      _selectedChildId = null;

      await _prefs.setBool('didClearDummyDataV4', true);
    } else {
      // Load Login Session
      _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
      _userName = _prefs.getString('userName') ?? '';
      _userEmail = _prefs.getString('userEmail') ?? '';
      _userBarangay = _prefs.getString('userBarangay') ?? 'Sabang';
    }

    // Load Dark Mode Preference
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;

    // Load User and Children Database
    await _loadUserDataFromPrefs();

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadUserDataFromPrefs() async {
    // Load Children list
    final childrenJson = _prefs.getString('childrenList');
    if (childrenJson != null) {
      try {
        final decoded = jsonDecode(childrenJson) as List;
        _children = decoded.map((e) => ChildModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      } catch (err, stack) {
        debugPrint('Error loading children from SharedPreferences: $err\n$stack');
        _children = [];
      }
    } else {
      _children = [];
    }

    // Removed default children pre-population to prevent confusion

    _selectedChildId = _prefs.getString('selectedChildId');
    if (_children.isNotEmpty) {
      if (_selectedChildId == null || !_children.any((c) => c.id == _selectedChildId)) {
        _selectedChildId = _children.first.id;
      }
    } else {
      _selectedChildId = null;
    }

    // Load Completed Vaccines
    final vaccinesJson = _prefs.getString('completedVaccines');
    if (vaccinesJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(vaccinesJson);
        _completedVaccines = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
      } catch (_) {
        _completedVaccines = {};
      }
    } else {
      _completedVaccines = {};
    }

    // Ensure default children have their pre-populated vaccines
    bool changedVaccines = false;
    final defaultVaccines = {
      'c1': ['v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12', 'v13'],
      'c2': ['v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12', 'v13', 'v14'],
      'c3': ['v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7', 'v8', 'v9', 'v10', 'v11', 'v12', 'v13', 'v14', 'v15', 'v16'],
    };
    for (var entry in defaultVaccines.entries) {
      if (!_completedVaccines.containsKey(entry.key)) {
        _completedVaccines[entry.key] = entry.value;
        changedVaccines = true;
      }
    }
    if (changedVaccines) {
      await _prefs.setString('completedVaccines', jsonEncode(_completedVaccines));
    }

    // Load Completed Milestones
    final milestonesJson = _prefs.getString('completedMilestones');
    if (milestonesJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(milestonesJson);
        _completedMilestones = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
      } catch (_) {
        _completedMilestones = {};
      }
    } else {
      _completedMilestones = {};
    }

    // Ensure default children have their pre-populated milestones
    bool changedMilestones = false;
    final defaultMilestones = {
      'c1': ['m1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8'],
      'c2': ['m1', 'm2', 'm3', 'm4', 'm5', 'm6', 'm7', 'm8', 'm9', 'm10', 'm11', 'm12', 'm13', 'm14', 'm15', 'm16', 'm17', 'm18', 'm19', 'm20'],
      'c3': List.generate(37, (i) => 'm${i + 1}'),
    };
    for (var entry in defaultMilestones.entries) {
      if (!_completedMilestones.containsKey(entry.key)) {
        _completedMilestones[entry.key] = entry.value;
        changedMilestones = true;
      }
    }
    if (changedMilestones) {
      await _prefs.setString('completedMilestones', jsonEncode(_completedMilestones));
    }

    // Load Feedback Messages
    final feedbacksJson = _prefs.getString('feedbacksList');
    if (feedbacksJson != null) {
      try {
        final decoded = jsonDecode(feedbacksJson) as List;
        _feedbacks = decoded.map((e) => FeedbackModel.fromJson(e)).toList();
      } catch (_) {
        _feedbacks = [];
      }
    } else {
      _feedbacks = [];
    }

    // Load Chat Messages
    final chatMessagesJson = _prefs.getString('chatMessagesList');
    if (chatMessagesJson != null) {
      try {
        final decoded = jsonDecode(chatMessagesJson) as List;
        _chatMessages = decoded.map((e) => ChatMessage.fromJson(e)).toList();
      } catch (_) {
        _chatMessages = [];
      }
    } else {
      _chatMessages = [];
    }

    // Load Registered Parents list
    final parentsJson = _prefs.getString('registeredParents');
    if (parentsJson != null) {
      try {
        final decoded = jsonDecode(parentsJson) as List;
        _registeredParents = decoded.map((e) => Map<String, String>.from(e as Map)).toList();
      } catch (_) {
        _registeredParents = [];
      }
    } else {
      _registeredParents = [];
    }

    // Removed default parents pre-population to prevent confusion
  }

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isDarkMode => _isDarkMode;
  List<ChildModel> get children {
    if (isAdmin || !_isLoggedIn) {
      return _children;
    } else {
      return _children.where((c) => c.parentEmail == _userEmail).toList();
    }
  }
  List<Map<String, String>> get registeredParents => _registeredParents;
  String? get selectedChildId => _selectedChildId;
  List<FeedbackModel> get feedbacks => _feedbacks;
  bool get isAdmin => _userEmail == 'admin@kalingakids.com' || _userEmail == 'admin@gmail.com';
  String get userBarangay => _userBarangay;

  ChildModel? get selectedChild {
    final list = children;
    if (_selectedChildId == null || _selectedChildId!.isEmpty || list.isEmpty) {
      return null;
    }
    return list.firstWhere(
      (c) => c.id == _selectedChildId,
      orElse: () => list.first,
    );
  }

  // Authentication
  Future<bool> login(String email, String password) async {
    // Basic mock authentication simulating Facebook style login
    if (email.contains('@') && password.length >= 6) {
      _isLoggedIn = true;
      _userEmail = email;

      final bool isLoggingInAsAdmin = email == 'admin@kalingakids.com' || email == 'admin@gmail.com';

      if (isLoggingInAsAdmin) {
        _userName = 'ADMIN';
        _userBarangay = 'Sabang';
      } else {
        // Look up parent's registered record to get their actual registered barangay and name
        final parentIndex = _registeredParents.indexWhere((p) => p['email'] == email);
        if (parentIndex != -1) {
          _userName = _registeredParents[parentIndex]['name'] ?? email.split('@')[0].toUpperCase();
          _userBarangay = _registeredParents[parentIndex]['barangay'] ?? 'Sabang';
        } else {
          _userName = email.split('@')[0].toUpperCase();
          _userBarangay = 'Sabang';
          
          // Add them to registered parents list so they exist and don't get lost
          _registeredParents.add({
            'email': email,
            'name': _userName,
            'barangay': _userBarangay,
          });
          await _saveParentsToPrefs();
        }
      }
      
      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('userName', _userName);
      await _prefs.setString('userEmail', _userEmail);
      await _prefs.setString('userBarangay', _userBarangay);

      // Reload database from prefs
      await _loadUserDataFromPrefs();
      
      notifyListeners();
      return true;
    }
    return false;
  }

  // Feedback Management
  Future<void> addFeedback(String name, String email, String message) async {
    final newFeedback = FeedbackModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      message: message,
      date: DateTime.now(),
    );
    _feedbacks.add(newFeedback);
    notifyListeners();
    await _saveFeedbacks();
  }

  Future<void> clearFeedbacks() async {
    _feedbacks.clear();
    notifyListeners();
    await _saveFeedbacks();
  }

  Future<void> _saveFeedbacks() async {
    final encoded = jsonEncode(_feedbacks.map((f) => f.toJson()).toList());
    await _prefs.setString('feedbacksList', encoded);
  }

  Future<void> sendChatMessage({
    required String senderEmail,
    required String senderName,
    required String recipientEmail,
    required String text,
    required String barangay,
  }) async {
    final newMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderEmail: senderEmail,
      senderName: senderName,
      recipientEmail: recipientEmail,
      text: text,
      date: DateTime.now(),
      barangay: barangay,
    );
    _chatMessages.add(newMsg);
    notifyListeners();
    await _saveChatMessages();
  }

  Future<void> clearChatMessages() async {
    _chatMessages.clear();
    notifyListeners();
    await _saveChatMessages();
  }

  Future<void> _saveChatMessages() async {
    final encoded = jsonEncode(_chatMessages.map((m) => m.toJson()).toList());
    await _prefs.setString('chatMessagesList', encoded);
  }

  Future<void> register(String name, String email, String password, String barangay) async {
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _userBarangay = barangay;

    await _prefs.setBool('isLoggedIn', true);
    await _prefs.setString('userName', _userName);
    await _prefs.setString('userEmail', _userEmail);
    await _prefs.setString('userBarangay', _userBarangay);

    // Save to registered parents list
    if (!_registeredParents.any((p) => p['email'] == email)) {
      _registeredParents.add({
        'email': email,
        'name': name,
        'barangay': barangay,
      });
      await _saveParentsToPrefs();
    }

    // Reload database from prefs
    await _loadUserDataFromPrefs();

    notifyListeners();
  }

  Future<void> _saveParentsToPrefs() async {
    await _prefs.setString('registeredParents', jsonEncode(_registeredParents));
  }

  Future<void> updateBarangay(String newBarangay) async {
    _userBarangay = newBarangay;
    await _prefs.setString('userBarangay', newBarangay);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _userBarangay = 'Sabang';
    _selectedChildId = null;
    _children = [];
    _completedVaccines = {};
    _completedMilestones = {};

    await _prefs.setBool('isLoggedIn', false);
    await _prefs.remove('userName');
    await _prefs.remove('userEmail');
    await _prefs.remove('userBarangay');
    await _prefs.remove('selectedChildId');

    notifyListeners();
  }

  // Toggle Dark Mode
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  // Select Active Child
  Future<void> selectChild(String childId) async {
    _selectedChildId = childId;
    await _prefs.setString('selectedChildId', childId);
    notifyListeners();
  }

  // Add Child
  Future<void> addChild(String name, DateTime birthDate, String gender, String bloodType, double height, double weight) async {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final firstRecord = GrowthRecord(
      id: '${DateTime.now().millisecondsSinceEpoch}_gr',
      date: DateTime.now(),
      height: height,
      weight: weight,
    );

    final child = ChildModel(
      id: newId,
      name: name,
      birthDate: birthDate,
      gender: gender,
      bloodType: bloodType,
      growthHistory: [firstRecord],
      barangay: _userBarangay,
      parentEmail: _userEmail.isEmpty ? 'magulang.demo@gmail.com' : _userEmail,
    );

    _children.add(child);
    _selectedChildId = newId;
    
    await _saveChildrenToPrefs();
    await _prefs.setString('selectedChildId', newId);
    notifyListeners();
  }

  // Add Growth Record to Active Child
  Future<void> addGrowthRecord(String childId, double height, double weight) async {
    final index = _children.indexWhere((c) => c.id == childId);
    if (index != -1) {
      final newRecord = GrowthRecord(
        id: '${DateTime.now().millisecondsSinceEpoch}_gr',
        date: DateTime.now(),
        height: height,
        weight: weight,
      );
      final updatedHistory = List<GrowthRecord>.from(_children[index].growthHistory)..add(newRecord);
      _children[index] = _children[index].copyWith(growthHistory: updatedHistory);
      
      await _saveChildrenToPrefs();
      notifyListeners();
    }
  }

  // Edit Active Child Profile
  Future<void> editChildProfile(String childId, String name, DateTime birthDate, String gender, String bloodType) async {
    final index = _children.indexWhere((c) => c.id == childId);
    if (index != -1) {
      _children[index] = _children[index].copyWith(
        name: name,
        birthDate: birthDate,
        gender: gender,
        bloodType: bloodType,
      );
      await _saveChildrenToPrefs();
      notifyListeners();
    }
  }

  Future<void> deleteChild(String childId) async {
    _children.removeWhere((c) => c.id == childId);
    _completedVaccines.remove(childId);
    _completedMilestones.remove(childId);

    if (_selectedChildId == childId) {
      _selectedChildId = _children.isNotEmpty ? _children.first.id : null;
    }
    
    await _saveChildrenToPrefs();
    await _prefs.setString('selectedChildId', _selectedChildId ?? '');
    await _prefs.setString('completedVaccines', jsonEncode(_completedVaccines));
    await _prefs.setString('completedMilestones', jsonEncode(_completedMilestones));
    
    notifyListeners();
  }

  Future<void> _saveChildrenToPrefs() async {
    final jsonList = _children.map((e) => e.toJson()).toList();
    await _prefs.setString('childrenList', jsonEncode(jsonList));
  }

  // Vaccines Completed List
  List<String> getCompletedVaccines(String childId) {
    return _completedVaccines[childId] ?? [];
  }

  Future<void> toggleVaccine(String childId, String vaccineId) async {
    final list = _completedVaccines[childId] ?? [];
    if (list.contains(vaccineId)) {
      list.remove(vaccineId);
    } else {
      list.add(vaccineId);
    }
    _completedVaccines[childId] = list;
    await _prefs.setString('completedVaccines', jsonEncode(_completedVaccines));
    notifyListeners();
  }

  // Milestones Completed List
  List<String> getCompletedMilestones(String childId) {
    return _completedMilestones[childId] ?? [];
  }

  Future<void> toggleMilestone(String childId, String milestoneId) async {
    final list = _completedMilestones[childId] ?? [];
    if (list.contains(milestoneId)) {
      list.remove(milestoneId);
    } else {
      list.add(milestoneId);
    }
    _completedMilestones[childId] = list;
    await _prefs.setString('completedMilestones', jsonEncode(_completedMilestones));
    notifyListeners();
  }
}
