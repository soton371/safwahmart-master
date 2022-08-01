import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:grocery/INVOICE/api/pdf_api.dart';
import 'package:grocery/INVOICE/model/customer.dart';
import 'package:grocery/INVOICE/model/invoice.dart';
import 'package:grocery/INVOICE/model/supplier.dart';

import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),

        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: buildSupplierAddress(invoice.supplier),
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          //buildTitle(invoice),
          //SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildCustomerAddress(invoice.customer),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          //buildInvoiceInfo(invoice.info),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Name        : ${customer.name}', style: TextStyle(fontWeight: FontWeight.normal)),
      Text('Address    : ${customer.address}', style: TextStyle(fontWeight: FontWeight.normal)),
      Text('Phone No : ${customer.phoneNo}', style: TextStyle(fontWeight: FontWeight.normal)),
      Text('Order No  : ${customer.invoiceNumber}', style: TextStyle(fontWeight: FontWeight.normal)),
      Text('Created    : ${customer.createdAt}', style: TextStyle(fontWeight: FontWeight.normal)),
      // Text('Preferred Delivery Time: ${customer.deleveryTime}', style: TextStyle(fontWeight: FontWeight.normal)),
    ],
  );

  // static Widget buildInvoiceInfo(InvoiceInfo info) {
  //   final titles = <String>[
  //     'Date:',
  //   ];
  //   final data = <String>[
  //     Utils.formatDate(info.date),
  //   ];
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: List.generate(titles.length, (index) {
  //       final title = titles[index];
  //       final value = data[index];
  //
  //       return buildText(title: title, value: value, width: 100);
  //     }),
  //   );
  // }

  static Widget buildSupplierAddress(Supplier supplier) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  // static Widget buildTitle(Invoice invoice) =>
  //     Center(
  //       child: Text(
  //         '*** sales Invoice ***\n',
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       )
  //     );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'SL',
      'Item Details',
      'Qty',
      'Rate',
      'Discounted Price',
      'Amount'
    ];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.serial,
        item.description,
        '${item.quantity}',
        '${item.unitPrice}',
        '',
        (total.toStringAsFixed(2)),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: PdfColors.grey
          ),
          bottom: BorderSide(
            width: 1,
              color: PdfColors.grey
          )
        )
      ),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    // final netTotal = invoice.items
    //     .map((item) => item.unitPrice * item.quantity)
    //     .reduce((item1, item2) => item1 + item2);
    // final discount = invoice.discount;
    // final paid = invoice.paidAmount;
    // final previousDue = invoice.previousDue;
    // final total = netTotal  + num.parse(previousDue) - discount - paid;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Subtotal:',
                  value: '${invoice.subTotal}',
                  unite: true,
                ),
                buildText(
                  title: 'VAT:',
                  value: '${invoice.vat}',
                  unite: true,
                ),
                // Divider(),
                buildText(
                  title: 'Shipping Cost:',
                  value: '${invoice.shippingCost}',
                  unite: true,
                ),
                buildText(
                  title: 'Discount',
                  value: '- ${invoice.discount}',
                  unite: true,
                ),
                buildText(
                  title: 'Total Payable',
                  value: '${invoice.totalPayable}',
                  unite: true,
                ),
                buildText(
                  title: 'Paid Amount',
                  value: '${invoice.paidAmount}',
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Cash To Collect',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '${invoice.cashToCollect}',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'We Thank You for your valued patronage', value: ''),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
