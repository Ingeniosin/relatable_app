import 'package:flutter/material.dart';

class HerMessageBubble extends StatelessWidget {
  String message;
  String author;

  HerMessageBubble({super.key, required this.message, required this.author});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: colors.secondary, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$author:',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.left,
                ),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
