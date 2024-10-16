// ignore_for_file: unused_element

import 'dart:async';

import 'package:fit_cibus/Features/trainer/trainer_service.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/trainer_profile_screen.dart';
import 'package:fit_cibus/services/email_service.dart';
import 'package:fit_cibus/utils/native_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainerSearchScreen extends ConsumerStatefulWidget {
  const TrainerSearchScreen({super.key});

  @override
  _TrainerSearchScreenState createState() => _TrainerSearchScreenState();
}

class _TrainerSearchScreenState extends ConsumerState<TrainerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<User> _trainers = [];
  bool _isLoading = false;
  String? _error;

  final TrainerService _trainerService =
      TrainerService(); // Instantiate your service directly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'Search Trainer',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search trainers...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _trainers.isEmpty
                          ? const Center(
                              child: Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'No trainers found.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    'Enter a trainer name to search.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ))
                          : ListView.builder(
                              itemCount: _trainers.length,
                              itemBuilder: (context, index) {
                                final trainer = _trainers[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TrainerProfileScreen(
                                                  userId: trainer.id,
                                                )));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 2.0,
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.all(16.0),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: trainer.imageUrl !=
                                                null
                                            ? NetworkImage(trainer.imageUrl!)
                                            : const AssetImage(
                                                    'assets/images/default_profile.png')
                                                as ImageProvider,
                                      ),
                                      title: Text(
                                        trainer.fullName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(trainer.email),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadAllTrainers();
  }

  Future<void> _loadAllTrainers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final trainers =
          await _trainerService.getAllTrainers(); // Fetch all trainers
      setState(() {
        _trainers = trainers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load trainers: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchTrainers(query);
    });
  }

  Future<void> _searchTrainers(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<User> trainers;
      if (query.isEmpty) {
        trainers = await _trainerService
            .getAllTrainers(); // Fetch all trainers if query is empty
      } else {
        trainers = await _trainerService.searchTrainers(query);
      }

      setState(() {
        _trainers = trainers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load trainers: $e';
        _isLoading = false;
      });
    }
  }

  void _showTrainerDetails(
    BuildContext context,
    String name,
    String email,
    String image,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: image.isNotEmpty
                            ? NetworkImage(image)
                            : const AssetImage(
                                'assets/images/default_avatar.png'),
                      ),
                      const Positioned(
                        top: 50,
                        left: 60,
                        child: Icon(Icons.lock),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(email),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Your request logic here
                      EmailService()
                          .sendEmail(ref.read(userProvider)!.id, email);
                      Navigator.of(context).pop();
                      NativeAlerts().showSuccessAlert(
                          context, "Request sent successfully");
                    },
                    child: const Text("Send Request"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
