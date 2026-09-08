import 'package:flutter/material.dart';

void main() {
  runApp(const ColorIcumsaApp());
}

class ColorIcumsaApp extends StatelessWidget {
  const ColorIcumsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Color ICUMSA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B365D)),
        useMaterial3: true,
      ),
      home: const CalculadoraColorScreen(),
    );
  }
}

class CalculadoraColorScreen extends StatefulWidget {
  const CalculadoraColorScreen({super.key});

  @override
  State<CalculadoraColorScreen> createState() => _CalculadoraColorScreenState();
}

class _CalculadoraColorScreenState extends State<CalculadoraColorScreen> {
  final TextEditingController _celdaController = TextEditingController(text: '2');
  final TextEditingController _brixController = TextEditingController();
  final TextEditingController _absorbanciaController = TextEditingController();

  double? _resultadoColor;
  String? _errorMensaje;

  // Base de datos de Densidades según Brix (Equivalente a 'Base de Datos'!A1:B33)
  final Map<double, double> _baseDatosDensidad = {
    29.7: 1124.51,
    29.8: 1124.99,
    29.9: 1125.46,
    30.0: 1125.94,
    30.1: 1126.42,
    30.2: 1126.90,
    30.3: 1127.37,
  };

  void _calcularColor() {
    setState(() {
      _errorMensaje = null;
      _resultadoColor = null;
    });

    double? tamanoCelda = double.tryParse(_celdaController.text);
    double? brix = double.tryParse(_brixController.text);
    double? absorbancia = double.tryParse(_absorbanciaController.text);

    if (tamanoCelda == null || brix == null || absorbancia == null) {
      setState(() {
        _errorMensaje = 'Por favor ingrese valores numéricos válidos.';
      });
      return;
    }

    if (tamanoCelda <= 0 || brix <= 0) {
      setState(() {
        _errorMensaje = 'El tamaño de celda y Brix deben ser mayores a 0.';
      });
      return;
    }

    // Búsqueda de densidad (BUSCARV)
    double? densidad = _baseDatosDensidad[brix];

    if (densidad == null) {
      setState(() {
        _errorMensaje = 'El valor de Brix ($brix) no se encuentra en la base de datos.';
      });
      return;
    }

    // Fórmula exacta de Excel: (((100000000 * (Absorbancia / Brix) / Densidad) / TamañoCelda))
    double color = (100000000 * (absorbancia / brix) / densidad) / tamanoCelda;

    setState(() {
      _resultadoColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Color ICUMSA', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1B365D),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _celdaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Tamaño de Celda (cm)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.straighten),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _brixController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Brix (°Brix)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.science),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _absorbanciaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Absorbancia (A)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.opacity),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calcularColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B365D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'CALCULAR COLOR',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMensaje != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(_errorMensaje!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            if (_resultadoColor != null)
              Card(
                color: const Color(0xFFE8EEF5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF1B365D), width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'COLOR ICUMSA (IU)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF555555)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _resultadoColor!.toStringAsFixed(0),
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                      ),
                      Text(
                        'Valor exacto: ${_resultadoColor!.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
