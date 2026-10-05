enum EveningDuration {
  short(30),
  medium(60),
  long(120),
  unlimited(null);

  const EveningDuration(this.minutes);

  final int? minutes;
}
