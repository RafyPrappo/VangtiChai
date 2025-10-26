import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatefulWidget {
  const VangtiChaiApp({super.key});

  @override
  State<VangtiChaiApp> createState() => _VangtiChaiAppState();
}

class _VangtiChaiAppState extends State<VangtiChaiApp> {
  String input = '';

  final List<String> keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    'C', '0', '←'
  ];

  void handleKeyPress(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
      } else if (value == '←') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else {
        if (input.length < 9) {
          input += value;
        }
      }
    });
  }

  Map<int, int> calculateChange(int amount) {
    final notes = [500, 100, 50, 20, 10, 5, 2, 1];
    final result = <int, int>{};
    for (final note in notes) {
      result[note] = amount ~/ note;
      amount %= note;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final amount = int.tryParse(input) ?? 0;
    final change = calculateChange(amount);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'Vangti Chai',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isPortrait ? _buildPortrait(change) : _buildLandscape(change),
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait(Map<int, int> change) {
    return Column(
      children: [
        // Display area
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Taka: $input',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 16),
              if (input.isEmpty)
                const Text(
                  'Enter an amount to see change breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Change Breakdown:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...change.entries.map((e) =>
                    e.value > 0 ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2196F3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${e.key}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${e.value} note${e.value > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ],
                      ),
                    ) : const SizedBox()
                    ).toList(),
                  ],
                ),
            ],
          ),
        ),

        // Numpad area
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.2,
              children: keys.map((key) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => handleKeyPress(key),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getKeyColor(key),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscape(Map<int, int> change) {
    return Row(
      children: [
        // Display area
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 12.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Taka: $input',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (input.isEmpty)
                    const Text(
                      'Enter an amount to see change breakdown',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Change Breakdown:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...change.entries.map((e) =>
                        e.value > 0 ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2196F3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${e.key}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${e.value} note${e.value > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                            ],
                          ),
                        ) : const SizedBox()
                        ).toList(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),

        // Numpad area
        SizedBox(
          width: 200,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              childAspectRatio: 1.1,
              children: keys.map((key) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => handleKeyPress(key),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getKeyColor(key),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Color _getKeyColor(String key) {
    switch (key) {
      case 'C':
        return const Color(0xFFF44336); // Red
      case '←':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF2196F3); // Blue
    }
  }
}