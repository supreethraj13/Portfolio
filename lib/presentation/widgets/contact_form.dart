import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/lead_message.dart';
import '../../domain/usecases/submit_lead_use_case.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({required this.submitLeadUseCase, super.key});

  final SubmitLeadUseCase submitLeadUseCase;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      await widget.submitLeadUseCase.call(
        LeadMessage(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent. Thanks for reaching out.')),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }
      final message = error.code == 'rate-limit-exceeded'
          ? 'Rate limit reached. Please wait before sending another message.'
          : error.code == 'permission-denied'
          ? 'Submission blocked by Firestore rules or rate limits. Wait and try again.'
          : 'Failed to send message: ${error.message ?? error.code}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send a Message',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Share your requirement, idea, or role details.',
            style: TextStyle(color: Color(0xFFB9C8E8)),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _nameController,
            maxLength: 80,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) {
                return 'Please enter your name';
              }
              if (text.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              return emailPattern.hasMatch(value.trim())
                  ? null
                  : 'Enter a valid email';
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _messageController,
            maxLength: 2000,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message',
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 62),
                child: Icon(Icons.chat_bubble_outline),
              ),
            ),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) {
                return 'Please enter a message';
              }
              if (text.length < 5) {
                return 'Message must be at least 5 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            label: Text(_submitting ? 'Sending...' : 'Send Message'),
          ),
        ],
      ),
    );
  }
}
