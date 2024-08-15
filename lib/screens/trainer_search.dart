import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/providers/search_provider.dart';

// Replace StatefullWidget with ConsumerWidget to use Riverpod
class TrainerSearchScreen extends ConsumerWidget {
  TrainerSearchScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchTrainersProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Search Trainers'),
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
                    onChanged: (query) {
                      // Trigger search when the user types in the search field
                      ref
                          .read(searchTrainersProvider.notifier)
                          .searchTrainers(query);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    // Add your sorting logic here
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchState.when(
                data: (trainers) => ListView.builder(
                  itemCount: trainers.length,
                  itemBuilder: (context, index) {
                    final trainer = trainers[index];
                    return GestureDetector(
                      onTap: () {
                        _showTrainerDetails(
                          context,
                          trainer.fullName,
                          trainer.email,
                          trainer.imageUrl ??
                              'assets/images/default_avatar.png',
                          ref,
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 2.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: trainer.imageUrl != null
                                ? NetworkImage(trainer.imageUrl!)
                                : const AssetImage(
                                        'assets/images/default_avatar.png')
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrainerDetails(
    BuildContext context,
    String name,
    String email,
    String image,
    WidgetRef ref,
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
                      ref.read(requestProvider.notifier).sendRequest("", "");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request sent successfully!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.brown,
                        ),
                      );
                      Navigator.of(context).pop();
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
