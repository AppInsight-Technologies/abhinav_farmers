import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as wd;
import 'package:pdf/widgets.dart' as pw;

import '../../assets/ColorCodes.dart';
import '../../constants/api.dart';
import '../../generated/l10n.dart';
import '../../utils/prefUtils.dart';
import 'invoice_service.dart';

import 'package:http/http.dart' as http;

class InvoiceButton extends StatelessWidget {
  const InvoiceButton(
      {Key? key,
      this.orderId,
      this.orderItemData,
      this.subTotal = 0,
      this.total = 0,
      this.deliveryDateTime = '',
      this.paymentOption = '',
      this.totalSaving = ''})
      : super(key: key);
  final String? orderId;
  final orderItemData;
  final double subTotal;
  final double total;
  final String deliveryDateTime;
  final String paymentOption;
  final String totalSaving;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          String mobile;
          String email;

          try {
            final response = await http.post(Api.getProfile, body: {
              // await keyword is used to wait to this operation is complete.
              "apiKey": PrefUtils.prefs!.getString('apikey'),
              "branch": PrefUtils.prefs!.getString("branch")
            });

            final responseJson = json.decode(utf8.decode(response.bodyBytes));

            final dataJson =
                json.encode(responseJson['data']); //fetching categories data
            final dataJsondecode = json.decode(dataJson);
            List data = []; //list for categories

            dataJsondecode.asMap().forEach((index, value) => data.add(
                dataJsondecode[index] as Map<String,
                    dynamic>)); //store each category values in data list

            mobile = data[0]['mobileNumber'];
            email = data[0]['email'];
          } catch (e) {
            throw (e);
          }

          final invoice = PdfInvoiceService(
              orderId: orderId,
              orderItemData: orderItemData,
              subTotal: subTotal,
              total: total,
              mobile: mobile,
              email: email,
              totalSaving: totalSaving,
              deliveryDateTime: deliveryDateTime,
              paymentOption: paymentOption);
          final byteList = await invoice.createInvoice();
          await invoice.savePdfFile(orderId!, byteList);
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 20,
          color: ColorCodes.varcolor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).invoice, //'INVOICE',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: ColorCodes.primaryColor,//ColorCodes.blackColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
