import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_begining/services/crud/local_notes_services.dart';

const ownerUserId = 'user_id';
const textFieldName = 'text';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : documentId = snapshot.id,
      ownerUserId = snapshot.data()[userIdColumn] as String,
      text = snapshot.data()[textFieldName] as String;
      
}
