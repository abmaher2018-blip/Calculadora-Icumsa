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
      title: 'Laboratorio Azucarero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B365D)),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

// ---------------------------------------------------------
// PANTALLA PRINCIPAL: MENÚ DE TRES SECCIONES
// ---------------------------------------------------------
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Análisis de Laboratorio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B365D),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. SECCIÓN CAÑA
          _buildSectionHeader('1. CAÑA'),
          _buildItemTile(
            context,
            title: 'Análisis de Caña',
            subtitle: 'Módulo de recepción y muestreo',
            icon: Icons.grass,
            onTap: () => _navigateToEmptyScreen(context, 'Análisis de Caña'),
          ),

          const SizedBox(height: 20),

          // 2. SECCIÓN PROCESO
          _buildSectionHeader('2. PROCESO'),
          _buildItemTile(
            context,
            title: 'Bagazo',
            subtitle: 'Humedad, Pol y Fibra',
            icon: Icons.agriculture,
            onTap: () => _navigateToEmptyScreen(context, 'Bagazo'),
          ),
          _buildItemTile(
            context,
            title: 'Cachaza',
            subtitle: 'Humedad y Pol',
            icon: Icons.cleaning_services_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Cachaza'),
          ),
          _buildItemTile(
            context,
            title: 'Jugos',
            subtitle: 'Jugo Diluido, Claro y Filtrado',
            icon: Icons.local_drink_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Jugos'),
          ),
          _buildItemTile(
            context,
            title: 'Masas',
            subtitle: 'Masas Cocidas A, B y C',
            icon: Icons.blur_on_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Masas'),
          ),
          _buildItemTile(
            context,
            title: 'Mieles',
            subtitle: 'Miel A, B y Miel Final',
            icon: Icons.water_drop_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Mieles'),
          ),

          const SizedBox(height: 20),

          // 3. SECCIÓN PRODUCTO TERMINADO
          _buildSectionHeader('3. PRODUCTO TERMINADO'),
          _buildItemTile(
            context,
            title: 'Color',
            subtitle: 'Cálculo de Color ICUMSA (UI) a 420 nm',
            icon: Icons.palette_outlined,
            isCompleted: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IcumsaCalculator()),
              );
            },
          ),
          _buildItemTile(
            context,
            title: 'Cenizas',
            subtitle: 'Cenizas Conductimétricas (Crudo, Blanco, Morena)',
            icon: Icons.grain_outlined,
            isCompleted: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AshMenuScreen()),
              );
            },
          ),
          _buildItemTile(
            context,
            title: 'Pol',
            subtitle: 'Polarización (°Z) y Sacarosa',
            icon: Icons.science_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Pol'),
          ),
          _buildItemTile(
            context,
            title: 'Humedad',
            subtitle: 'Pérdida por secado',
            icon: Icons.thermostat_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Humedad'),
          ),
          _buildItemTile(
            context,
            title: 'Dióxido de Azufre',
            subtitle: 'Determinación de SO₂',
            icon: Icons.bubble_chart_outlined,
            onTap: () => _navigateToEmptyScreen(context, 'Dióxido de Azufre'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B365D),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildItemTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isCompleted = false,
  }) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted ? const Color(0xFF1B365D) : Colors.grey.shade200,
          child: Icon(
            icon,
            color: isCompleted ? Colors.white : const Color(0xFF1B365D),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _navigateToEmptyScreen(BuildContext context, String moduleName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceholderModuleScreen(moduleName: moduleName),
      ),
    );
  }
}

// ---------------------------------------------------------
// SUB-MENÚ: CENIZAS (PRODUCTO TERMINADO)
// ---------------------------------------------------------
class AshMenuScreen extends StatelessWidget {
  const AshMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Análisis de Cenizas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B365D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Seleccione el tipo de azúcar:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
          ),
          const SizedBox(height: 16),
          _buildAshOption(
            context,
            title: 'Azúcar Crudo',
            subtitle: '%Cenizas = (C1 - 0.9 × C2) × 0.0018',
            type: AshType.crudo,
          ),
          _buildAshOption(
            context,
            title: 'Azúcar Blanco',
            subtitle: '%Cenizas = (C1 - 0.35 × C2) × 0.0006',
            type: AshType.blanco,
          ),
          _buildAshOption(
            context,
            title: 'Azúcar Morena',
            subtitle: '%Cenizas = (C1 - 0.35 × C2) × 0.0006',
            type: AshType.morena,
          ),
        ],
      ),
    );
  }

  Widget _buildAshOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required AshType type,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF1B365D),
          child: Icon(Icons.flash_on, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AshCalculatorScreen(type: type, title: title),
            ),
          );
        },
      ),
    );
  }
}

