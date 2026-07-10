import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

// Mock child profile provider - replace with actual API
final childProfilesProvider = StateProvider<List<ChildProfile>>((ref) => []);

class ChildProfile {
  final String id;
  final String name;
  final int age;
  final Color color;

  ChildProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.color,
  });
}

class ChildProfilesScreen extends ConsumerWidget {
  const ChildProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Profiles'),
        backgroundColor: const Color(0xFF6B4CE6),
        foregroundColor: Colors.white,
      ),
      body: children.isEmpty
          ? _buildEmptyState(context, ref)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...children.map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildChildCard(child, context, ref),
                    )),
                const SizedBox(height: 12),
                _buildAddChildButton(context, ref),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'No Child Profiles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first child profile to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddChildDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Child Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4CE6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard(ChildProfile child, BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: child.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                child.name[0],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: child.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${child.age} years old',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditChildDialog(context, ref, child),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, ref, child),
          ),
        ],
      ),
    );
  }

  Widget _buildAddChildButton(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => _showAddChildDialog(context, ref),
      icon: const Icon(Icons.add),
      label: const Text('Add Child Profile'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        side: const BorderSide(color: Color(0xFF6B4CE6)),
        foregroundColor: const Color(0xFF6B4CE6),
      ),
    );
  }

  void _showAddChildDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    Color selectedColor = Colors.pink;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Child Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color: '),
                  ...[ Colors.pink, Colors.blue, Colors.green, Colors.orange, Colors.purple]
                      .map((color) => GestureDetector(
                            onTap: () => setState(() => selectedColor = color),
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          )),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
                  final children = ref.read(childProfilesProvider);
                  ref.read(childProfilesProvider.notifier).state = [
                    ...children,
                    ChildProfile(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      age: int.tryParse(ageController.text) ?? 0,
                      color: selectedColor,
                    ),
                  ];
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4CE6),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditChildDialog(BuildContext context, WidgetRef ref, ChildProfile child) {
    final nameController = TextEditingController(text: child.name);
    final ageController = TextEditingController(text: child.age.toString());
    Color selectedColor = child.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Child Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color: '),
                  ...[Colors.pink, Colors.blue, Colors.green, Colors.orange, Colors.purple]
                      .map((color) => GestureDetector(
                            onTap: () => setState(() => selectedColor = color),
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          )),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
                  final children = ref.read(childProfilesProvider);
                  ref.read(childProfilesProvider.notifier).state = children
                      .map((c) => c.id == child.id
                          ? ChildProfile(
                              id: c.id,
                              name: nameController.text,
                              age: int.tryParse(ageController.text) ?? 0,
                              color: selectedColor,
                            )
                          : c)
                      .toList();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4CE6),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, ChildProfile child) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Child Profile'),
        content: Text('Are you sure you want to delete ${child.name}\'s profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final children = ref.read(childProfilesProvider);
              ref.read(childProfilesProvider.notifier).state =
                  children.where((c) => c.id != child.id).toList();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
