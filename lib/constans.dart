
import 'domain/models/alphabets_key.dart';
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

  static List<AlphabetsKeys> russianAlphabetKeys = [

/*    [
      [12, 16, 5, 16],
      [3, 16, 6, 34],
      [19, 13, 16, 3],
      [16, 34, 8, 6]
    ]*/

    AlphabetsKeys(character: 'А', key: 0),
    AlphabetsKeys(character: 'Б', key: 1),
    AlphabetsKeys(character: 'В', key: 2),
    AlphabetsKeys(character: 'Г', key: 3),
    AlphabetsKeys(character: 'Д', key: 4),
    AlphabetsKeys(character: 'Е', key: 5),
    AlphabetsKeys(character: 'Ё', key: 6),
    AlphabetsKeys(character: 'Ж', key: 7),
    AlphabetsKeys(character: 'З', key: 8),
    AlphabetsKeys(character: 'И', key: 9),
    AlphabetsKeys(character: 'Й', key: 10),
    AlphabetsKeys(character: 'К', key: 11),
    AlphabetsKeys(character: 'Л', key: 12),
    AlphabetsKeys(character: 'М', key: 13),
    AlphabetsKeys(character: 'Н', key: 14),
    AlphabetsKeys(character: 'О', key: 15),
    AlphabetsKeys(character: 'П', key: 16),
    AlphabetsKeys(character: 'Р', key: 17),
    AlphabetsKeys(character: 'С', key: 18),
    AlphabetsKeys(character: 'Т', key: 19),
    AlphabetsKeys(character: 'У', key: 20),
    AlphabetsKeys(character: 'Ф', key: 21),
    AlphabetsKeys(character: 'Х', key: 22),
    AlphabetsKeys(character: 'Ц', key: 23),
    AlphabetsKeys(character: 'Ч', key: 24),
    AlphabetsKeys(character: 'Ш', key: 25),
    AlphabetsKeys(character: 'Щ', key: 26),
    AlphabetsKeys(character: 'Ь', key: 27),
    AlphabetsKeys(character: 'Ы', key: 28),
    AlphabetsKeys(character: 'Ъ', key: 29),
    AlphabetsKeys(character: 'Э', key: 30),
    AlphabetsKeys(character: 'Ю', key: 31),
    AlphabetsKeys(character: 'Я', key: 32),
    AlphabetsKeys(character: '.', key: 33),
    AlphabetsKeys(character: ',', key: 34),
    AlphabetsKeys(character: ' ', key: 35),
    AlphabetsKeys(character: '?', key: 36),
    //AlphabetsKeys(character: '!', key: 36),

  ];


}