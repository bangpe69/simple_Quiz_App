import 'package:http/http.dart' as http;
import './question_model.dart';
import 'dart:convert';

class DBconnect {
  final url = Uri.parse(
      "https://simplequizapp-3d7a1-default-rtdb.asia-southeast1.firebasedatabase.app/questions.json");
  Future<void> addQuestion(Question question) async {
    http.post(url,
        body: json.encode({
          'title': question.title,
          'option': question.options,
        }));
  }

  Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final newQuestions = <Question>[];

        data.forEach((key, value) {
          final title = value['title'] as String?;
          final options =
              (value['options'] as Map<String, dynamic>?)?.cast<String, bool>();

          if (title != null && options != null) {
            final newQuestion =
                Question(id: key, title: title, options: options);
            newQuestions.add(newQuestion);
          }
        });

        return newQuestions;
      } else {
        // Handle non-200 status code here, e.g., throw an exception
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      print('Error: $e');
      throw e; // Re-throw the exception for higher-level error handling
    }
  }

  // Future<List<Question>> fetchQuestions() async {
  //   return http.get(url).then((response) {
  //     var data = json.decode(response.body) as Map<String, dynamic>;
  //     List<Question> newQuestions = [];
  //     data.forEach((key, value) {
  //       var newQuestion = Question(
  //           id: key,
  //           title: value['title'],
  //           options: Map.castFrom(value['options']));
  //       newQuestions.add(newQuestion);
  //     });
  //     return newQuestions;
  //   });
  // }
}
