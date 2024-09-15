
import 'domain/models/frequency.dart';

class Alphabets{
  static const List<String> russian = [
    'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О',
    'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ь', 'Ы', 'Ъ', 'Э', 'Ю', 'Я'
  ];

  static List<Frequency> russianAlphabetFrequencies = [
    Frequency('о', 0, 0.10983),
    Frequency('е', 0, 0.08483),
    Frequency('а', 0, 0.07998),
    Frequency('и', 0, 0.07367),
    Frequency('н', 0, 0.06700),
    Frequency('т', 0, 0.06318),
    Frequency('с', 0, 0.05473),
    Frequency('р', 0, 0.04746),
    Frequency('в', 0, 0.04533),
    Frequency('л', 0, 0.04343),
    Frequency('к', 0, 0.03486),
    Frequency('м', 0, 0.03203),
    Frequency('д', 0, 0.02977),
    Frequency('п', 0, 0.02804),
    Frequency('у', 0, 0.02615),
    Frequency('я', 0, 0.02001),
    Frequency('ы', 0, 0.01898),
    Frequency('ь', 0, 0.01735),
    Frequency('г', 0, 0.01687),
    Frequency('з', 0, 0.01641),
    Frequency('б', 0, 0.01592),
    Frequency('ч', 0, 0.01450),
    Frequency('й', 0, 0.01208),
    Frequency('х', 0, 0.00966),
    Frequency('ж', 0, 0.00940),
    Frequency('ш', 0, 0.00718),
    Frequency('ю', 0, 0.00639),
    Frequency('ц', 0, 0.00486),
    Frequency('щ', 0, 0.00361),
    Frequency('э', 0, 0.00331),
    Frequency('ф', 0, 0.00267),
    Frequency('ъ', 0, 0.00037),
    Frequency('ё', 0, 0.00013)
  ];
}