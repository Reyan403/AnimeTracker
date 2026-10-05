enum EveningMood {
  any({}),
  relaxed({'comedy', 'slice-of-life'}),
  action({'action', 'adventure'}),
  emotional({'drama'}),
  romance({'romance'}),
  mystery({'mystery', 'psychological', 'thriller'}),
  fantasy({'fantasy'}),
  scienceFiction({'science-fiction'}),
  supernatural({'supernatural'}),
  horror({'horror'}),
  sports({'sports'});

  const EveningMood(this.genreSlugs);

  final Set<String> genreSlugs;
}
