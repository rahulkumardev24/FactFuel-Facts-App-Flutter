import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:fact_fuel/helper/my_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import '../../helper/colors.dart';
import '../../helper/fact_utils.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;
  bool _feedbackSent = false;
  String? _selectedCategory;

  // Feedback categories
  final List<String> _categories = [
    'General',
    'Feature Request',
    'Bug Report',
    'Content Issue',
    'User Experience',
  ];

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        // Using FactUtils to submit feedback
        final success = await FactUtils.submitFeedback(
          message: _feedbackController.text.trim(),
          rating: _rating,
          category: _selectedCategory,
        );

        if (mounted) {
          if (success) {
            // Success state update
            setState(() {
              _feedbackSent = true;
              _feedbackController.clear();
              _rating = 0;
              _selectedCategory = null;
            });
            
            // Show success message
            MyDialogs.myShowSnackBar(
              context,
              "Thank you for your feedback!",
              Colors.green,
              Colors.white,
            );
          } else {
            // Show error message
            MyDialogs.myShowSnackBar(
              context,
              "Failed to submit feedback. Please try again.",
              AppColors.error,
              AppColors.textPrimary,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          MyDialogs.myShowSnackBar(
            context,
            "An error occurred: ${e.toString()}",
            AppColors.error,
            AppColors.textPrimary,
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Share Feedback',
          style: myTextStyle21(textColor: AppColors.textPrimary),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body:
          _feedbackSent
              ? _buildSuccessUI(size)
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidCommentDots,
                              size: 72,
                              color: AppColors.primaryLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Share Your Thoughts',
                              style: myTextStyle18(
                                textColor: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              textAlign: TextAlign.center,
                              'We value your feedback to improve FactFuel',
                              style: myTextStyle14(
                                textColor: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      GlassContainer(
                        height: size.height * 0.15,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryLight.withAlpha(180),
                            AppColors.primaryLight.withAlpha(10),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            AppColors.primary.withAlpha(60),
                            AppColors.primaryDark.withAlpha(40),
                            AppColors.primary.withAlpha(40),
                            AppColors.primaryDark.withAlpha(80),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.39, 0.40, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        blur: 12.0,
                        borderWidth: 1.5,
                        elevation: 3.0,
                        isFrostedGlass: false,
                        shadowColor: Colors.black.withAlpha(40),
                        alignment: Alignment.center,
                        frostedOpacity: 0.19,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'How would you rate your experience?',
                              style: myTextStyle14(textColor: Colors.yellow),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap:
                                        () =>
                                            setState(() => _rating = index + 1),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Icon(
                                        index < _rating
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        size: 42,
                                        color:
                                            _rating > 0
                                                ? Colors.amber
                                                : Colors.grey,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),

                            if (_rating > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                _rating == 5
                                    ? 'Excellent!'
                                    : _rating == 4
                                    ? 'Good!'
                                    : _rating == 3
                                    ? 'Average'
                                    : _rating == 2
                                    ? 'Below Average'
                                    : 'Poor',
                                style: myTextStyle18(
                                  textColor:
                                      _rating == 5
                                          ? Colors.green
                                          : _rating >= 3
                                          ? Colors.orange
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// Category Dropdown
                      Text(
                        'Category',
                        style: myTextStyle16(
                          textColor: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          borderRadius: BorderRadius.circular(16),
                          hint: Text(
                            'Select a category',
                            style: myTextStyle14(
                              textColor: AppColors.textSecondary,
                            ),
                          ),
                          items:
                              _categories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: myTextStyle14(
                                      textColor: AppColors.primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            setState(() => _selectedCategory = newValue);
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Feedback Input
                      Text(
                        'Your Feedback',
                        style: myTextStyle16(
                          textColor: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 5,
                        style: myTextStyle14(
                          textColor: AppColors.textSecondary.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Tell us what you like or how we can improve...',
                          hintStyle: myTextStyle14(
                            textColor: AppColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.primaryDark.withValues(
                            alpha: 0.15,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please share your feedback';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      /// Submit Button
                      _isSubmitting
                          ? Center(
                            child: MyDialogs.myCircularProgressIndicator(),
                          )
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitFeedback,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: AppColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'Submit Feedback',
                                style: myTextStyle16(),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSuccessUI(Size size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.circleCheck,
              size: size.width * 0.3,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Thank You!',
              style: myTextStyle21(textColor: AppColors.primaryLight),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Your feedback has been submitted successfully. We appreciate your time and will use your suggestions to improve FactFuel.',
                textAlign: TextAlign.center,
                style: myTextStyle16(textColor: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _feedbackSent = false;
                  _feedbackController.clear();
                  _rating = 0;
                  _selectedCategory = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Submit Another Feedback',
                style: myTextStyle16(
                  textColor: AppColors.primaryLight.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
