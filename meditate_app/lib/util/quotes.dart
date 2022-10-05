import 'dart:math';

List<String> quotes = [
  '"All we have to decide is what to do with the time that is given us." \n- Gandalf',
  "“If you look for the light, you can often find it. But if you look for the dark, that is all you will ever see.” \n– Uncle Iroh",
  "“Hope is something you give yourself. That is the meaning of inner strength.” \n– Uncle Iroh",
  "“I sit in silence and find whenever I meditate, my fears alleviate, my tears evaporate” \n- J. Cole",
  "“Anything’s possible, you gotta dream like you never seen obstacles.” \n- J. Cole",
  "“No such thing as a life that’s better than yours, no such thing..” \n- J. Cole",
  "“Life can bring much pain. There are many ways to deal with this pain. Choose wisely.” \n- J. Cole",
  "“I’d rather be happy being myself than sad trying to please everyone else.” \n- J. Cole",
  "“Take a chance, because you never know how perfect something can turn out.” \n- J. Cole",
  "“Muddy water is best cleared by leaving it alone.” \n- Alan Watts",
  "“This is the real secret of life -- to be completely engaged with what you are doing in the here and now.” \n- Alan Watts",
  "“The meaning of life is just to be alive. It is so plain and so obvious and so simple.” \n- Alan Watts",
  "“When you are content to be simply yourself and don't compare or compete, everyone will respect you.” \n- Lao Tzu",
  "“Time is a created thing. To say 'I don't have time,' is like saying, 'I don't want to.” \n- Lao Tzu",
  "“Care about what other people think and you will always be their prisoner.” \n- Lao Tzu",
  "“Nature does not hurry, yet everything is accomplished.” \n- Lao Tzu",
  "“To a mind that is still the whole universe surrenders.” \n- Lao Tzu",
  "“If you are anxious you are living in the future. If you are at peace you are living in the present.” \n- Lao Tzu",
  "“Stop leaving and you will arrive. Stop searching and you will see. Stop running away and you will be found.” \n- Lao Tzu",
  "“We’ve all got both light and dark inside us. What matters is the part we choose to act on. That’s who we really are.” \n- Sirius Black",
  "“It does not do to dwell on dreams and forget to live.” \n- Dumbledore",
  "“It is the unknown we fear when we look upon death and darkness, nothing more.” \n- Albus Dumbledore",
  "“Imagination brings bliss at no cost.” \n- Nujabes",
  "“You have power over your mind - not outside events. Realize this, and you will find strength.” \n- Marcus Aurelius",
  "“Dwell on the beauty of life. Watch the stars, and see yourself running with them.” \n- Marcus Aurelius",
  "“The happiness of your life depends upon the quality of your thoughts.” \n- Marcus Aurelius",
  "“It is not death that a man should fear, but he should fear never beginning to live.” \n- Marcus Aurelius",
  "“Our life is what our thoughts make it.” \n- Marcus Aurelius",
];

String randomQuote() {
  return quotes[Random().nextInt(quotes.length)];
}
