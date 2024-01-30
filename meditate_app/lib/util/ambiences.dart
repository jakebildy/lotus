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
  // Ambience(
  //   name: "OFF",
  //   image: 'assets/ambiences/random.jpg',
  //   audio: '',
  //   premium: false),
  Ambience(
      name: "Water Sounds",
      image: 'assets/ambiences/water_sounds.jpg',
      audio: 'assets/audio/water_sounds.wav',
      setting: 'Default',
      premium: false),
  Ambience(
      name: "Night",
      image: 'assets/stars.jpg',
      audio: 'assets/audio/night.wav',
      setting: 'Night',
      premium: false),
  Ambience(
      name: "Rain",
      image: 'assets/ambiences/rain.jpg',
      audio: 'assets/audio/rain.wav',
      setting: 'Rain',
      premium: true),
  Ambience(
      name: "Mourning Doves",
      image: 'assets/ambiences/mourning_doves.jpg',
      audio: 'assets/audio/mourning_doves.wav',
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
      audio: 'assets/audio/wind.wav',
      setting: 'Default',
      premium: true),
  Ambience(
      name: "Underwater",
      image: 'assets/ambiences/underwater.jpg',
      audio: 'assets/audio/underwater.wav',
      //TODO: crossfade so its loopable
      setting: 'Underwater',
      premium: true),
  Ambience(
      name: "Jungle",
      //TODO: from the one in your downloads, crop sound
      image: 'assets/ambiences/jungle.jpg',
      audio: 'assets/audio/jungle.wav',
      setting: 'Jungle',
      premium: true),
  Ambience(
      name: "Beach",
      image: 'assets/ambiences/beach.jpg',
      audio: 'assets/audio/beach.wav',
      setting: 'Default',
      premium: true),
  Ambience(
      name: "Thunderstorm",
      image: 'assets/ambiences/thunderstorm.jpg',
      audio: 'assets/audio/thunderstorm.wav',
      setting: 'Rain',
      premium: true),
  Ambience(
      name: "Extradimensional",
      image: 'assets/ambiences/extradimensional.jpg',
      audio: 'assets/audio/extradimensional.wav',
      setting: 'Extradimensional',
      premium: true),
  Ambience(
      name: "Lost Civilization",
      image: 'assets/ambiences/lostcivilization.jpg',
      audio: 'assets/audio/lostcivilization.wav',
      setting: 'Jungle',
      premium: true),
  Ambience(
      name: "Prehistoric Sea",
      image: 'assets/ambiences/prehistoricsea.jpg',
      audio: 'assets/audio/prehistoricsea.wav',
      setting: 'Underwater',
      premium: true),
  Ambience(
      name: "Random",
      image: 'assets/ambiences/random.jpg',
      audio: 'assets/audio/water_sounds.wav',
      setting: 'Default',
      premium: true),
];


//Maybe Jurassic?