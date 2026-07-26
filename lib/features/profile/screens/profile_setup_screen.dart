import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/neo_design_system.dart' hide Badge;

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _step = 1;

  // Form states
  String _name = "";
  String _phone = "";
  DateTime? _dob;

  String? _board;
  String _twelfthPercent = "";

  String _jeePercentile = "";
  final Set<String> _optionalExams = {};

  String? _category;

  final List<String> _boards = ["CBSE", "ICSE", "State Board", "IB/IGCSE"];
  final List<String> _examsList = ["BITSAT", "VITEEE", "MHT-CET", "CUET"];
  final List<String> _categories = ["General", "OBC-NCL", "SC", "ST", "EWS", "PwD"];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2006, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: NeoColors.green,
              onPrimary: Colors.black,
              surface: NeoColors.surfDark2,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  void _next() {
    if (_step < 5) setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_step > 1 && _step < 5) {
                        setState(() => _step--);
                      } else if (_step == 1) {
                        context.pop();
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: NeoColors.surfDark,
                        shape: BoxShape.circle,
                        border: Border.all(color: NeoColors.borderDark),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'PROFILE SETUP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white30,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (_step < 5)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: NeoColors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.green.withValues(alpha: 0.3)),
                      ),
                      child: Text('STEP $_step/4', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.green)),
                    ),
                ],
              ),
            ),

            // Progress Bar
            if (_step < 5)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                child: Row(
                  children: List.generate(4, (index) {
                    final isActiveOrDone = index < _step;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: isActiveOrDone ? NeoColors.green : NeoColors.borderDark,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isActiveOrDone ? [
                            BoxShadow(color: NeoColors.green.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 0),
                          ] : [],
                        ),
                      ),
                    );
                  }),
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_step == 1) _buildStep1(),
                    if (_step == 2) _buildStep2(),
                    if (_step == 3) _buildStep3(),
                    if (_step == 4) _buildStep4(),
                    if (_step == 5) _buildStep5(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal Info', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Let us know you better.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),
        
        _buildTextField('Full Name', 'Enter your name', (val) => setState(() => _name = val)),
        const SizedBox(height: 20),
        
        const Text('Date of Birth', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white60)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: NeoColors.surfDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NeoColors.borderDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dob != null ? DateFormat('dd MMM yyyy').format(_dob!) : 'Select Date',
                    style: TextStyle(fontSize: 15, color: _dob != null ? Colors.white : Colors.white30, fontWeight: FontWeight.w700),
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.white60, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        _buildTextField('Phone Number', '+91', (val) => setState(() => _phone = val), keyboardType: TextInputType.phone),
        
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Continue →',
            disabled: _name.isEmpty || _phone.isEmpty || _dob == null,
            onClick: _next,
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Academics', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Your 12th standard details.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),
        
        const Text('Select Board', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white60)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _boards.map((b) {
            final isSel = _board == b;
            return GestureDetector(
              onTap: () => setState(() => _board = b),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSel ? NeoColors.green : NeoColors.surfDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isSel ? NeoColors.green : NeoColors.borderDark),
                ),
                child: Text(b, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isSel ? Colors.black : Colors.white)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        _buildTextField('12th Percentage / CGPA', 'e.g. 92.5%', (val) => setState(() => _twelfthPercent = val), keyboardType: TextInputType.number),
        
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Continue →',
            disabled: _board == null || _twelfthPercent.isEmpty,
            onClick: _next,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Entrance Exams', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Enter your competitive exam scores.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),

        _buildTextField('JEE Main Percentile', 'e.g. 98.4', (val) => setState(() => _jeePercentile = val), keyboardType: TextInputType.number),
        const SizedBox(height: 32),

        const Text('Other Exams Appeared (Optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white60)),
        const SizedBox(height: 12),
        Column(
          children: _examsList.map((e) {
            final isChecked = _optionalExams.contains(e);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isChecked) {
                    _optionalExams.remove(e);
                  } else {
                    _optionalExams.add(e);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NeoColors.surfDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isChecked ? NeoColors.green : NeoColors.borderDark),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isChecked ? NeoColors.green : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: isChecked ? NeoColors.green : Colors.white30, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: isChecked ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
                    ),
                    const SizedBox(width: 14),
                    Text(e, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Continue →',
            disabled: _jeePercentile.isEmpty,
            onClick: _next,
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 6),
        const Text('Select your reservation category if applicable.', style: TextStyle(fontSize: 14, color: Colors.white60)),
        const SizedBox(height: 32),

        ..._categories.map((cat) {
          final isSelected = _category == cat;
          return GestureDetector(
            onTap: () => setState(() => _category = cat),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surfDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? NeoColors.green : NeoColors.borderDark),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? NeoColors.green : Colors.transparent,
                      border: Border.all(color: isSelected ? NeoColors.green : Colors.white30, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: isSelected ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ) : null,
                  ),
                  const SizedBox(width: 14),
                  Text(cat, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: isSelected ? NeoColors.green : Colors.white)),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Complete Profile ✓',
            disabled: _category == null,
            onClick: _next,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: NeoColors.green.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: NeoColors.green),
            boxShadow: [
              BoxShadow(color: NeoColors.green.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 4),
            ],
          ),
          alignment: Alignment.center,
          child: const Text('🎉', style: TextStyle(fontSize: 40)),
        ),
        const SizedBox(height: 32),
        const Text('Profile Ready!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
        const SizedBox(height: 8),
        const Text('Your AI co-pilot is now customized for you.', style: TextStyle(fontSize: 14, color: Colors.white60), textAlign: TextAlign.center),
        const SizedBox(height: 40),

        NotchedCard(
          bg: NeoColors.surfDark2,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_name.isEmpty ? 'Student' : _name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 4),
              Text('JEE $_jeePercentile • $_category', style: const TextStyle(fontSize: 13, color: NeoColors.green, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              const Divider(color: NeoColors.borderDark),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Board', style: TextStyle(fontSize: 11, color: Colors.white30, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(_board ?? '-', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('12th %', style: TextStyle(fontSize: 11, color: Colors.white30, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(_twelfthPercent.isEmpty ? '-' : '$_twelfthPercent%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 60),
        SizedBox(
          width: double.infinity,
          child: GreenBtn(
            label: 'Go to Dashboard',
            onClick: () => context.go('/home'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white60)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30),
            filled: true,
            fillColor: NeoColors.surfDark,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: NeoColors.borderDark),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: NeoColors.borderDark),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: NeoColors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
