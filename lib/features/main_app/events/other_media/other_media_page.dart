import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OtherMediaPage extends StatefulWidget {
  const OtherMediaPage({super.key});

  @override
  State<OtherMediaPage> createState() => _OtherMediaPageState();
}

class _OtherMediaPageState extends State<OtherMediaPage> {
  final List<File?> _images = List<File?>.filled(5, null);

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _images[index] = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final double boxSize = (MediaQuery.of(context).size.width - 60.w) / 2;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transparent horizontal bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    _buildDoneButton(onPressed: () {
                      // Return only the non-null picked images as XFile
                      final pickedImages = _images.where((img) => img != null).map((img) => XFile(img!.path)).toList();
                      Navigator.pop(context, pickedImages);
                    }),
                    // SmallButton(
                    //   text: "Done",
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   backgroundColor: const Color(0xffbbd953),
                    //   textColor: Colors.black,
                    // ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Other media',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18.sp,
                    fontFamily: 'Metropolis-SemiBold',
                    letterSpacing: -0.5,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8.h),
                Text(
                  'You can add up to 5 items for this event. The content of the cover image should fit into (1080 x 1350)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: Theme.of(context).hintColor,
                    fontFamily: 'Metropolis-Regular',
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 24.h),
                // 5 boxes, 2 per row
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.h,
                    crossAxisSpacing: 5.w,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _pickImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[700]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: _images[index] == null
                            ? Center(
                                child: Icon(
                                  Icons.add,
                                  size: 30.sp,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.5),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  _images[index]!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
   Widget _buildDoneButton({required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffbbd953),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
      child: Text(
        'Done',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
          fontSize: 14.sp,
          fontFamily: 'Metropolis-SemiBold',
          letterSpacing: 0,
        ),
      ),
    );
  }
}