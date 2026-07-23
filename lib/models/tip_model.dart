enum TipType { parenting, nutrition }

class TipModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final TipType type;
  final String ageGroup; // e.g., 'Infant', 'Toddler', 'Preschooler'
  final String iconName;

  TipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.type,
    required this.ageGroup,
    required this.iconName,
  });

  static List<TipModel> get dummyTips {
    return [
      // Parenting Tips
      TipModel(
        id: 't1',
        title: 'Positibong Disiplina',
        description: 'Alamin ang kahalagahan ng gabay sa halip na parusa para sa inyong anak.',
        content: 'Ang positibong disiplina ay nakatutok sa pagtuturo ng tamang asal sa pamamagitan ng komunikasyon at empatiya. Hikayatin ang magandang gawi gamit ang papuri. Bigyan sila ng malinaw at makatwirang mga limitasyon.',
        type: TipType.parenting,
        ageGroup: 'Toddler (1-3 Taon)',
        iconName: 'favorite',
      ),
      TipModel(
        id: 't2',
        title: 'Kahalagahan ng Paglalaro',
        description: 'Tuklasin kung paano nagiging tulay ang paglalaro sa talino ng bata.',
        content: 'Sa pamamagitan ng paglalaro, natututunan ng bata ang paglutas ng problema, pakikisalamuha sa kapwa, at koordinasyon ng katawan. Maglaan ng hindi bababa sa 30 minuto araw-araw para makipaglaro sa kanila.',
        type: TipType.parenting,
        ageGroup: 'Lahat ng Edad',
        iconName: 'sports_esports',
      ),
      TipModel(
        id: 't3',
        title: 'Pagtutulog ng Sapat at Regular',
        description: 'Gabay sa tamang haba at oras ng tulog ng inyong sanggol.',
        content: 'Ang sapat na tulog ay mahalaga para sa paglaki ng utak at katawan. Ang mga sanggol (0-12 buwan) ay nangangailangan ng 12-16 na oras ng tulog kada araw, kasama na ang naps.',
        type: TipType.parenting,
        ageGroup: 'Sanggol (0-12 Buwan)',
        iconName: 'bedtime',
      ),
      // Nutrition Tips
      TipModel(
        id: 't4',
        title: 'Eksklusibong Pagpapasuso',
        description: 'Ang gatas ng ina ang pinakamahusay na nutrisyon para sa unang 6 na buwan.',
        content: 'Ang gatas ng ina ay naglalaman ng mga antibodies na nagbibigay-proteksyon laban sa impeksyon at sakit. Iwasang magbigay ng tubig o ibang pagkain hangga\'t hindi sumasapit ang ika-6 na buwan.',
        type: TipType.nutrition,
        ageGroup: 'Sanggol (0-6 Buwan)',
        iconName: 'child_care',
      ),
      TipModel(
        id: 't5',
        title: 'Pagpapakilala ng Solid Food',
        description: 'Gabay sa unti-unting pagpapakain ng mga solidong pagkain pagkatapos ng 6 na buwan.',
        content: 'Magsimula sa malalambot na katas tulad ng nilagang patatas, saging, o lugaw. Ipakilala ang bagong pagkain nang isa-isa tuwing 3-5 araw upang malaman kung may allergy ang bata.',
        type: TipType.nutrition,
        ageGroup: 'Sanggol (6-12 Buwan)',
        iconName: 'restaurant',
      ),
      TipModel(
        id: 't6',
        title: 'Makulay na Pinggan (Pinggang Pinoy)',
        description: 'Ihain ang balanseng pagkain na mayaman sa Go, Grow, at Glow.',
        content: 'Siguraduhing may sapat na prutas at gulay (Glow), protina tulad ng isda o karne (Grow), at carbohydrates gaya ng kanin o tinapay (Go) sa bawat hain para sa masiglang katawan.',
        type: TipType.nutrition,
        ageGroup: 'Toddler (1-3 Taon)',
        iconName: 'rice_bowl',
      ),
    ];
  }
}
