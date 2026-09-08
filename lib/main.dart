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

  double? _density;
  double? _icumsaColor;

  double _getDensityFromBrix(double brix) {
    return 0.998234 +
        (0.003855 * brix) +
        (0.0000155 * pow(brix, 2)) +
        (0.00000004 * pow(brix, 3));
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double absorbance = double.parse(_absorbanceController.text);
      final double cellLength = double.parse(_cellLengthController.text);
      final double brix = double.parse(_brixController.text);

      final double calculatedDensity = _getDensityFromBrix(brix);
      final double color = (100000000 * absorbance) / (cellLength * brix * calculatedDensity);

      setState(() {
        _density = calculatedDensity;
        _icumsaColor = color;
      });
    }
  }

  void _reset() {
    _absorbanceController.clear();
    _cellLengthController.text = '1.0';
    _brixController.clear();
    setState(() {
      _density = null;
      _icumsaColor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Color ICUMSA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B365D),
        elevation: 2,
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
                              '${_density!.toStringAsFixed(4)} g/cm³',
                              style: const TextStyle(fontWeight: FontWeight.bold),
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
