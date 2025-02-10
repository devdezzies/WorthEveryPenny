import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class SurveyQuestion {
  final String question;
  final List<String> options;
  final List<String>? optionEmojis;
  final String? headerImage;
  final bool isMultipleChoice;
  List<bool> selectedOptions;

  SurveyQuestion({
    required this.question,
    required this.options,
    this.optionEmojis,
    this.headerImage,
    this.isMultipleChoice = false,
  }) : selectedOptions = List.filled(options.length, false);

  bool get isAnswered => selectedOptions.contains(true);
}

class SurveyForm extends StatefulWidget {
  final List<dynamic> pages;
  final Function(List<dynamic>) onComplete;

  const SurveyForm({
    Key? key,
    required this.pages,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1 / widget.pages.length,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage < widget.pages.length - 1) {
      if (_isCurrentPageAnswered()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage++;
          _progressController.animateTo(
            (_currentPage + 1) / widget.pages.length,
          );
        });
      }
    } else {
      widget.onComplete(widget.pages);
    }
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
        _progressController.animateTo(
          (_currentPage + 1) / widget.pages.length,
        );
      });
    }
  }

  bool _isCurrentPageAnswered() {
    final currentPage = widget.pages[_currentPage];
    if (currentPage is SurveyQuestion) {
      return currentPage.isAnswered;
    } else if (currentPage is SurveyTextInput) {
      return currentPage.isAnswered;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: _handleBack,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: _progressController.value,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: GlobalVariables.secondaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.pages.length,
                itemBuilder: (context, index) {
                  final page = widget.pages[index];
                  if (page is SurveyQuestion) {
                    return QuestionPage(
                      question: page,
                      onSelectionChanged: () {
                        setState(() {});
                      },
                    );
                  } else if (page is SurveyTextInput) {
                    return TextInputPage(
                      textInput: page,
                      onInputChanged: () {
                        setState(() {});
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isCurrentPageAnswered() ? 1.0 : 0.5,
                child: ElevatedButton(
                  onPressed: _isCurrentPageAnswered() ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalVariables.secondaryColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == widget.pages.length - 1
                        ? 'SUBMIT'
                        : 'CONTINUE',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyTextInput {
  final String question;
  final String? headerImage;
  final String placeholder;
  final int? maxLength;
  final bool isRequired;
  String answer;
  final TextInputType keyboardType;
  final int? maxLines;

  SurveyTextInput({
    required this.question,
    this.headerImage,
    this.placeholder = '',
    this.maxLength,
    this.isRequired = true,
    this.answer = '',
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  bool get isAnswered => isRequired ? answer.trim().isNotEmpty : true;
}

class TextInputPage extends StatefulWidget {
  final SurveyTextInput textInput;
  final VoidCallback onInputChanged;

  const TextInputPage({
    Key? key,
    required this.textInput,
    required this.onInputChanged,
  }) : super(key: key);

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.textInput.answer);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.textInput.headerImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.textInput.headerImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                gaplessPlayback:
                    true, // Add this line to prevent image flickering
              ),
            ),
          const SizedBox(height: 24),
          Text(
            widget.textInput.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _focusNode.hasFocus
                          ? GlobalVariables.secondaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: widget.textInput.maxLength,
                    maxLines: widget.textInput.maxLines,
                    keyboardType: widget.textInput.keyboardType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.textInput.placeholder,
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                      counterStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      widget.textInput.answer = value;
                      widget.onInputChanged();
                    },
                  ),
                ),
                if (widget.textInput.isRequired)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _controller.text.trim().isEmpty
                          ? 'Don\'t miss this one 👌'
                          : '',
                      style: const TextStyle(
                          color: GlobalVariables.secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionPage extends StatelessWidget {
  final SurveyQuestion question;
  final VoidCallback onSelectionChanged;

  const QuestionPage({
    Key? key,
    required this.question,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.headerImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                question.headerImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (question.isMultipleChoice)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                '(Select all that apply)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: OptionButton(
                    text: question.options[index],
                    emoji: question.optionEmojis?[index],
                    isSelected: question.selectedOptions[index],
                    onTap: () {
                      if (question.isMultipleChoice) {
                        question.selectedOptions[index] =
                            !question.selectedOptions[index];
                      } else {
                        for (int i = 0;
                            i < question.selectedOptions.length;
                            i++) {
                          question.selectedOptions[i] = i == index;
                        }
                      }
                      onSelectionChanged();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    this.emoji,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.grey[900],
                GlobalVariables.secondaryColor,
                value,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (emoji != null) ...[
                  Text(
                    emoji!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Color.lerp(
                        Colors.white,
                        Colors.black,
                        value,
                      ),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
