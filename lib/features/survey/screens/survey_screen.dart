import 'package:flutter/material.dart';
import 'package:swappp/features/auth/screens/signup_screen.dart';
import 'package:swappp/features/survey/widgets/survey_form.dart';

class SurveyScreen extends StatelessWidget {
  static const String routeName = '/survey';
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SurveyForm(
        pages: [
          SurveyTextInput(
            question: 'First things first, people call me... "WEP", like the sound a duck makes. What about you?',
            headerImage: 'assets/images/duck.jpg',
            placeholder: 'Your Nickname',
            keyboardType: TextInputType.name,
            isRequired: true,
          ),
          SurveyQuestion(
            question: 'How are you feeling about your finances today?',
            headerImage: 'assets/images/contemplate.jpeg', // Replace with actual image URL
            options: [
              'Stressed—I\'d rather not think about it',
              'Uncertain—I could use some guidance',
              'Stable—things feel manageable',
              'Confident—I could give Jeff Bezos a lesson in money management!',
            ],
            optionEmojis: ['😰', '🤔', '😌', '💪'],
          ),
          SurveyQuestion(
            question: 'What\'s your living situation?',
            headerImage: 'assets/images/bangku.jpeg', // Replace with actual image URL
            options: [
              'I live with my parents',
              'I\'m renting',
              'I own my home',
            ],
            optionEmojis: ['🧑‍🤝‍🧑', '🛋️', '🏠'],
          ),
          SurveyQuestion(
            question: 'What do you do for living?',
            headerImage: 'assets/images/braga.jpeg', // Replace with actual image URL
            options: [
              'I\'m a student',
              'I work full-time',
              'I work part-time',
              'I\'m self-employed',
              'I\'m unemployed',
            ],
            optionEmojis: ['🎓', '💼', '👩‍💻', '👨‍🔧', '🙍‍♂️'],
          ),
          SurveyQuestion(
            question: 'What kind of transportation costs do you regularly have?',
            headerImage: 'assets/images/shell.jpeg', // Replace with actual image URL
            options: [
              'Gas or fuel',
              'Public transportation',
              'Ride-sharing services',
              'I don\'t have any transportation costs',
            ],
            optionEmojis: ['⛽', '🚇', '🚗', '🚶'],
          ),
          SurveyQuestion(
            question: 'What do you spend on regularly?',
            headerImage: 'assets/images/ayam.jpeg', // Replace with actual image URL
            options: [
              'Food and groceries',
              'Education',
              'Health and wellness',
              'Entertainment',
              'Shopping',
              'I don\'t spend on anything regularly',
            ],
            optionEmojis: ['🍔', '📚', '🏥', '🎬', '🛍️', '🤷'],
          ),
          
          // Add more questions as needed
        ],
        onComplete: (questions) {
          Navigator.pushNamedAndRemoveUntil(
            context, SignUpScreen.routeName, (route) => false);
        },
      ),
    );
  }
}