import 'package:flutter/material.dart';

const List<Color> colores24 = <Color>[
  Color(0xFFF44336), // Red 500
  Color(0xFFE91E63), // Pink 500
  Color(0xFF9C27B0), // Purple 500
  Color(0xFF673AB7), // Deep Purple 500
  Color(0xFF3F51B5), // Indigo 500
  Color(0xFF2196F3), // Blue 500
  Color(0xFF03A9F4), // Light Blue 500
  Color(0xFF00BCD4), // Cyan 500
  Color(0xFF009688), // Teal 500
  Color(0xFF4CAF50), // Green 500
  Color(0xFF8BC34A), // Light Green 500
  Color(0xFFCDDC39), // Lime 500
  Color(0xFFFFEB3B), // Yellow 500
  Color(0xFFFFC107), // Amber 500
  Color(0xFFFF9800), // Orange 500
  Color(0xFFFF5722), // Deep Orange 500
  Color(0xFF795548), // Brown 500
  Color(0xFF9E9E9E), // Grey 500
  Color(0xFF607D8B), // Blue Grey 500
  Color(0xFFD32F2F), // Red 700
  Color(0xFF7B1FA2), // Purple 700
  Color(0xFF512DA8), // Deep Purple 700
  Color(0xFF1976D2), // Blue 700
  Color(0xFF388E3C), // Green 700
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memorama',
      home: const Memorama(renI: 5, colI: 4),
    );
  }
}

class Memorama extends StatefulWidget {
  final int renI;
  final int colI;

  const Memorama({
    super.key,
    required this.renI,
    required this.colI,
  });

  @override
  State<Memorama> createState() => MemoramaState();
}

class MemoramaState extends State<Memorama> {
  late int ren;
  late int col;
  late TextEditingController contrTam;

  @override
  void initState() {
    super.initState();
    ren = widget.renI;
    col = widget.colI;
    contrTam = TextEditingController(text: '${ren}x$col');
  }

  @override
  void dispose() {
    contrTam.dispose();
    super.dispose();
  }

  void dinamicoTam() {
    final text = contrTam.text.trim();
    final aux = RegExp(r'^\s*(\d+)x(\d+)\s*$').firstMatch(text);
    if (aux == null || int.parse(aux.group(1)!) <= 0 ||
        int.parse(aux.group(2)!) <= 0 ||
        (int.parse(aux.group(1)!) * int.parse(aux.group(2)!)) % 2 != 0 ||
        (int.parse(aux.group(1)!) * int.parse(aux.group(2)!)) > 48) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formato incompleto.')),
      );
      return;
    }
    if ((int.parse(aux.group(1)!) * int.parse(aux.group(2)!)) > 48) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exceso de Cartas.')),
      );
      return;
    }
    final r = int.parse(aux.group(1)!);
    final c = int.parse(aux.group(2)!);
    setState(() {
      ren = r;
      col = c;
    });
  }


  @override
  Widget build(BuildContext context) {
    final result = ren * col;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Memorama Sebastian de Jesus Hernandez Hernandez')),
      body: Column(
        children: [
          textos(),
          const SizedBox(height: 12),
          Memorama1(result),
        ],
      ),
    );
  }

  Widget textos() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: contrTam,
            decoration: const InputDecoration(
              labelText: 'Tamaño',
            ),
            onSubmitted: (_) => dinamicoTam(),
          ),
        ),
        ElevatedButton(
          onPressed: dinamicoTam,
          child: const Text('Aplicar'),
        ),
      ],
    );
  }

  Widget Memorama1(int result) {
    return Expanded(
      child: Center(
        child: AspectRatio(
          aspectRatio: col / ren,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: result,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: col,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                },
                child: Container(
                  color: Colors.grey.shade400,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
