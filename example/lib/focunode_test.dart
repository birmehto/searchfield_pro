import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic SearchFields',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DynamicSearchFieldPage(),
    );
  }
}

class City {
  final String name;
  final String zip;
  City(this.name, this.zip);
}

class DynamicSearchFieldPage extends StatefulWidget {
  const DynamicSearchFieldPage({super.key});

  @override
  State<DynamicSearchFieldPage> createState() => _DynamicSearchFieldPageState();
}

class _DynamicSearchFieldPageState extends State<DynamicSearchFieldPage> {
  final List<City> allCities = [
    City('New York', '10001'),
    City('Los Angeles', '90001'),
    City('Chicago', '60601'),
    City('Houston', '77001'),
    City('Phoenix', '85001'),
    City('Philadelphia', '19101'),
    City('San Antonio', '78201'),
    City('San Diego', '92101'),
    City('Dallas', '75201'),
    City('San Jose', '95101'),
    City('Austin', '73301'),
    City('Jacksonville', '32099'),
    City('Fort Worth', '76101'),
    City('Columbus', '43201'),
    City('Charlotte', '28201'),
    City('San Francisco', '94101'),
    City('Indianapolis', '46201'),
    City('Seattle', '98101'),
    City('Denver', '80201'),
    City('Washington', '20001'),
    City('Boston', '02101'),
  ];

  late final List<SearchFieldListItem<City>> _suggestions;

  /// Hold selected values
  final List<SearchFieldListItem<City>?> _selectedValues = [];

  /// Each field has its own focus node
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _suggestions = allCities
        .map(
          (ct) => SearchFieldListItem<City>(
            ct.name,
            item: ct,
            child: ListTile(title: Text(ct.name), trailing: Text('#${ct.zip}')),
          ),
        )
        .toList();
  }

  void _addSearchField() {
    setState(() {
      _selectedValues.add(null);
      _focusNodes.add(FocusNode());
    });

    /// Auto focus the newly added field
    Future.delayed(Duration(milliseconds: 100), () {
      if (_focusNodes.isNotEmpty) {
        _focusNodes.last.requestFocus();
      }
    });
  }

  void _removeSearchField(int index) {
    final focusNode = _focusNodes[index];

    // Unfocus before removal
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }

    setState(() {
      _selectedValues.removeAt(index);
      _focusNodes.removeAt(index);
    });

    // Dispose immediately after unfocusing
    focusNode.dispose();
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic SearchFields with Focus')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _selectedValues.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: SearchField<City>(
                          focusNode: _focusNodes[index],
                          suggestions: _suggestions,
                          suggestionState: Suggestion.expand,
                          searchInputDecoration: SearchInputDecoration(
                            hintText: 'Search city',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSuggestionTap: (item) {
                            setState(() {
                              _selectedValues[index] = item;
                            });

                            /// Move focus to next field if exists
                            if (index + 1 < _focusNodes.length) {
                              _focusNodes[index + 1].requestFocus();
                            }
                          },
                          selectedValue: _selectedValues[index],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSearchField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _addSearchField,
              icon: const Icon(Icons.add),
              label: const Text('Add SearchField'),
            ),
          ],
        ),
      ),
    );
  }
}
