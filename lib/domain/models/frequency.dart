class Frequency{
  String character;
  int count;
  double frequencyOfUse;

  Frequency(this.character,this.count,this.frequencyOfUse);

  factory Frequency.calc(String message,String pattern){
    if(message.isEmpty) return Frequency(pattern, 0,0);

    int count = pattern.allMatches(message).length;
    double frUse = count/message.length;
    return Frequency(pattern, count,frUse);
  }
}