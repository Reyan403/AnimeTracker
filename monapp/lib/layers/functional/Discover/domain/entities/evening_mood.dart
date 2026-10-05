enum EveningMood {
  any({}),
  relaxed({'comedy', 'slice-of-life'}),
  action({'action', 'adventure'}),
  emotional({'drama', 'romance'}),
  mystery({'mystery', 'psychological', 'thriller'});

  const EveningMood(this.genreSlugs);

  final Set<String> genreSlugs;
}
