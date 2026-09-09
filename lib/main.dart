import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const IcumsaApp());
}

class IcumsaApp extends StatelessWidget {
  const IcumsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora ICUMSA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B365D)),
        useMaterial3: true,
      ),
      home: const IcumsaCalculator(),
    );
  }
}

class IcumsaCalculator extends StatefulWidget {
  const IcumsaCalculator({super.key});

  @override
  State<IcumsaCalculator> createState() => _IcumsaCalculatorState();
}

class _IcumsaCalculatorState extends State<IcumsaCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _absorbanceController = TextEditingController();
  final _cellLengthController = TextEditingController(text: '1.0');
  final _brixController = TextEditingController();

  // Factor configurable por defecto ajustado a 1,000,000
  double _factorICUMSA = 1000000.0;

  double? _densityKgM3;
  double? _icumsaColor;

  // Cálculo de densidad precisa ajustada a la tabla ICUMSA a 20 °C en kg/m³
  double _getDensityInKgM3(double brix) {
    return 998.203 +
        (3.8507 * brix) +
        (0.0133 * pow(brix, 2)) +
        (0.000028 * pow(brix, 3));
  }

  // Formato para densidad en estilo "1,125.94"
  String _formatDensity(double density) {
    final List<String> parts = density.toStringAsFixed(2).split('.');
    final String integerPart = parts[0];
    final String decimalPart = parts[1];

    final RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final String formattedInteger = integerPart.replaceAllMapped(reg, (Match m) => '${m[0]},');

    return '$formattedInteger.$decimalPart';
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double absorbance = double.parse(_absorbanceController.text);
      final double cellLength = double.parse(_cellLengthController.text);
      final double brix = double.parse(_brixController.text);

      final double calculatedDensityKgM3 = _getDensityInKgM3(brix);
      final double densityGcm3 = calculatedDensityKgM3 / 1000.0;

      // Fórmula ICUMSA: (Absorbancia * Factor) / (Celda * Brix * Densidad g/cm³)
      final double color = (_factorICUMSA * absorbance) / (cellLength * brix * densityGcm3);

      setState(() {
        _densityKgM3 = calculatedDensityKgM3;
        _icumsaColor = color;
      });
    }
  }

  void _reset() {
    _absorbanceController.clear();
    _cellLengthController.text = '1.0';
    _brixController.clear();
    setState(() {
      _densityKgM3 = null;
      _icumsaColor = null;
    });
  }

  void _openSettings() async {
    final double? newFactor = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(currentFactor: _factorICUMSA),
      ),
    );

    if (newFactor != null) {
      setState(() {
        _factorICUMSA = newFactor;
      });
      if (_absorbanceController.text.isNotEmpty && _brixController.text.isNotEmpty) {
        _calculate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Color ICUMSA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B365D),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Configurar Factores',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _absorbanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Absorbancia (Ad a 420 nm)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.waves),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese la absorbancia';
                          if (double.tryParse(value) == null) return 'Valor numérico inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cellLengthController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Longitud de celda b (cm)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese la longitud de celda';
                          final val = double.tryParse(value);
                          if (val == null || val <= 0) return 'Debe ser mayor a 0';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _brixController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Grados Brix (°Brix)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.science),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese los Brix';
                          final val = double.tryParse(value);
                          if (val == null || val <= 0) return 'Debe ser mayor a 0';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B365D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('CALCULAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Limpiar',
                  ),
                ],
              ),
              if (_icumsaColor != null) ...[
                const SizedBox(height: 25),
                Card(
                  color: const Color(0xFFE8EEF5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'RESULTADO ICUMSA',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _icumsaColor!.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                        ),
                        const Text('UI (Unidades ICUMSA)', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Densidad calculada (ρ):'),
                            Text(
                              '${_formatDensity(_densityKgM3!)} kg/m³',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Factor multiplicador actual:'),
                            Text(
                              _factorICUMSA.toStringAsFixed(0),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final double currentFactor;
  const SettingsScreen({super.key, required this.currentFactor});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _factorController;

  @override
  void initState() {
    super.initState();
    _factorController = TextEditingController(text: widget.currentFactor.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Factores', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1B365D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Factor de la Fórmula ICUMSA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajuste el factor según la escala utilizada en su laboratorio:\n'
              '• 1,000,000 (Por defecto - Celda en cm, RDS en %)\n'
              '• 100,000\n'
              '• 10,000,000',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _factorController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Factor Multiplicador',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calculate),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final double? val = double.tryParse(_factorController.text);
                if (val != null && val > 0) {
                  Navigator.pop(context, val);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B365D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('GUARDAR Y APLICAR', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