enum AshType { crudo, blanco, morena }

// ---------------------------------------------------------
// PANTALLA: CÁLCULO DE CENIZAS CONDUCTIMÉTRICAS
// ---------------------------------------------------------
class AshCalculatorScreen extends StatefulWidget {
  final AshType type;
  final String title;

  const AshCalculatorScreen({super.key, required this.type, required this.title});

  @override
  State<AshCalculatorScreen> createState() => _AshCalculatorScreenState();
}

class _AshCalculatorScreenState extends State<AshCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _c1Controller = TextEditingController();
  final _c2Controller = TextEditingController();

  double? _ashPercentage;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double c1 = double.parse(_c1Controller.text);
      final double c2 = double.parse(_c2Controller.text);

      double result = 0.0;

      switch (widget.type) {
        case AshType.crudo:
          result = (c1 - 0.9 * c2) * 0.0018;
          break;
        case AshType.blanco:
        case AshType.morena:
          result = (c1 - 0.35 * c2) * 0.0006;
          break;
      }

      setState(() {
        _ashPercentage = result;
      });
    }
  }

  void _reset() {
    _c1Controller.clear();
    _c2Controller.clear();
    setState(() {
      _ashPercentage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cenizas: ${widget.title}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B365D),
        iconTheme: const IconThemeData(color: Colors.white),
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
                        controller: _c1Controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Conductividad Solución de Azúcar (C1)',
                          hintText: 'µS/cm',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.electric_meter),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese C1';
                          if (double.tryParse(value) == null) return 'Valor numérico inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _c2Controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Conductividad Agua Desmineralizada (C2)',
                          hintText: 'µS/cm',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.water_drop),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese C2';
                          if (double.tryParse(value) == null) return 'Valor numérico inválido';
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
              if (_ashPercentage != null) ...[
                const SizedBox(height: 25),
                Card(
                  color: const Color(0xFFE8EEF5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'PORCENTAJE DE CENIZAS',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_ashPercentage!.toStringAsFixed(4)} %',
                          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF1B365D)),
                        ),
                        const SizedBox(height: 4),
                        const Text('% Cenizas Conductimétricas', style: TextStyle(fontSize: 12, color: Colors.black54)),
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

// ---------------------------------------------------------
// PANTALLA SECUNDARIA GENÉRICA (VACÍA / EN DESARROLLO)
// ---------------------------------------------------------
class PlaceholderModuleScreen extends StatelessWidget {
  final String moduleName;

  const PlaceholderModuleScreen({super.key, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          moduleName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B365D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Módulo: $moduleName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Esta sección está lista para la integración de sus fórmulas y parámetros de laboratorio.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// PANTALLA: CÁLCULO DE COLOR ICUMSA (PRODUCTO TERMINADO)
// ---------------------------------------------------------
class IcumsaCalculator extends StatefulWidget {
  const IcumsaCalculator({super.key});

  @override
  State<IcumsaCalculator> createState() => _IcumsaCalculatorState();
}

class _IcumsaCalculatorState extends State<IcumsaCalculator> {
  final _formKey = GlobalKey<FormState>();
  final _absorbanceController = TextEditingController();
  final _cellLengthController = TextEditingController(text: '2');
  final _brixController = TextEditingController();

  final double _factorICUMSA = 100000.0;

  double? _densityKgM3;
  double? _icumsaColor;

  double _getDensityInKgM3(double brix) {
    return 998.203 + (3.74913 * brix) + (0.016959 * pow(brix, 2));
  }

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

      final double color = (_factorICUMSA * absorbance) / (cellLength * brix * densityGcm3);

      setState(() {
        _densityKgM3 = calculatedDensityKgM3;
        _icumsaColor = color;
      });
    }
  }

  void _reset() {
    _absorbanceController.clear();
    _cellLengthController.text = '2';
    _brixController.clear();
    setState(() {
      _densityKgM3 = null;
      _icumsaColor = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cálculo de Color ICUMSA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B365D),
        iconTheme: const IconThemeData(color: Colors.white),
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Longitud de celda b (cm)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingrese la longitud de celda';
                          final val = int.tryParse(value);
                          if (val == null || val <= 0) return 'Debe ser un entero mayor a 0';
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
