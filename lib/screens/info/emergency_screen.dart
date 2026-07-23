import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tulong at Hotlines Pang-emergency'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Alert Card
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.red.shade200, width: 1.5),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'PAALALA: Kung malubha o kritikal ang kalagayan ng bata, dalahin agad sa pinakamalapit na ospital o tumawag ng ambulansya!',
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Emergency Numbers Section
            Text(
              'Mga Numero ng Telepono (Hotlines)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildHotlineCard(
              title: 'Barangay Health Center',
              number: '(02) 8123-4567',
              icon: Icons.local_hospital,
            ),
            _buildHotlineCard(
              title: 'Pambansang Ambulansya (NDRRMC)',
              number: '911',
              icon: Icons.emergency,
            ),
            _buildHotlineCard(
              title: 'BFP (Kawanihan ng Pagtatanggol sa Sunog)',
              number: '(02) 8426-0246',
              icon: Icons.fire_truck,
            ),

            const SizedBox(height: 24),

            // First-Aid Guides
            Text(
              'Gabay sa Unang Saklolo (First-Aid Guides)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildGuideCard(
              title: '1. Mataas na Lagnat (High Fever)',
              steps: [
                'Huwag balutin ng makapal na kumot ang bata.',
                'Punasan ang katawan ng maligamgam na tubig (sponge bath). Huwag gumamit ng alkohol o malamig na tubig.',
                'Bigyan ng Paracetamol batay sa tamang timbang at rekomendasyon ng doktor.',
                'Painumin ng maraming tubig o gatas upang maiwasan ang dehydration.',
              ],
            ),
            const SizedBox(height: 12),

            _buildGuideCard(
              title: '2. Nabulunan (Choking)',
              steps: [
                'Kung nakakaubo o nakakapagsalita pa ang bata, hikayatin siyang umubo nang malakas.',
                'Para sa sanggol na wala pang isang taon: Iposisyon nang nakadapa sa braso at tapikin ang likod (back blows) ng 5 beses gamit ang palad.',
                'Para sa mas malaking bata: Magsagawa ng Heimlich maneuver sa pamamagitan ng pagyakap mula sa likod at pagdiin sa tiyan pataas.',
              ],
            ),
            const SizedBox(height: 12),

            _buildGuideCard(
              title: '3. Napaso (Burns)',
              steps: [
                'Hugasan agad ang bahaging napaso ng umaagos at malinis na tubig sa loob ng 10-15 minuto.',
                'Huwag lalagyan ng toothpaste, mantikilya, o yelo ang paso.',
                'Takpan ng malinis at tuyong tela o gauze ang bahaging napaso.',
                'Kumonsulta agad sa doktor kung nagkapaltos o malaki ang pinsala.',
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHotlineCard({
    required String title,
    required String number,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(number, style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: const CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.phone, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required String title,
    required List<String> steps,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right_alt, color: Colors.redAccent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(step, style: const TextStyle(fontSize: 13, height: 1.4)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
