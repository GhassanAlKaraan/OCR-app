import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3), // Optional: Set the duration
      // action: SnackBarAction(label: 'Close', onPressed: () {}),
    ),
  );
}

Future<void> showAlert(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      const Color(0xff214183), // Change the button text color
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // Make the button text bold
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

Future<void> showAlertDialog(
    BuildContext context, VoidCallback customFunction, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevents closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
        title: Text(message),
        content: const Text(
          'Are you sure?',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff214183),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff214183),
                  ),
                ),
                onPressed: () {
                  // Add your OK button action here
                  customFunction();
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          )
        ],
      );
    },
  );
}

Future<void> showInfoDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevents closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text(
                  "I don't care",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff214183),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  showSnackBar(context, "Me neither");
                },
              ),
              TextButton(
                child: const Text(
                  'Cool',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff214183),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
