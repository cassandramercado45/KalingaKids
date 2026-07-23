class FAQModel {
  final String question;
  final String answer;

  FAQModel({required this.question, required this.answer});

  static List<FAQModel> get dummyFAQs {
    return [
      FAQModel(
        question: 'Ano ang layunin ng KalingaKids app?',
        answer: 'Ang KalingaKids ay binuo upang magsilbing gabay sa mga magulang sa pagsubaybay sa kalusugan, paglaki (timbang at taas), bakuna, at pag-unlad ng kanilang mga anak mula pagsilang hanggang pagkabata.',
      ),
      FAQModel(
        question: 'Ligtas ba ang aking data sa application?',
        answer: 'Opo, ang lahat ng impormasyon ng inyong anak ay lokal na nakaimbak sa inyong mobile device gamit ang secure local storage (SharedPreferences) at hindi ito ibinabahagi sa kahit anong server nang walang pahintulot.',
      ),
      FAQModel(
        question: 'Paano kinukuha ang interpretasyon ng BMI?',
        answer: 'Ang BMI o Body Mass Index ay kinukuha gamit ang pormulang: Timbang (kg) / [Taas (m) * Taas (m)]. Ang nakukuhang resulta ay inihahambing sa mga kategoryang Underweight, Normal, Overweight, at Obese ayon sa pamantayan ng World Health Organization (WHO).',
      ),
      FAQModel(
        question: 'Ano ang dapat gawin kung makaligtaan ang iskedyul ng bakuna?',
        answer: 'Kung may nakaligtaang bakuna ang inyong anak, mangyaring makipag-ugnayan agad sa inyong pinakamalapit na Barangay Health Center o pedyatrisyan upang maisaayos ang catch-up vaccination schedule.',
      ),
      FAQModel(
        question: 'Paano magdagdag ng higit sa isang anak sa profile?',
        answer: 'Pumunta sa tab ng Profile at i-click ang "Magdagdag ng Anak". Punan ang pangalan, petsa ng kapanganakan, at iba pang detalye. Maaari mong piliin kung sinong anak ang nais mong subaybayan sa pamamagitan ng pag-tap sa kanilang pangalan sa listahan.',
      ),
    ];
  }
}
