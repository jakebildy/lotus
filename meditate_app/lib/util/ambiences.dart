class Ambience {
  final String name;
  final String image;
  final String audio;
  final String setting;
  final bool premium;

  const Ambience(
      {required this.name,
      required this.image,
      required this.audio,
      required this.setting,
      required this.premium})
      : super();
}

// ignore: constant_identifier_names
const List<Ambience> AMBIENCES = [
  Ambience(
      name: "None",
      image: 'assets/ambiences/none.jpg',
      audio: '',
      setting: 'Default',
      premium: false),
  Ambience(
      name: "Water Sounds",
      image: 'assets/ambiences/water_sounds.jpg',
      audio: 'assets/audio/water_sounds.mp3',
      setting: 'Default',
      premium: false),
  Ambience(
      name: "Night",
      image: 'assets/stars.jpg',
      audio: 'assets/audio/night.mp3',
      setting: 'Night',
      premium: false),
  Ambience(
      name: "At Chapter's End",
      image: 'assets/ambiences/at_chapters_end.png',
      audio: 'assets/audio/at_chapters_end.mp3',
      setting: 'Default',
      premium: false),
  Ambience(
      name: "Rain",
      image: 'assets/ambiences/rain.jpg',
      audio: 'assets/audio/rain.mp3',
      setting: 'Rain',
      premium: true),
  Ambience(
      name: "Mourning Doves",
      image: 'assets/ambiences/mourning_doves.jpg',
      audio: 'assets/audio/mourning_doves.mp3',
      setting: 'Default',
      premium: true),
  Ambience(
      name: "Forest",
      image: 'assets/ambiences/forest.jpg',
      audio: 'assets/audio/forest.mp3',
      setting: 'Forest',
      premium: true),
  Ambience(
      name: "Wind",
      image: 'assets/ambiences/wind.jpg',
      audio: 'assets/audio/wind.mp3',
      setting: 'Default',
      premium: true),
  Ambience(
      name: "Underwater",
      image: 'assets/ambiences/underwater.jpg',
      audio: 'assets/audio/underwater.mp3',
      setting: 'Underwater',
      premium: true),
  Ambience(
      name: "Jungle",
      image: 'assets/ambiences/jungle.jpg',
      audio: 'assets/audio/jungle.mp3',
      setting: 'Jungle',
      premium: true),
  Ambience(
      name: "Beach",
      image: 'assets/ambiences/beach.jpg',
      audio: 'assets/audio/beach.mp3',
      setting: 'Default',
      premium: true),
  Ambience(
      name: "Thunderstorm",
      image: 'assets/ambiences/thunderstorm.jpg',
      audio: 'assets/audio/thunderstorm.mp3',
      setting: 'Rain',
      premium: true),
  Ambience(
      name: "Extradimensional",
      image: 'assets/ambiences/extradimensional.jpg',
      audio: 'assets/audio/extradimensional.mp3',
      setting: 'Extradimensional',
      premium: true),
  Ambience(
      name: "Lost Civilization",
      image: 'assets/ambiences/lostcivilization.jpg',
      audio: 'assets/audio/lostcivilization.mp3',
      setting: 'Jungle',
      premium: true),
  Ambience(
      name: "Prehistoric Sea",
      image: 'assets/ambiences/prehistoricsea.jpg',
      audio: 'assets/audio/prehistoricsea.mp3',
      setting: 'Underwater',
      premium: true),
  Ambience(
      name: "Random",
      image: 'assets/ambiences/random.jpg',
      audio: 'assets/audio/water_sounds.mp3',
      setting: 'Default',
      premium: true),
];


//Maybe Jurassic?