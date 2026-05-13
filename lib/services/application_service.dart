import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/mock_data.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionsName = 'applications';

  /// Submit an application for a project
  Future<void> submitApplication({
    required String projectId,
    required String projectName,
    required String role,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Check if already applied for this role on this project
      final existing = await _firestore
          .collection(_collectionsName)
          .where('userId', isEqualTo: userId)
          .where('projectId', isEqualTo: projectId)
          .where('role', isEqualTo: role)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('You have already applied for this role');
      }

      // Create new application
      await _firestore.collection(_collectionsName).add({
        'userId': userId,
        'userEmail': _auth.currentUser?.email,
        'userName': _auth.currentUser?.displayName,
        'projectId': projectId,
        'projectName': projectName,
        'role': role,
        'status': 'PENDING',
        'appliedDate': DateTime.now().toString().split(' ')[0], // YYYY-MM-DD format
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to submit application: $e');
    }
  }

  /// Get all applications for the current user
  Future<List<Application>> getUserApplications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection(_collectionsName)
          .where('userId', isEqualTo: userId)
          .get();

      final apps = snapshot.docs.map((doc) {
        final data = doc.data();
        return Application(
          id: doc.id,
          role: data['role'] ?? '',
          projectName: data['projectName'] ?? '',
          status: data['status'] ?? 'PENDING',
          statusColor: _getStatusColor(data['status'] ?? 'PENDING'),
          appliedDate: data['appliedDate'] ?? '',
          applicantEmail: data['userEmail'] ?? '',
          applicantName: data['userName'] ?? '',
        );
      }).toList();
      
      // Sort by appliedDate descending in code
      apps.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
      return apps;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to fetch applications: $e');
    }
  }

  /// Get all applications for a specific project (for project owner)
  Future<List<Map<String, dynamic>>> getProjectApplications(
      String projectId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionsName)
          .where('projectId', isEqualTo: projectId)
          .get();

      final apps = snapshot.docs.map((doc) => doc.data()).toList();
      // Sort by appliedDate descending in code
      apps.sort((a, b) {
        final dateA = a['appliedDate'] as String? ?? '';
        final dateB = b['appliedDate'] as String? ?? '';
        return dateB.compareTo(dateA);
      });
      return apps;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to fetch project applications: $e');
    }
  }

  /// Update application status
  Future<void> updateApplicationStatus(
      String applicationId, String newStatus) async {
    try {
      await _firestore
          .collection(_collectionsName)
          .doc(applicationId)
          .update({'status': newStatus});
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to update application: $e');
    }
  }

  /// Stream of applications for current user (real-time updates)
  Stream<List<Application>> streamUserApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.error('User not authenticated');
    }

    return _firestore
        .collection(_collectionsName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final apps = snapshot.docs.map((doc) {
        final data = doc.data();
        return Application(
          id: doc.id,
          role: data['role'] ?? '',
          projectName: data['projectName'] ?? '',
          status: data['status'] ?? 'PENDING',
          statusColor: _getStatusColor(data['status'] ?? 'PENDING'),
          appliedDate: data['appliedDate'] ?? '',
          applicantEmail: data['userEmail'] ?? '',
          applicantName: data['userName'] ?? '',
        );
      }).toList();
      
      // Sort by appliedDate descending in code instead of via query
      apps.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
      return apps;
    });
  }

  Stream<List<Application>> streamProjectApplications(String projectId) {
    return _firestore
        .collection(_collectionsName)
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map((snapshot) {
      final apps = snapshot.docs.map((doc) {
        final data = doc.data();
        return Application(
          id: doc.id,
          role: data['role'] ?? '',
          projectName: data['projectName'] ?? '',
          status: data['status'] ?? 'PENDING',
          statusColor: _getStatusColor(data['status'] ?? 'PENDING'),
          appliedDate: data['appliedDate'] ?? '',
          applicantEmail: data['userEmail'] ?? '',
          applicantName: data['userName'] ?? '',
        );
      }).toList();
      
      // Sort by appliedDate descending in code instead of via query
      apps.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
      return apps;
    });
  }

  /// Get status color based on status string
  static Color _getStatusColor(String status) {
    switch (status) {
      case 'ACCEPTED':
        return const Color(0xFF10B981); // Green
      case 'REJECTED':
        return const Color(0xFFEF4444); // Red
      case 'PENDING':
        return const Color(0xFFF59E0B); // Amber
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
}
