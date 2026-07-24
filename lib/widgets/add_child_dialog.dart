import 'package:flutter/material.dart';

class AddChildDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const AddChildDialog({super.key, this.initialData});

  @override
  State<AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<AddChildDialog> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _ageController;

  DateTime? _birthDate;
  String? _gender;
  String? _bloodType;

  final List<String> _genders = ['Lalaki', 'Babae'];
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData?['name'] as String? ?? '');
    _heightController = TextEditingController(text: widget.initialData?['height']?.toString() ?? '');
    _weightController = TextEditingController(text: widget.initialData?['weight']?.toString() ?? '');
    
    _birthDate = widget.initialData?['birthDate'] as DateTime?;
    _gender = widget.initialData?['gender'] as String?;
    _bloodType = widget.initialData?['bloodType'] as String?;

    _ageController = TextEditingController(
      text: _birthDate != null ? _calculateAgeString(_birthDate!) : '',
    );
    
    _heightController.addListener(_updateBMI);
    _weightController.addListener(_updateBMI);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _updateBMI() {
    setState(() {});
  }


  double? get _bmi {
    final heightText = _heightController.text;
    final weightText = _weightController.text;
    if (heightText.isEmpty || weightText.isEmpty) return null;
    
    final height = double.tryParse(heightText);
    final weight = double.tryParse(weightText);
    
    if (height == null || weight == null || height <= 0) return null;
    return weight / ((height / 100) * (height / 100));
  }

  String _getBMIInterpretation(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  String _calculateAgeString(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    
    if (now.day < birthDate.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    
    if (years == 0) {
      return '$months buwan';
    }
    return '$years taon at $months buwan';
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _ageController.text = _calculateAgeString(picked);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_birthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mangyaring pumili ng Petsa ng Kapanganakan')),
        );
        return;
      }
      
      final childData = {
        'name': _nameController.text.trim(),
        'birthDate': _birthDate,
        'gender': _gender,
        'bloodType': _bloodType,
        'height': double.tryParse(_heightController.text),
        'weight': double.tryParse(_weightController.text),
      };
      
      Navigator.of(context).pop(childData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentBmi = _bmi;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: bottomInset),
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Magdagdag ng Anak',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Pangalan ng Bata
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Pangalan ng Bata',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Kailangan ang pangalan' : null,
                ),
                const SizedBox(height: 16),
                
                // Petsa ng Kapanganakan
                InkWell(
                  onTap: _selectBirthDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Petsa ng Kapanganakan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _birthDate == null ? 'Pumili ng petsa' : _formatDate(_birthDate!),
                          style: theme.textTheme.bodyLarge,
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Edad (Taon at Buwan)
                TextFormField(
                  controller: _ageController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Edad (Taon at Buwan)',
                    prefixIcon: const Icon(Icons.cake),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Kailangan ang edad' : null,
                ),
                const SizedBox(height: 16),
                
                // Kasarian at Uri ng Dugo
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Kasarian',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        initialValue: _gender,
                        items: _genders
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) => setState(() => _gender = val),
                        validator: (value) => value == null ? 'Kailangan' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Uri ng Dugo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        initialValue: _bloodType,
                        items: _bloodTypes
                            .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                            .toList(),
                        onChanged: (val) => setState(() => _bloodType = val),
                        validator: (value) => value == null ? 'Kailangan' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Height at Weight
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height (cm)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Kailangan';
                          final v = double.tryParse(value);
                          if (v == null || v <= 0) return 'Di wasto';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Kailangan';
                          final v = double.tryParse(value);
                          if (v == null || v <= 0) return 'Di wasto';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // BMI Display
                if (currentBmi != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'BMI: ${currentBmi.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getBMIInterpretation(currentBmi),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Kanselahin'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('I-save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
