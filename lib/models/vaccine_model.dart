class VaccineModel {
  final String id;
  final String name;
  final String ageRange; // e.g., 'At Birth', '1.5 Months', '6 Months'
  final String description;
  final String diseasePrevented;
  final bool isMandatory;

  VaccineModel({
    required this.id,
    required this.name,
    required this.ageRange,
    required this.description,
    required this.diseasePrevented,
    this.isMandatory = true,
  });

  static List<VaccineModel> get dummyVaccines {
    return [
      VaccineModel(
        id: 'v1',
        name: 'BCG Vaccine',
        ageRange: 'Pagkapanganak',
        description: 'Proteksyon laban sa tuberculosis meningitis at malalang tisis.',
        diseasePrevented: 'Tuberculosis (Tisis)',
      ),
      VaccineModel(
        id: 'v2',
        name: 'Hepatitis B Vaccine (1st dose)',
        ageRange: 'Pagkapanganak',
        description: 'Iniwasan ang impeksyon sa atay sanhi ng Hepatitis B virus.',
        diseasePrevented: 'Hepatitis B',
      ),
      VaccineModel(
        id: 'v3',
        name: 'Pentavalent Vaccine (1st dose)',
        ageRange: '1.5 Buwan',
        description: 'Pinagsamang bakuna laban sa Diphtheria, Tetanus, Pertussis, Hep B, at Hib.',
        diseasePrevented: 'Diphtheria, Tetanus, Pertussis, Hep B, Hib',
      ),
      VaccineModel(
        id: 'v4',
        name: 'Oral Polio Vaccine (OPV - 1st dose)',
        ageRange: '1.5 Buwan',
        description: 'Iniwasan ang poliomyelitis na nagdudulot ng paralisis sa mga bata.',
        diseasePrevented: 'Polio',
      ),
      VaccineModel(
        id: 'v5',
        name: 'Pneumococcal Conjugate Vaccine (PCV - 1st dose)',
        ageRange: '1.5 Buwan',
        description: 'Proteksyon laban sa pulmonya, meningitis, at impeksyon sa tenga.',
        diseasePrevented: 'Pulmonya at Meningitis',
      ),
      VaccineModel(
        id: 'v6',
        name: 'Pentavalent Vaccine (2nd dose)',
        ageRange: '2.5 Buwan',
        description: 'Pangalawang dose ng 5-in-1 combo vaccine.',
        diseasePrevented: 'Diphtheria, Tetanus, Pertussis, Hep B, Hib',
      ),
      VaccineModel(
        id: 'v7',
        name: 'OPV (2nd dose)',
        ageRange: '2.5 Buwan',
        description: 'Pangalawang patak para sa polio prevention.',
        diseasePrevented: 'Polio',
      ),
      VaccineModel(
        id: 'v8',
        name: 'PCV (2nd dose)',
        ageRange: '2.5 Buwan',
        description: 'Pangalawang dose laban sa pulmonya at meningitis.',
        diseasePrevented: 'Pulmonya at Meningitis',
      ),
      VaccineModel(
        id: 'v9',
        name: 'Pentavalent Vaccine (3rd dose)',
        ageRange: '3.5 Buwan',
        description: 'Pangatlong dose ng 5-in-1 combo vaccine para sa buong proteksyon.',
        diseasePrevented: 'Diphtheria, Tetanus, Pertussis, Hep B, Hib',
      ),
      VaccineModel(
        id: 'v10',
        name: 'OPV (3rd dose)',
        ageRange: '3.5 Buwan',
        description: 'Pangatlong patak para sa polio prevention.',
        diseasePrevented: 'Polio',
      ),
      VaccineModel(
        id: 'v11',
        name: 'Inactivated Polio Vaccine (IPV)',
        ageRange: '3.5 Buwan',
        description: 'Itinurok na polio vaccine para sa mas malakas na proteksyon.',
        diseasePrevented: 'Polio',
      ),
      VaccineModel(
        id: 'v12',
        name: 'PCV (3rd dose)',
        ageRange: '3.5 Buwan',
        description: 'Pangatlong dose laban sa pulmonya at meningitis.',
        diseasePrevented: 'Pulmonya at Meningitis',
      ),
      VaccineModel(
        id: 'v13',
        name: 'Measles, Mumps, Rubella (MMR - 1st dose)',
        ageRange: '9 na Buwan',
        description: 'Unang dose na nagbibigay-proteksyon laban sa tigdas, biki, at rubella.',
        diseasePrevented: 'Tigdas, Biki, Rubella',
      ),
      VaccineModel(
        id: 'v14',
        name: 'MMR (2nd dose / Booster)',
        ageRange: '12 Buwan',
        description: 'Karagdagang dose para sa kumpletong proteksyon laban sa MMR.',
        diseasePrevented: 'Tigdas, Biki, Rubella',
      ),
      VaccineModel(
        id: 'v15',
        name: 'DTaP & Polio Booster',
        ageRange: '6 na Taon',
        description: 'Booster dose para patuloy na maiwasan ang Diphtheria, Tetanus, Pertussis, at Polio.',
        diseasePrevented: 'Diphtheria, Tetanus, Pertussis, Polio',
      ),
      VaccineModel(
        id: 'v16',
        name: 'HPV Vaccine (1st dose)',
        ageRange: '12 na Taon',
        description: 'Proteksyon laban sa Human Papillomavirus na nagdudulot ng iba\'t ibang uri ng kanser.',
        diseasePrevented: 'Human Papillomavirus (HPV)',
      ),
      VaccineModel(
        id: 'v17',
        name: 'Tdap Booster & Influenza',
        ageRange: '18 na Taon',
        description: 'Tetanus, Diphtheria, at Atypical Pertussis booster kasama ang taunang bakuna laban sa trangkaso.',
        diseasePrevented: 'Trangkaso, Tetanus, Diphtheria, Pertussis',
      ),
    ];
  }
}
