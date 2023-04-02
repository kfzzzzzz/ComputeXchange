import 'package:flutter/material.dart';

class ErrorLoadingWidget extends StatelessWidget {
  final String message;
  final Function? onRetryPressed;

  const ErrorLoadingWidget({required this.message, this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 16),
          if (onRetryPressed != null)
            ElevatedButton(
              onPressed: () => onRetryPressed!(),
              child: Text('Retry'),
            ),
        ],
      ),
    );
  }
}
