
import 'package:equatable/equatable.dart';

class Question {
  int? id;
  int? authorId;
  int? articleId;
  String? ask;
  List<Answer>? answers;

  Question({
    this.id,
    this.authorId,
    this.articleId,
    this.ask = "",
    this.answers = const <Answer>[],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': authorId,
      'article_id': articleId,
      'question': ask,
      'answers': [...answers ?? []].map((answer) {
        return answer.toMap();
      }).toList(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    List<Answer> answers = <Answer>[];
    map['answers'].map((m) {
      return answers.add(Answer.fromMap(m));
    }).toList();
    return Question(
      id: map['id'],
      authorId: map['author_id'],
      articleId: map['article_id'],
      ask: map['question'],
      answers: answers,
    );
  }

  Question copyWith({
    int? id,
    int? authorId,
    int? articleId,
    String? ask,
    List<Answer>? answers,
    bool? isChoosen,
  }) {
    return Question(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      articleId: articleId ?? this.articleId,
      ask: ask ?? this.ask,
      answers: answers ?? this.answers,
    );
  }
}

class Answer {
  int? id;
  int? questionId;
  String? answer;
  bool? isCorrect;
  bool? isChoosen;

  Answer({
    this.id,
    this.questionId,
    this.answer,
    this.isCorrect,
    this.isChoosen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_id': questionId,
      'answer': answer,
      'is_correct': isCorrect,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'],
      questionId: map['question_id'],
      answer: map['answer'],
      isCorrect: map['is_correct'] == 1 ? true : false,
      isChoosen: false,
    );
  }

  Answer copyWith({
    int? id,
    int? questionId,
    String? answer,
    bool? isCorrect,
    bool? isChoosen
  }) {
    return Answer(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
      isChoosen: isChoosen ?? this.isChoosen,
    );
  }
}