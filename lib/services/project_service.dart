import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreProject {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> openRoles;
  final String ownerId;
  final String? ownerEmail;
  final String? ownerName;
  final String status;
  final DateTime createdAt;

  FirestoreProject({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.openRoles,
    required this.ownerId,
    this.ownerEmail,
    this.ownerName,
    required this.status,
    required this.createdAt,
  });
}

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionName = 'projects';

  Future<void> createProject({
    required String title,
    required String description,
    required String category,
    required List<String> openRoles,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection(_collectionName).add({
        'title': title,
        'description': description,
        'category': category,
        'openRoles': openRoles,
        'ownerId': user.uid,
        'ownerEmail': user.email,
        'ownerName': user.displayName,
        'status': 'ACTIVE',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to create project: $e');
    }
  }

  Stream<List<FirestoreProject>> streamProjects() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) {
      final projects = snapshot.docs.map(_projectFromDoc).toList();
      projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return projects;
    });
  }

  Stream<List<FirestoreProject>> streamProjectsByOwner(String ownerId) {
    return _firestore
        .collection(_collectionName)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) {
      final projects = snapshot.docs.map(_projectFromDoc).toList();
      projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return projects;
    });
  }

  FirestoreProject _projectFromDoc(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAtValue = data['createdAt'];
    final createdAt = createdAtValue is Timestamp
        ? createdAtValue.toDate()
        : DateTime.now();

    return FirestoreProject(
      id: doc.id,
      title: data['title']?.toString() ?? 'Untitled Project',
      description: data['description']?.toString() ?? '',
      category: data['category']?.toString() ?? 'Other',
      openRoles: (data['openRoles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [],
      ownerId: data['ownerId']?.toString() ?? '',
      ownerEmail: data['ownerEmail']?.toString(),
      ownerName: data['ownerName']?.toString(),
      status: data['status']?.toString() ?? 'ACTIVE',
      createdAt: createdAt,
    );
  }

}
