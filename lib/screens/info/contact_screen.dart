import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/chat_message_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late String _userBarangay;
  late String _userEmail;
  late String _userName;

  // Predefined Q&A map
  final Map<String, String> _cannedReplies = {
    'kailan dapat pabakunahan ang sanggol?': 
        'Ang mga unang bakuna tulad ng BCG at Hepatitis B ay ibinibigay pagkapanganak. Ang iba pang mahalagang bakuna (gaya ng Pentavalent at Polio) ay ibinibigay sa ika-6, 10, at 14 na linggo ng sanggol.',
    'paano malalaman kung kulang sa timbang ang bata?': 
        'Maaari mong makita ang katayuan (BMI at Timbang) ng iyong anak sa Profile at Growth Monitoring tabs. Kung ang status nito ay "Kulang sa Timbang (Wasted)", inirerekomenda na kumunsulta agad sa Barangay Health Center.',
    'ano ang tamang nutrisyon para sa bata?': 
        'Para sa bata, mahalaga ang balanseng pagkain na may Go, Grow, at Glow foods. Basahin ang ating "Gabay sa Nutrisyon" tab para sa mga masusustansyang recipe at tips.',
    'ano ang layunin ng kalingakids?': 
        'Ang KalingaKids ay binuo upang maging katuwang ng mga magulang sa Barangay sa madaliang pagsubaybay ng bakuna, milestones, at kalusugan ng bata.',
  };

  final List<String> _quickQuestions = [
    'Sino ang BHW sa aking Barangay?',
    'Kailan dapat pabakunahan ang sanggol?',
    'Paano malalaman kung kulang sa timbang?',
    'Ano ang tamang nutrisyon para sa bata?',
    'Ano ang layunin ng KalingaKids?',
  ];

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getBhwName(String barangay) {
    if (barangay.startsWith('A')) return 'BHW Anita Gomez';
    if (barangay.startsWith('B')) return 'BHW Beatrice Lopez';
    if (barangay.startsWith('C')) return 'BHW Carmelita Mercado';
    if (barangay.startsWith('D')) return 'BHW Dolores Santos';
    if (barangay.startsWith('G')) return 'BHW Gloria Perez';
    if (barangay.startsWith('L')) return 'BHW Lourdes Reyes';
    if (barangay.startsWith('N')) return 'BHW Nelia Castillo';
    if (barangay.startsWith('P')) return 'BHW Patricia Reyes';
    if (barangay.startsWith('S')) return 'BHW Susan Dela Cruz';
    if (barangay.startsWith('T')) return 'BHW Teresa Tugtug';
    return 'BHW Elena Diaz';
  }

  void _sendMessage(AppState appState, String text) async {
    if (text.trim().isEmpty) return;

    // Send user message
    await appState.sendChatMessage(
      senderEmail: _userEmail,
      senderName: _userName,
      recipientEmail: 'admin',
      text: text,
      barangay: _userBarangay,
    );
    
    _scrollToBottom();
    _msgController.clear();

    // Check if it's an FAQ and trigger auto chatbot reply
    final normalizedQuery = text.trim().toLowerCase();
    
    Future.delayed(const Duration(milliseconds: 600), () async {
      if (!mounted) return;

      String? botResponse;

      if (normalizedQuery.contains('bhw') || 
          normalizedQuery.contains('health worker') || 
          normalizedQuery.contains('sino ang bhw') || 
          normalizedQuery.contains('sino ang bhw sa aking barangay?')) {
        final bhwName = _getBhwName(_userBarangay);
        botResponse = 'Ang nakatalagang Barangay Health Worker (BHW) sa Barangay $_userBarangay ay si **$bhwName**. Maaari mo silang mabisita sa $_userBarangay Health Center tuwing Lunes hanggang Biyernes, 8:00 AM - 5:00 PM.';
      } else {
        // Check standard canned answers
        _cannedReplies.forEach((key, value) {
          if (normalizedQuery.contains(key) || key.contains(normalizedQuery)) {
            botResponse = value;
          }
        });
      }

      if (botResponse != null) {
        await appState.sendChatMessage(
          senderEmail: 'admin',
          senderName: 'KalingaBot',
          recipientEmail: _userEmail,
          text: botResponse!,
          barangay: _userBarangay,
        );
        _scrollToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    _userBarangay = appState.userBarangay;
    _userEmail = appState.userEmail.isEmpty ? 'magulang.demo@gmail.com' : appState.userEmail;
    _userName = appState.userName.isEmpty ? 'Magulang' : appState.userName;

    // Filter messages for this specific parent
    final myMessages = appState.chatMessages.where((m) =>
        m.senderEmail == _userEmail || m.recipientEmail == _userEmail).toList();

    // Scroll to bottom after building if there are messages
    if (myMessages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalinga Chatbot'),
      ),
      body: Column(
        children: [
          // Info header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.primaryContainer.withAlpha(50),
            child: Row(
              children: [
                Icon(Icons.smart_toy_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Kausapin ang KalingaBot o ang inyong Barangay Health Worker (BHW) dito.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          
          // Chat messages list
          Expanded(
            child: myMessages.isEmpty
                ? _buildEmptyChatGreeting(theme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: myMessages.length,
                    itemBuilder: (context, index) {
                      final msg = myMessages[index];
                      return _buildChatBubble(theme, msg);
                    },
                  ),
          ),

          // Quick questions bar
          Container(
            height: 48,
            color: theme.colorScheme.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _quickQuestions.length,
              itemBuilder: (context, index) {
                final question = _quickQuestions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                  child: ActionChip(
                    label: Text(
                      question,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                    ),
                    backgroundColor: theme.colorScheme.primaryContainer.withAlpha(51),
                    onPressed: () => _sendMessage(appState, question),
                  ),
                );
              },
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                )
              ]
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    onSubmitted: (text) => _sendMessage(appState, text),
                    decoration: InputDecoration(
                      hintText: 'Itanong mo kay KalingaBot...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _sendMessage(appState, _msgController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatGreeting(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 36,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.smart_toy_outlined, size: 36, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Magandang araw! Ako si KalingaBot',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'ang inyong katuwang sa kalusugan ng inyong anak dito sa Barangay $_userBarangay. Maaari kayong magtanong tungkol sa bakuna, timbang, o milestones ng bata, o sumulat sa inyong BHW.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ThemeData theme, ChatMessage msg) {
    final isBotOrAdmin = msg.senderEmail == 'admin';
    return Align(
      alignment: isBotOrAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isBotOrAdmin 
              ? (msg.senderName == 'KalingaBot' ? Colors.grey.shade100 : theme.colorScheme.primary.withAlpha(26))
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isBotOrAdmin ? 0 : 16),
            bottomRight: Radius.circular(isBotOrAdmin ? 16 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBotOrAdmin)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  msg.senderName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: msg.senderName == 'KalingaBot' ? Colors.blue.shade700 : Colors.teal.shade700,
                  ),
                ),
              ),
            Text(
              msg.text,
              style: TextStyle(
                color: isBotOrAdmin ? Colors.black87 : theme.colorScheme.onPrimaryContainer,
                fontSize: 14.5,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
