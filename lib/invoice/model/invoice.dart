import 'package:grocery/INVOICE/model/customer.dart';
import 'package:grocery/INVOICE/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final subTotal;
  final vat;
  final shippingCost;
  final discount;
  final totalPayable;
  final paidAmount;
  final cashToCollect;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.subTotal,
    required this.vat,
    required this.shippingCost,
    required this.discount,
    required this.totalPayable,
    required this.paidAmount,
    required this.cashToCollect,
    required this.items,
  });
}

class InvoiceInfo {


  final DateTime date;
  final SalesId;

  const InvoiceInfo({
    required this.date,
    required this.SalesId

  });
}

class InvoiceItem {
  final int serial;
  final String description;
  final DateTime date;
  final double quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.serial,
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}
