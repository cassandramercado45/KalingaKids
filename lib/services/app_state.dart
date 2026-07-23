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

  AppState() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load Login Session
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    _userName = _prefs.getString('userName') ?? '';
    _userEmail = _prefs.getString('userEmail') ?? '';
    _userBarangay = _prefs.getString('userBarangay') ?? 'Sabang';

    // Load Dark Mode Preference
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;

    // Load Children list
    final childrenJson = _prefs.getString('childrenList');
    if (childrenJson != null) {
      try {
        final decoded = jsonDecode(childrenJson) as List;
        _children = decoded.map((e) => ChildModel.fromJson(e)).toList();
        // Remove default mock children for clean presentation
        _children.removeWhere((c) => c.id == 'c1' || c.id == 'c2' || c.id == 'c3');
      } catch (_) {
        _children = [];
      }
    }

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
      } catch (_) {}
    }

    // Load Completed Milestones
    final milestonesJson = _prefs.getString('completedMilestones');
    if (milestonesJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(milestonesJson);
        _completedMilestones = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
      } catch (_) {}
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
    }

    _isInitialized = true;
    notifyListeners();
  }

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isDarkMode => _isDarkMode;
  List<ChildModel> get children => _children;
  String? get selectedChildId => _selectedChildId;
  List<FeedbackModel> get feedbacks => _feedbacks;
  bool get isAdmin => _userEmail == 'admin@kalingakids.com' || _userEmail == 'admin@gmail.com';
  String get userBarangay => _userBarangay;

  ChildModel? get selectedChild {
    if (_selectedChildId == null || _selectedChildId!.isEmpty || _children.isEmpty) {
      return null;
    }
    return _children.firstWhere(
      (c) => c.id == _selectedChildId,
      orElse: () => _children.first,
    );
  }

  // Authentication
  Future<bool> login(String email, String password) async {
    // Basic mock authentication simulating Facebook style login
    if (email.contains('@') && password.length >= 6) {
      _isLoggedIn = true;
      _userName = email.split('@')[0].toUpperCase();
      _userEmail = email;
      
      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('userName', _userName);
      await _prefs.setString('userEmail', _userEmail);
      
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

    notifyListeners();
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

    await _prefs.clear();
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
