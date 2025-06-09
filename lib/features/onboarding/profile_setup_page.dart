import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kliks/shared/widgets/text_form_widget.dart';
import 'package:kliks/shared/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:kliks/core/providers/auth_provider.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  DateTime? _dob;
  String? _gender;
  bool _isLoading = false;

  final List<String> _genders = ['Male', 'Female', 'Non-binary', 'Other'];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Please select date of birth and gender'))),
      );
      return;
    }
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final successFullname = await authProvider.updateProfile(field: 'fullname', value: _fullnameController.text.trim());
    final successUsername = await authProvider.updateProfile(field: 'username', value: _usernameController.text.trim());
    final successDob = await authProvider.updateProfile(field: 'dob', value: _dob!.toIso8601String());
    // final successGender = await authProvider.updateProfile(field: 'gender', value: _gender);
    setState(() => _isLoading = false);
    if (successFullname && successUsername && successDob) {
      Navigator.pushReplacementNamed(context, '/main-app');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Padding(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7), child: Text('Failed to update profile. Please try again.'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Complete Your Profile'),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   foregroundColor: theme.textTheme.bodyLarge?.color,
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h), 
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/logo-inner.png'
                    : 'assets/logo-dark.png',
                height: 80.h, 
                width: 60.w,  
              ),
              SizedBox(height: 10.h), 
              Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 24.sp, 
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Metropolis-SemiBold',
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 8.h), 
                Text(
                'We just need a few more details to get you started.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 18.h), 
              TextFormWidget(
                name: 'fullname',
                controller: _fullnameController,
                labelText: 'Full name',
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter your full name' : null,
              ),
              SizedBox(height: 18.h),
              TextFormWidget(
                name: 'username',
                controller: _usernameController,
                labelText: 'Username',
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter a username' : null,
              ),
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormWidget(
                    name: 'dob',
                    controller: TextEditingController(text: _dob == null ? '' : '${_dob!.day}/${_dob!.month}/${_dob!.year}'),
                    labelText: 'Date of Birth',
                    validator: (_) => _dob == null ? 'Select your date of birth' : null,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              // DropdownButtonFormField<String>(
              //   value: _gender,
              //   items: _genders
              //       .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              //       .toList(),
              //   onChanged: (val) => setState(() => _gender = val),
              //   decoration: const InputDecoration(labelText: 'Gender'),
              //   validator: (val) => val == null ? 'Select your gender' : null,
              // ),
              SizedBox(height: 32.h),
              CustomButton(
                text: 'Submit',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
                backgroundColor: const Color(0xffbbd953),
                textColor: Colors.black,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontFamily: 'Metropolis-SemiBold',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
} 