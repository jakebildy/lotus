class Ambience {
  final String name;
  final String image;
  final String audio;
  final bool premium;

  const Ambience(
      {required this.name,
      required this.image,
      required this.audio,
      required this.premium})
      : super();
}

const List<Ambience> AMBIENCES = [
  // Ambience(
  //   name: "OFF",
  //   image: 'assets/ambiences/random.jpg',
  //   audio: '',
  //   premium: false),
  Ambience(
      name: "Water Sounds",
      image: 'assets/ambiences/water_sounds.jpg',
      audio: 'assets/audio/water_sounds.wav',
      premium: false),
  Ambience(
      name: "Night",
      image: 'assets/stars.jpg',
      audio: 'assets/audio/night.wav',
      premium: false),
  Ambience(
      name: "Mourning Doves",
      image: 'assets/ambiences/mourning_doves.jpg',
      audio: 'assets/audio/mourning_doves.wav',
      premium: true),
  Ambience(
      name: "Forest",
      image: 'assets/ambiences/forest.jpg',
      audio: 'assets/audio/forest.mp3',
      premium: true),
  Ambience(
      name: "Wind",
      image: 'assets/ambiences/wind.jpg',
      audio: 'assets/audio/wind.wav',
      premium: true),
  Ambience(
      name: "Random",
      image: 'assets/ambiences/random.jpg',
      audio: 'assets/audio/water_sounds.wav',
      premium: true),
];
