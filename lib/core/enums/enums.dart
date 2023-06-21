enum ThemeMode {
  light,
  dark,
}

enum UserKarma {
  comment(3),
  textpost(1),
  imagepost(1),
  linkpost(1),
  deletepost(1),
  awardspost(1);

  final int karma;
  const UserKarma(this.karma);
}
