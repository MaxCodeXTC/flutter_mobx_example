// TODO: 1. Define the data structure

import 'package:json_annotation/json_annotation.dart';

part 'choice.g.dart';

@JsonSerializable()
class Choice {
  final String id;
  final String category;
  final String answer;

  Choice({this.id, this.category, this.answer});

  static Choice fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  static Map<String, dynamic> toJson(Choice choice) => _$ChoiceToJson(choice);

  @override
  String toString() {
    return 'Choice(id: $id, category: $category, answer: $answer)';
  }
}
