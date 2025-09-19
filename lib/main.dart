import 'package:flutter/material.dart';

const List<Color> colores24 = <Color>[
  Color(0xFFFF0000),
  Color(0xFF00FF00),
  Color(0xFF0000FF),
  Color(0xFFFFD700),
  Color(0xFF8A2BE2),
  Color(0xFF00CED1),
  Color(0xFF8B0000),
  Color(0xFF006400),
  Color(0xFF00008B),
  Color(0xFFB8860B),
  Color(0xFFFF6347),
  Color(0xFFADFF2F),
  Color(0xFF7FFF00),
  Color(0xFFFF1493),
  Color(0xFFDC143C),
  Color(0xFF0000CD),
  Color(0xFF32CD32),
  Color(0xFFFFD700),
  Color(0xFF8B008B),
  Color(0xFFFF4500),
  Color(0xFF2E8B57),
  Color(0xFFB22222),
  Color(0xFF6495ED),
  Color(0xFFDAA520),
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
  late List<Color> colores;
  late List<bool> contV;
  late List<int> auxV;
  int numV = 0;
  late List<bool> contE;
  bool band = false;

  @override
  void initState() {
    super.initState();
    ren = widget.renI;
    col = widget.colI;
    contrTam = TextEditingController(text: '${ren}x$col');
    colores = [];
    contV = List.generate(ren * col, (_) => false);
    auxV = [];
    contE = List.generate(ren * col, (_) => false);
    genColors();
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
      colores.clear();
      contV = List.generate(ren * col, (_) => false);
      auxV = [];
      contE = List.generate(ren * col, (_) => false);
      genColors();
    });
  }

  void genColors() {
    List<Color> auxCD = List.from(colores24);
    auxCD.shuffle();
    for (int i = 0; i < ren * col / 2; i++) {
      colores.add(auxCD[i % auxCD.length]);
      colores.add(auxCD[i % auxCD.length]);
    }
    colores.shuffle();
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
          child: const Text('Redistribuir'),
        ),
      ],
    );
  }

  Widget Memorama1(int result) {
    return Expanded(
      child: Center(
        child: AspectRatio(
          aspectRatio: col / ren,
          child: ListView.builder(
            itemCount: ren,
            itemBuilder: (context, renI) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(col, (colI) {
                  int i = renI * col + colI;
                  return InkWell(
                    onTap: band
                        ? null
                        : () {
                      if (contV[i] || contE[i]) return;
                      setState(() {
                        contV[i] = true;
                        auxV.add(i);
                        numV++;
                        if (numV > 2) {
                          contV[auxV[0]] = false;
                          auxV.removeAt(0);
                          numV = 1;
                        }
                        if (auxV.length == 2) {
                          band = true;
                          if (colores[auxV[0]] == colores[auxV[1]]) {
                            contE[auxV[0]] = true;
                            contE[auxV[1]] = true;
                          }
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              if (colores[auxV[0]] != colores[auxV[1]]) {
                                contV[auxV[0]] = false;
                                contV[auxV[1]] = false;
                              }
                              auxV.clear();
                              numV = 0;
                              band = false;
                            });
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      color: contV[i] || contE[i]
                          ? colores[i]
                          : Colors.grey.shade400,
                      margin: const EdgeInsets.all(4),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}