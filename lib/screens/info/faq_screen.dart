import 'package:flutter/material.dart';
import '../../models/faq_model.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = FAQModel.dummyFAQs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mga Madalas Itanong (FAQ)'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              title: Text(
                faq.question,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Text(
                    faq.answer,
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
