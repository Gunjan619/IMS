import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gims/api/webService.dart';
import 'package:gims/api/webUrl.dart';
import 'package:gims/model/Request/printReceiptRequest.dart';
import 'package:gims/model/Response/printReceiptResponse.dart';
import 'package:gims/view/home/dashboard.dart';

// import 'package:my_app1/sharePdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class InvoiceView extends StatefulWidget {
  @override
  _InvoiceView createState() => _InvoiceView();
}

class _InvoiceView extends State<InvoiceView> with TickerProviderStateMixin {
  bool isLoading = true;

  /*api*/
  Webservice controller = new Webservice();

  /*invoice*/
  // InvoiceRequest _request = new InvoiceRequest("", "", "", "");
  PrintReceiptRequest printReceiptRequest = PrintReceiptRequest("", "");
  PrintReceiptResponse printReceiptResponses = PrintReceiptResponse();
  final Webservice _service = Webservice();

  String userId = '',
      masterId = '',
      strSelectedOrgId = '',
      strSelectedOrgName = '';

  String invoiceNo = '';
  String receiptNo = '';

  bool isMember = false;
  List feeList = [];

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) async {
      setState(() {
        isLoading = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        initializeDepartmentData(context);
      });
    });
  }

  void initializeDepartmentData(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    if (arguments['receipt'] != null) {
      setState(() {
        isLoading = true;
      });
      receiptNo = arguments['receipt'];

      printReceiptRequest.type = 'view';
      printReceiptRequest.receiptNo = receiptNo;

      _service.printReceipt(printReceiptRequest).then((value) {
        printReceiptResponses = value;

        if (value.error == false) {
          setState(() {
            feeList = printReceiptResponses.data!;
            isLoading = false;
          });
        } else {
          isLoading = false;
        }
      });

      setState(() {});
    } else {
      Navigator.pushReplacementNamed(context, '/feeCollection');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // invoiceNo = arguments['arg'];

    // if (invoiceNo.contains('member')) {
    //   isMember = true;
    //   invoiceNo = invoiceNo.replaceAll('member', '');
    // }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.download),
              color: Colors.white,
              onPressed: () {
                _generatePdfAndDownload(context);
              },
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Fee Receipt',
            softWrap: true,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                _onWillPop();
              }),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Stack(
          children: [
            isLoading
                ? Center(
                    child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: SpinKitCircle(
                          color: Theme.of(context).primaryColor,
                          size: 70.0,
                          duration: const Duration(milliseconds: 1200),
                        )))
                : SingleChildScrollView(
                    child: _mainBody(context),
                  ),
          ],
        ));
  }

  Widget _mainBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headView(),
          _middleView(),
          SizedBox(
            height: 10,
          ),
          _showDivider(),
          SizedBox(
            height: 10,
          ),
          _lastView(),
          _tncView(),
        ],
      ),
    );
  }

  Widget _showDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Divider(
        height: 1,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _headView() {
    return Column(
      children: [
        Image.network(
          ORGANISATION_IMAGE + printReceiptResponses.logo.toString(),
          fit: BoxFit.contain,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return const SizedBox();
          },
          height: 50,
          width: double.infinity,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: true,
                    child: Text(
                      printReceiptResponses.orgname.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    printReceiptResponses.address.toString(),
                    style: const TextStyle(
                        color: Colors.black, height: 1.7, fontSize: 12),
                  ),
                  Text(
                    "Email : " +
                        printReceiptResponses.orgname.toString() +
                        " / Phone No. : " +
                        printReceiptResponses.phone.toString() +
                        "",
                    style: const TextStyle(
                        color: Colors.black, height: 1.7, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        _showDivider(),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "FEE RECEIPT",
              style: TextStyle(
                  color: Colors.black,
                  height: 1.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _middleView() {
    return Row(
      children: [
        //left
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: true,
                child: Text(
                  "Enrollment No",
                  style: const TextStyle(
                      color: Colors.black, height: 1.7, fontSize: 12),
                ),
              ),
              Visibility(
                visible: true,
                child: Text(
                  "Name: " + printReceiptResponses.stuName.toString(),
                  style: const TextStyle(
                      color: Colors.black, height: 1.7, fontSize: 12),
                ),
              ),
              Text(
                "Year : " + printReceiptResponses.year.toString(),
                style: const TextStyle(
                    color: Colors.black, height: 1.7, fontSize: 12),
              ),
            ],
          ),
        ),

        //right
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Date: " + printReceiptResponses.payDate.toString(),
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colors.black, height: 1.7, fontSize: 12),
              ),
              Visibility(
                visible: true,
                child: Text(
                  "Course : " + printReceiptResponses.course.toString(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: Colors.black, height: 1.7, fontSize: 12),
                ),
              ),
              Text(
                "Receipt No : " + printReceiptResponses.receiptNo.toString(),
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colors.black, height: 1.7, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lastView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //head
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Sr.No",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Particular",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Amount",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        //data
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: feeList.length,
            itemBuilder: (context, index) {
              int srNo = index + 1;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        srNo.toString(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        feeList[index].feeName,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        feeList[index].paidAmount,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        //Grand Total
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Grand Total",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        printReceiptResponses.grandtotal.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Payment Mode : " +
                          printReceiptResponses.payMode.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tncView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 0, left: 5, bottom: 10),
            child: RichText(
              text: TextSpan(
                text:
                    "(1)Fee once deposited will not be refunded and the same is not transferrable.",
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            )),
        Padding(
            padding:
                const EdgeInsets.only(top: 2, right: 0, left: 5, bottom: 10),
            child: RichText(
              text: TextSpan(
                text: "(2)Cheque is subject to realisation",
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            )),
        Padding(
            padding:
                const EdgeInsets.only(top: 80, right: 0, left: 5, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: RichText(
                    text: TextSpan(
                      text: printReceiptResponses.orgname,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      text: "Authority Signature",
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  /*on back*/
  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
        ModalRoute.withName("/home"));
    return true; //
  }

  // PDF generation logic
  Future<void> _generatePdfAndDownload(BuildContext context) async {
    final pdf = pw.Document();
    final Uint8List imageData = await _downloadImage(
        'https://gims.gayatrisoft.in/lbsgroup/assets/images/gims-logo.png');
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Image(
                      pw.MemoryImage(imageData),
                      fit: pw.BoxFit.contain,
                      height: 60,
                      width: double.infinity,
                    ),
                    pw.SizedBox(
                      height: 20,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                "GIMS - Institution Management Software",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex('#000'),
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                "Address : PRATAPGARH",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex('#000'),
                                    height: 1.7,
                                    fontSize: 12),
                              ),
                              pw.Text(
                                "Email : support@gayatrisoft.co / Phone No. : 8441061235",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex("#000"),
                                    height: 1.7,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 5,
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      child: pw.Divider(
                        height: 1,
                        color: PdfColor.fromHex('#BDBDBD'),
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          "FEE RECEIPT",
                          style: pw.TextStyle(
                              color: PdfColor.fromHex('#000'),
                              height: 1.5,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    //left
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Enrollment No",
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'),
                                height: 1.7,
                                fontSize: 12),
                          ),
                          pw.Text(
                            "Name: Neelesh Singh",
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'),
                                height: 1.7,
                                fontSize: 12),
                          ),
                          pw.Text(
                            "Year : 1st Year",
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'),
                                height: 1.7,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    //right
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Date: 07-10-2024",
                            textAlign: pw.TextAlign.end,
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'),
                                height: 1.7,
                                fontSize: 12),
                          ),
                          pw.Text(
                            "Course : B.A.",
                            textAlign: pw.TextAlign.end,
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'),
                                height: 1.7,
                                fontSize: 12),
                          ),
                          pw.Text(
                            "Receipt No : 2024-1",
                            textAlign: pw.TextAlign.end,
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'),
                                height: 1.7,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      child: pw.Divider(
                        height: 1,
                        color: PdfColor.fromHex('#BDBDBD'),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    //head
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.only(left: 8.0),
                            child: pw.Text(
                              "Sr.No",
                              textAlign: pw.TextAlign.start,
                              style: pw.TextStyle(
                                  color: PdfColor.fromHex('#000'),
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 8,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.only(left: 8.0),
                            child: pw.Text(
                              "Particular",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColor.fromHex('#000'),
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Padding(
                            padding: pw.EdgeInsets.only(left: 8.0),
                            child: pw.Text(
                              "Amount",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                  color: PdfColor.fromHex('#000'),
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //data
                    pw.Padding(
                      padding:
                          pw.EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(left: 8.0),
                              child: pw.Text(
                                "1",
                                textAlign: pw.TextAlign.start,
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex('#000'),
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 8,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(left: 8.0),
                              child: pw.Text(
                                "Admission Fee",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex('#000'),
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(left: 8.0),
                              child: pw.Text(
                                "50000",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex('#000'),
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Grand Total
                    pw.Padding(
                      padding:
                          pw.EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Padding(
                              padding: pw.EdgeInsets.only(left: 8.0),
                              child: pw.Text(
                                "",
                                style: pw.TextStyle(
                                    color: PdfColor.fromHex('#000'),
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 8,
                            child: pw.Container(
                              child: pw.Padding(
                                padding: pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  "Grand Total",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#000'),
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Container(
                              child: pw.Padding(
                                padding: pw.EdgeInsets.all(8.0),
                                child: pw.Center(
                                  child: pw.Text(
                                    "50000",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex('#000'),
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Padding(
                      padding:
                          pw.EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              child: pw.Padding(
                                padding: pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  "Payment Mode : Online / asdasd ",
                                  textAlign: pw.TextAlign.start,
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#000'),
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.only(
                            top: 10, right: 0, left: 5, bottom: 10),
                        child: pw.RichText(
                          text: pw.TextSpan(
                            text:
                                "(1)Fee once deposited will not be refunded and the same is not transferrable.",
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'), fontSize: 14),
                          ),
                        )),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(
                            top: 2, right: 0, left: 5, bottom: 10),
                        child: pw.RichText(
                          text: pw.TextSpan(
                            text: "(2)Cheque is subject to realisation",
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#000'), fontSize: 14),
                          ),
                        )),
                    pw.Padding(
                        padding: pw.EdgeInsets.only(
                            top: 80, right: 0, left: 5, bottom: 10),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  text:
                                      "GIMS - Institution Management Software",
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#000'),
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.RichText(
                                textAlign: pw.TextAlign.end,
                                text: pw.TextSpan(
                                  text: "Authority Signature",
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#000'),
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ]);
        },
      ),
    );

    // Trigger PDF download
    await Printing.layoutPdf(
        format: PdfPageFormat.a4,
        forceCustomPrintPaper: true,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<Uint8List> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
