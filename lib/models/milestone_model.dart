enum MilestoneCategory { social, language, cognitive, motor }

class MilestoneModel {
  final String id;
  final String ageRange; // e.g., '2 Months', '6 Months', '1 Year'
  final String description;
  final MilestoneCategory category;

  MilestoneModel({
    required this.id,
    required this.ageRange,
    required this.description,
    required this.category,
  });

  String get categoryName {
    switch (category) {
      case MilestoneCategory.social:
        return 'Sosyal at Emosyonal';
      case MilestoneCategory.language:
        return 'Komunikasyon / Wika';
      case MilestoneCategory.cognitive:
        return 'Pagsusuri / Kaisipan';
      case MilestoneCategory.motor:
        return 'Pagkilos / Pisikal';
    }
  }

  static List<MilestoneModel> get dummyMilestones {
    return [
      // 2 Months
      MilestoneModel(
        id: 'm1',
        ageRange: '2 Months',
        description: 'Tumingin sa mukha ng magulang at ngumiti nang kusa.',
        category: MilestoneCategory.social,
      ),
      MilestoneModel(
        id: 'm2',
        ageRange: '2 Months',
        description: 'Gumawa ng mga tunog na parang humuhuni (cooing).',
        category: MilestoneCategory.language,
      ),
      MilestoneModel(
        id: 'm3',
        ageRange: '2 Months',
        description: 'Sundin ang mga gumagalaw na bagay gamit ang mga mata.',
        category: MilestoneCategory.cognitive,
      ),
      MilestoneModel(
        id: 'm4',
        ageRange: '2 Months',
        description: 'Itaas ang ulo habang nakadapa.',
        category: MilestoneCategory.motor,
      ),
      // 6 Months
      MilestoneModel(
        id: 'm5',
        ageRange: '6 Months',
        description: 'Kilalanin ang mga pamilyar na mukha at tumugon sa emosyon.',
        category: MilestoneCategory.social,
      ),
      MilestoneModel(
        id: 'm6',
        ageRange: '6 Months',
        description: 'Magsalita ng mga patinig tulad ng "ah", "eh", "oh" at gumawa ng babble.',
        category: MilestoneCategory.language,
      ),
      MilestoneModel(
        id: 'm7',
        ageRange: '6 Months',
        description: 'Dumalhin ng mga laruan o bagay mula sa isang kamay patungo sa kabila.',
        category: MilestoneCategory.cognitive,
      ),
      MilestoneModel(
        id: 'm8',
        ageRange: '6 Months',
        description: 'Gumulong sa parehong direksyon (likod-pa-harap at harap-pa-likod).',
        category: MilestoneCategory.motor,
      ),
      // 1 Year
      MilestoneModel(
        id: 'm9',
        ageRange: '1 Year',
        description: 'Magpakita ng takot sa mga hindi kakilala at yakapin ang mga magulang.',
        category: MilestoneCategory.social,
      ),
      MilestoneModel(
        id: 'm10',
        ageRange: '1 Year',
        description: 'Sumubok na sabihin ang mga simpleng salita tulad ng "mama" o "dada".',
        category: MilestoneCategory.language,
      ),
      MilestoneModel(
        id: 'm11',
        ageRange: '1 Year',
        description: 'Ituro ang mga bagay para maakit ang pansin ng iba.',
        category: MilestoneCategory.cognitive,
      ),
      MilestoneModel(
        id: 'm12',
        ageRange: '1 Year',
        description: 'Tumayo nang mag-isa o lumakad nang hawak ang mga kamay.',
        category: MilestoneCategory.motor,
      ),
      // 2 Years
      MilestoneModel(
        id: 'm13',
        ageRange: '2 Years',
        description: 'Magpakita ng higit na kasarinlan at lumahok sa simpleng laro kasama ang iba.',
        category: MilestoneCategory.social,
      ),
      MilestoneModel(
        id: 'm14',
        ageRange: '2 Years',
        description: 'Magsabi ng mga pangungusap na may 2 hanggang 4 na salita.',
        category: MilestoneCategory.language,
      ),
      MilestoneModel(
        id: 'm15',
        ageRange: '2 Years',
        description: 'Sumunod sa mga simpleng tagubilin na may dalawang hakbang.',
        category: MilestoneCategory.cognitive,
      ),
      MilestoneModel(
        id: 'm16',
        ageRange: '2 Years',
        description: 'Tumakbo nang maayos, sumipa ng bola, at umakyat/bumaba ng hagdan.',
        category: MilestoneCategory.motor,
      ),
      // 5 Years
      MilestoneModel(
        id: 'm17',
        ageRange: '5 Years',
        description: 'Gusto niyang maging katulad at bigyang-kasiyahan ang mga kaibigan.',
        category: MilestoneCategory.social,
      ),
      MilestoneModel(
        id: 'm18',
        ageRange: '5 Years',
        description: 'Nagsasalita nang napakalinaw at gumagamit ng mga simpleng pangungusap sa hinaharap (future tense).',
        category: MilestoneCategory.language,
      ),
      MilestoneModel(
        id: 'm19',
        ageRange: '5 Years',
        description: 'Nakakabilang ng 10 o higit pang mga bagay, at marunong gumuhit ng tao.',
        category: MilestoneCategory.cognitive,
      ),
      MilestoneModel(
        id: 'm20',
        ageRange: '5 Years',
        description: 'Kayang tumayo sa isang paa sa loob ng 10 segundo o higit pa.',
        category: MilestoneCategory.motor,
      ),
      // 10 Years
      MilestoneModel(
        id: 'm21',
        ageRange: '10 Years',
        description: 'Nagpapakita ng higit na kasarinlan mula sa pamilya at nagsisimulang makaramdam ng peer pressure.',
        category: MilestoneCategory.social,
      ),
      MilestoneModel(
        id: 'm22',
        ageRange: '10 Years',
        description: 'May kakayahang talakayin ang mga komplikadong ideya o damdamin nang may sapat na vokabularyo.',
        category: MilestoneCategory.language,
      ),
      // 15 Years
      MilestoneModel(
        id: 'm23',
        ageRange: '15 Years',
        description: 'Nagsisimulang mag-isip nang abstract at bumuo ng sariling pagkakakilanlan (identity).',
        category: MilestoneCategory.cognitive,
      ),
      // 19 Years
      MilestoneModel(
        id: 'm24',
        ageRange: '19 Years',
        description: 'May sapat na kapanahunan sa pagdedesisyon, at handa para sa paglipat sa young adulthood.',
        category: MilestoneCategory.social,
      ),
      // 3 Years
      MilestoneModel(
        id: 'm25',
        ageRange: '3 Years',
        description: 'Nakikipaglaro sa ibang bata at kayang magsalita ng simpleng pangungusap.',
        category: MilestoneCategory.social,
      ),
      // 4 Years
      MilestoneModel(
        id: 'm26',
        ageRange: '4 Years',
        description: 'Kayang magsalita ng mahabang kwento at gumuhit ng simpleng hugis.',
        category: MilestoneCategory.cognitive,
      ),
      // 6 Years
      MilestoneModel(
        id: 'm27',
        ageRange: '6 Years',
        description: 'Nagsisimulang magbasa at magsulat ng mga simpleng salita.',
        category: MilestoneCategory.cognitive,
      ),
      // 7 Years
      MilestoneModel(
        id: 'm28',
        ageRange: '7 Years',
        description: 'Nakikipagtulungan sa mga kapangkat at nagpapakita ng mas malawak na lohika.',
        category: MilestoneCategory.social,
      ),
      // 8 Years
      MilestoneModel(
        id: 'm29',
        ageRange: '8 Years',
        description: 'Marunong magpahayag ng damdamin at mas gustong maglaro kasama ang kaibigan.',
        category: MilestoneCategory.social,
      ),
      // 9 Years
      MilestoneModel(
        id: 'm30',
        ageRange: '9 Years',
        description: 'Nagpapakita ng higit na kasarinlan at interes sa mga espesyal na libangan (hobbies).',
        category: MilestoneCategory.social,
      ),
      // 11 Years
      MilestoneModel(
        id: 'm31',
        ageRange: '11 Years',
        description: 'Nagsisimula ang pisikal na pagbabago (puberty) at pag-iisip sa hinaharap.',
        category: MilestoneCategory.motor,
      ),
      // 12 Years
      MilestoneModel(
        id: 'm32',
        ageRange: '12 Years',
        description: 'Mas malalim na abstract thinking at mas pamilyar sa pakikipagkaibigan.',
        category: MilestoneCategory.cognitive,
      ),
      // 13 Years
      MilestoneModel(
        id: 'm33',
        ageRange: '13 Years',
        description: 'Pagbuo ng sariling opinyon, pananaw, at personal na kasarinlan.',
        category: MilestoneCategory.social,
      ),
      // 14 Years
      MilestoneModel(
        id: 'm34',
        ageRange: '14 Years',
        description: 'Pagsusuri sa sarili at pagpaplano para sa pag-aaral at interes.',
        category: MilestoneCategory.cognitive,
      ),
      // 16 Years
      MilestoneModel(
        id: 'm35',
        ageRange: '16 Years',
        description: 'Handa sa mga responsibilidad sa paaralan o pamayanan.',
        category: MilestoneCategory.social,
      ),
      // 17 Years
      MilestoneModel(
        id: 'm36',
        ageRange: '17 Years',
        description: 'Mature na pakikipagkapwa-tao at pagpaplano ng karera.',
        category: MilestoneCategory.social,
      ),
      // 18 Years
      MilestoneModel(
        id: 'm37',
        ageRange: '18 Years',
        description: 'Handa sa independiyenteng pagkilos at pagdedesisyon.',
        category: MilestoneCategory.social,
      ),
    ];
  }
}
