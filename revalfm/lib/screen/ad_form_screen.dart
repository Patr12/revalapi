// lib/screens/ad_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revalfm/model/advertisement.dart';
import '../providers/ads_provider.dart';

class AdFormScreen extends StatefulWidget {
  final Advertisement? advertisement;

  const AdFormScreen({super.key, this.advertisement});

  @override
  _AdFormScreenState createState() => _AdFormScreenState();
}

class _AdFormScreenState extends State<AdFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late Advertisement _advertisement;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _advertisement = widget.advertisement ??
        Advertisement(
          title: '',
          description: '',
          imageDisplay: '',
          targetProgram: 'General (All Programs)',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          advertiser: '',
          status: 'active',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }

  Future<void> _saveAd() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final adsProvider = Provider.of<AdsProvider>(context, listen: false);
      Map<String, dynamic> result;

      if (_advertisement.id == null) {
        result = await adsProvider.createAd(_advertisement);
      } else {
        result = await adsProvider.updateAd(_advertisement.id!, _advertisement);
      }

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        Navigator.pop(context);
      } else if (context.mounted) {
        setState(() {
          _error = result['error'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.advertisement == null ? 'Create New Ad' : 'Edit Ad',
        ),
        actions: [
          if (widget.advertisement != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Ad'),
                    content: const Text('Are you sure you want to delete this ad?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  final adsProvider = Provider.of<AdsProvider>(context, listen: false);
                  await adsProvider.deleteAd(_advertisement.id!);
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            // Basic Information
            _buildSectionHeader('Basic Information'),
            _buildTextField(
              label: 'Ad Title *',
              initialValue: _advertisement.title,
              onSaved: (value) => _advertisement = _advertisement.copyWith(title: value!),
              validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Description *',
              initialValue: _advertisement.description,
              maxLines: 3,
              onSaved: (value) => _advertisement = _advertisement.copyWith(description: value!),
              validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Image URL *',
              initialValue: _advertisement.imageDisplay,
              onSaved: (value) => _advertisement = _advertisement.copyWith(imageUrl: value!),
              validator: (value) => value == null || value.isEmpty ? 'Image URL is required' : null,
            ),

            // Program and Schedule
            _buildSectionHeader('Program & Schedule'),
            _buildDropdown(
              label: 'Target Program',
              value: _advertisement.targetProgram,
              items: ProgramChoices.programs,
              onChanged: (value) {
                setState(() {
                  _advertisement = _advertisement.copyWith(targetProgram: value!);
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDateField(
              label: 'Start Date',
              initialDate: _advertisement.startDate,
              onChanged: (date) {
                setState(() {
                  _advertisement = _advertisement.copyWith(startDate: date);
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDateField(
              label: 'End Date',
              initialDate: _advertisement.endDate,
              onChanged: (date) {
                setState(() {
                  _advertisement = _advertisement.copyWith(endDate: date);
                });
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Display Duration (seconds)',
              initialValue: _advertisement.displayDuration.toString(),
              keyboardType: TextInputType.number,
              onSaved: (value) => _advertisement = _advertisement.copyWith(
                displayDuration: int.tryParse(value ?? '30') ?? 30,
              ),
            ),

            // Advertiser Information
            _buildSectionHeader('Advertiser Information'),
            _buildTextField(
              label: 'Advertiser Name *',
              initialValue: _advertisement.advertiser,
              onSaved: (value) => _advertisement = _advertisement.copyWith(advertiser: value!),
              validator: (value) => value == null || value.isEmpty ? 'Advertiser name is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Contact Phone',
              initialValue: _advertisement.advertiserContact,
              keyboardType: TextInputType.phone,
              onSaved: (value) => _advertisement = _advertisement.copyWith(advertiserContact: value),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Email',
              initialValue: _advertisement.advertiserEmail,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _advertisement = _advertisement.copyWith(advertiserEmail: value),
            ),

            // Call to Action
            _buildSectionHeader('Call to Action'),
            _buildTextField(
              label: 'Call to Action Text',
              initialValue: _advertisement.callToAction,
              onSaved: (value) => _advertisement = _advertisement.copyWith(callToAction: value),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              label: 'External Link',
              initialValue: _advertisement.externalLink,
              keyboardType: TextInputType.url,
              onSaved: (value) => _advertisement = _advertisement.copyWith(externalLink: value),
            ),

            // Status
            _buildSectionHeader('Status'),
            _buildDropdown(
              label: 'Status',
              value: _advertisement.status,
              items: StatusChoices.statuses,
              onChanged: (value) {
                setState(() {
                  _advertisement = _advertisement.copyWith(status: value!);
                });
              },
            ),

            // Save Button
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveAd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'SAVE ADVERTISEMENT',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    int maxLines = 1,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime initialDate,
    required ValueChanged<DateTime> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          '${initialDate.day}/${initialDate.month}/${initialDate.year}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}