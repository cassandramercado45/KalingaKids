import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/chat_message_model.dart';

class AdminInboxScreen extends StatelessWidget {
  const AdminInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);

    // Group chat messages by unique parent emails
    final Set<String> parentEmails = {};
    final Map<String, String> parentNames = {};
    final Map<String, String> parentBarangays = {};
    final Map<String, ChatMessage> lastMessages = {};

    for (var msg in appState.chatMessages) {
      final isFromAdmin = msg.senderEmail == 'admin';
      final parentEmail = isFromAdmin ? msg.recipientEmail : msg.senderEmail;
      
      parentEmails.add(parentEmail);
      if (!isFromAdmin) {
        parentNames[parentEmail] = msg.senderName;
        parentBarangays[parentEmail] = msg.barangay;
      }
      
      // Update last message
      final existingLast = lastMessages[parentEmail];
      if (existingLast == null || msg.date.isAfter(existingLast.date)) {
        lastMessages[parentEmail] = msg;
      }
    }

    final threads = parentEmails.toList();

    return Scaffold(
      body: threads.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 72,
                      color: theme.colorScheme.primary.withAlpha(102),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Walang Aktibong Chat',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ang mga mensahe mula sa magulang sa Kalinga Chatbot ay lilitaw rito upang masagot ninyo nang isa-isa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              itemCount: threads.length,
              itemBuilder: (context, index) {
                final email = threads[index];
                final name = parentNames[email] ?? 'Magulang';
                final brgy = parentBarangays[email] ?? 'Sabang';
                final lastMsg = lastMessages[email];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'M',
                        style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            brgy,
                            style: TextStyle(fontSize: 10, color: theme.colorScheme.onSecondaryContainer, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        lastMsg != null
                            ? (lastMsg.senderEmail == 'admin' ? 'BHW: ${lastMsg.text}' : lastMsg.text)
                            : 'Magsimula ng chat...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminChatDetailScreen(
                            parentEmail: email,
                            parentName: name,
                            parentBarangay: brgy,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class AdminChatDetailScreen extends StatefulWidget {
  final String parentEmail;
  final String parentName;
  final String parentBarangay;

  const AdminChatDetailScreen({
    super.key,
    required this.parentEmail,
    required this.parentName,
    required this.parentBarangay,
  });

  @override
  State<AdminChatDetailScreen> createState() => _AdminChatDetailScreenState();
}

class _AdminChatDetailScreenState extends State<AdminChatDetailScreen> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.position.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sendReply(AppState appState) async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    await appState.sendChatMessage(
      senderEmail: 'admin',
      senderName: 'BHW ng ${widget.parentBarangay}',
      recipientEmail: widget.parentEmail,
      text: text,
      barangay: widget.parentBarangay,
    );

    _replyController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);

    // Filter chat messages between admin and this specific parent
    final chatHistory = appState.chatMessages.where((m) =>
        m.senderEmail == widget.parentEmail || m.recipientEmail == widget.parentEmail).toList();

    if (chatHistory.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.parentName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Barangay ${widget.parentBarangay} • ${widget.parentEmail}', style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat bubbles
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final msg = chatHistory[index];
                final isAdmin = msg.senderEmail == 'admin';

                return Align(
                  alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isAdmin ? theme.colorScheme.primaryContainer : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isAdmin ? 16 : 0),
                        bottomRight: Radius.circular(isAdmin ? 0 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: isAdmin ? theme.colorScheme.onPrimaryContainer : Colors.black87,
                            fontSize: 14.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message input bar
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
                    controller: _replyController,
                    onSubmitted: (_) => _sendReply(appState),
                    decoration: InputDecoration(
                      hintText: 'Sumulat ng sagot sa magulang...',
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
                    onPressed: () => _sendReply(appState),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
