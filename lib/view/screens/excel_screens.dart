// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/snackbar/snackbar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';
// import 'package:tracking_id/view/widgets/text.dart';
//
//
// class ExcelScreens extends StatefulWidget {
//   const ExcelScreens({super.key});
//
//   @override
//   State<ExcelScreens> createState() => _ExcelScreensState();
// }
//
// class _ExcelScreensState extends State<ExcelScreens> {
//
//   Future<void> _downloadExcelFile() async {
//     try {
//       // Create a new Excel workbook using xlsio
//       final Workbook workbook = Workbook();
//       final Worksheet sheet = workbook.worksheets[0];
//
//       // Add headers
//       final List<String> headers = [
//         'Date',
//         'Location',
//         'From Time - To Time',
//         'Duration',
//         'Remarks'
//       ];
//
//       for (int i = 0; i < headers.length; i++) {
//         sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
//       }
//
//       // Add data rows
//       for (int i = 0; i < _dataList.length; i++) {
//         final data = _dataList[i];
//         sheet.getRangeByIndex(i + 2, 1).setText(data["date"] ?? "");
//         sheet.getRangeByIndex(i + 2, 2).setText(data["location"] ?? "");
//         sheet.getRangeByIndex(i + 2, 3).setText(
//             "${data["fromTime"] ?? ""} - ${data["toTime"] ?? ""}");
//         sheet.getRangeByIndex(i + 2, 4).setText(
//             calculateDuration(data["fromTime"] ?? "", data["toTime"] ?? ""));
//         sheet.getRangeByIndex(i + 2, 5).setText(data["remarks"] ?? "");
//       }
//
//       // Save the Excel file
//       final List<int> bytes = workbook.saveAsStream();
//       workbook.dispose();
//
//       // Use path_provider to get the app's documents directory
//       final directory = await getApplicationDocumentsDirectory();
//       final String path = '${directory.path}/TrackingReport.xlsx';
//       final File file = File(path);
//       await file.writeAsBytes(bytes);
//
//       Get.snackbar(
//         "Success",
//         "File saved at $path",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to save file: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: MyText(text: "Excel Reports", weight: FontWeight.w500, color: Colors.black),
//       ),
//     );
//   }
// }
