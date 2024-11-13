import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class StoryListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int time;

  const StoryListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null)
                      GestureDetector(
                        onTap: () {
                          context.push("/user?id=$subtitle");
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              subtitle ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    Text(
                      DateFormat.yMMMMd().format(
                          DateTime.fromMillisecondsSinceEpoch(time * 1000)),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
