

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/city/city.dart';
import 'package:radvolontera_admin/models/company/company.dart';
import 'package:radvolontera_admin/models/company_category/company_category.dart';
import 'package:radvolontera_admin/providers/company_provider.dart';

import '../../models/search_result.dart';
import '../../providers/city_provider.dart';
import '../../providers/company_category_provider.dart';
import '../../widgets/master_screen.dart';
import 'company_details_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}


class _CompanyListScreenState extends State<CompanyListScreen> {
  late CompanyProvider _companyProvider;
  SearchResult<CompanyModel>? result;
  String? selectedCategoryValue; // variable to store the selected value
  SearchResult<CityModel>? cityResult;
  SearchResult<CompanyCategoryModel>? companyCategoriesResult;
  String? selectedCityValue;
   late CityProvider _cityProvider;
  late CompanyCategoryProvider _companyCategoryProvider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _companyProvider = context.read<CompanyProvider>();
    _companyCategoryProvider = context.read<CompanyCategoryProvider>();
 _cityProvider = context.read<CityProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _companyProvider.get();
    cityResult = await _cityProvider.get();
    companyCategoriesResult = await _companyCategoryProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Company list"),
      child: Container(
        child: Column(children: [ _buildSearch(),_buildDataListView()]),
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
    value: selectedCityValue,
    hint: Text('Select city'),
    onChanged: (newValue) async {
      setState(() {
        selectedCityValue = newValue;
      });

      var filter = {
        'cityId': selectedCityValue,
        'companyCategoryId': selectedCategoryValue
      };

      // If "All" is selected, set studentId to null in the filter
      if (selectedCityValue == null) {
        filter['cityId'] = null;
      }

      var data = await _companyProvider.get(filter: filter);

      setState(() {
        result = data;
      });
    },
    items: [
      DropdownMenuItem<String>(
        value: null, // Use null value for "All" option
        child: Text('All cities'),
      ),
      ...?cityResult?.result.map((item) {
        return DropdownMenuItem<String>(
          value: item.id.toString(),
          child: Text(item.name ?? ""),
        );
      }).toList(),
    ],
  ),
),
           SizedBox(
            width: 8,
          ),
         Expanded(
  child: DropdownButton<String>(
    value: selectedCategoryValue,
    hint: Text('Select category'),
    onChanged: (newValue) async {
      setState(() {
        selectedCategoryValue = newValue;
      });

      var filter = {
        'cityId': selectedCityValue,
        'companyCategoryId': selectedCategoryValue
      };

      // If "All" is selected, set studentId to null in the filter
      if (selectedCategoryValue == null) {
        filter['companyCategoryId'] = null;
      }

      var data = await _companyProvider.get(filter: filter);

      setState(() {
        result = data;
      });
    },
    items: [
      DropdownMenuItem<String>(
        value: null, // Use null value for "All" option
        child: Text('All company categories'),
      ),
      ...?companyCategoriesResult?.result.map((item) {
        return DropdownMenuItem<String>(
          value: item.id.toString(),
          child: Text(item.name ?? ""),
        );
      }).toList(),
    ],
  ),
),
          ElevatedButton(
              onPressed: () async {
                var data = await _companyProvider.get(filter: {
                 'cityId': selectedCityValue,
        'companyCategoryId': selectedCategoryValue
                });

                setState(() {
                  result = data;
                });
              },
              child: Text("Search")),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CompanyDetailsScreen(
                      company: null,
                    ),
                  ),
                );
              },
              child: Text("Add new"))
        ],
      ),
    );
  }

  Widget _buildDataListView() {
  return Expanded(
    child: SingleChildScrollView(
      child: Container(
        color: Colors.white, // Background color for the table
        child: DataTable(
          columnSpacing: 24.0, // Adjust column spacing as needed
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo), // Header row color
          dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Row color
          columns: [
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Address',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Phonenumber',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'City',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Category',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: result?.result
              .map((CompanyModel e) => DataRow(
                    onSelectChanged: (selected) => {
                      if (selected == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CompanyDetailsScreen(
                              company: e,
                            ),
                          ),
                        )
                      }
                    },
                    cells: [
                      DataCell(Text(e.name ?? "")),
                      DataCell(Text(e.address ?? "")),
                      DataCell(Text(e.phoneNumber ?? "")),
                      DataCell(Text(e.email ?? "")),
                      DataCell(Text(e.city != null ? e.city!.name! : "")),
                      DataCell(Text(e.companyCategory != null ? e.companyCategory!.name! : "")),
                    ],
                  ))
              .toList() ??
              [],
        ),
      ),
    ),
  );
}
}
