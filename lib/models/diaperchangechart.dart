class diaperChange{
  final DateTime dateOf;
  final String typeOf;
  diaperChange(this.dateOf, this.typeOf);

  //check if null or not, if not then assign to
  diaperChange.fromMap(Map<String,dynamic> map)
  :assert(map['dateOf']!=null),
  assert(map['typeOf']!=null),
    dateOf=map['dateOf'],
    typeOf=map['typeOf'];
}