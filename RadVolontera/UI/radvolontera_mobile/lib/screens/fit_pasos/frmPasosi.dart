

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import 'package:radvolontera_mobile/models/fit_pasos/fit_pasos.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/fit_pasos_provider.dart';
import 'package:radvolontera_mobile/screens/fit_pasos/frmPasosNovi.dart';
import 'package:radvolontera_mobile/widgets/master_screen.dart';

class FITPasosiListScreen extends StatefulWidget {
  const FITPasosiListScreen({Key? key});

  @override
  State<FITPasosiListScreen> createState() => _FITPasosiListScreenState();
}

class _FITPasosiListScreenState extends State<FITPasosiListScreen> {
  late FitPasosProvider _fitPasosProvider;
  List<FITPasosModel>? FITPasos;
  String? selectedStatusValue;
  SearchResult<AccountModel>? userResult;
 late AccountProvider _accountProvider;
  @override
  void initState() {
    super.initState();
    _fitPasosProvider = context.read<FitPasosProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  _loadData() async {
    try {
      userResult= await _accountProvider.get();
      var fitPasosData = await _fitPasosProvider.get();

      setState(() {
        FITPasos = fitPasosData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("FIT pasos"),
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              if (FITPasos != null && FITPasos!.isNotEmpty)
                _buildHeading('FIT pasos'),
                _buildSearch(),
              _buildFITPasos(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FITPasosDetailsScreen()),
            ).then((_) => _loadData()); // Reload the data after adding a new FIT
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: DropdownButton<String>(
              value: selectedStatusValue,
              hint: Text('Select user'),
              onChanged: (newValue) async {
                setState(() {
                  selectedStatusValue = newValue;
                });

                var filter = {
                  'userId': selectedStatusValue
                };

                // If "All" is selected, set studentId to null in the filter
                if (selectedStatusValue == null) {
                  filter['userId'] = null;
                }

                var data =
                    await _fitPasosProvider.get(filter: filter);

                setState(() {
                  FITPasos = data.result;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All users'),
                ),
                ...?userResult?.result.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.fullName.toString()),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFITPasos() {
    if (FITPasos == null || FITPasos!.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: FITPasos!.map((FITPasosModel fitPasos) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(fitPasos.user?.fullName ?? ""),
            subtitle: Text(fitPasos.datumIzdavanja != null ? DateFormat('dd.MM.yyyy').format(fitPasos.datumIzdavanja!) : " "),
             trailing: Text(fitPasos.isValid ? "Validan" : "Istekao"),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FITPasosDetailsScreen(
                    fitPasos: fitPasos,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

 
