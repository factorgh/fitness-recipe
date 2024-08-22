import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/trainer_profile_screen.dart';

class AllTrainersScreen extends ConsumerWidget {
  const AllTrainersScreen({super.key});
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.black87),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to peform a delete?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Perform the delete action
                Navigator.of(context).pop(); // Close the dialog
                // You can call a function here to delete the item
                // For example: _deleteItem();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: const SizedBox(),
        centerTitle: true,
        title: const Text("All Trainers"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Trainers you follow",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                  Icon(Icons.filter_list),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TrainerProfileScreen()));
              },
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg?auto=compress&cs=tinysrgb&w=800"),
                    ),
                    title: const Text("Albert M."),
                    subtitle: const Text("+1 234 45672"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDeleteConfirmationDialog(context);
                      },
                      child: const Text("Remove"),
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TrainerProfileScreen()));
              },
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://images.pexels.com/photos/343717/pexels-photo-343717.jpeg?auto=compress&cs=tinysrgb&w=800"),
                    ),
                    title: const Text("Will S."),
                    subtitle: const Text("+1 234 45672"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDeleteConfirmationDialog(context);
                      },
                      child: const Text("Remove"),
                    )),
              ),
            )
          ],
        ),
      )),
    );
  }
}
