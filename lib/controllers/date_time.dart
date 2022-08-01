import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'apis.dart';

class DateTimeController extends GetxController{

  //for date pick
  DateTime initialDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var dateIs      = ''.obs;
  var selectDates = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchTime();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context     : context,
        initialDate : initialDate,
        firstDate   : initialDate,
        lastDate    : DateTime(2101));
    if (picked != null) {
      selectDates.value = picked.toString();
      dateIs.value  = 'true';
      timeList.value.removeRange(0, timeList.length);
      fetchTime();
    }
  }

  //for time

  var selectTime, timeId;
  RxList timeList = [].obs;
  Future fetchTime()async{
    var endDate          = selectDates != '' ? DateTime(int.parse(selectDates.toString().split('-')[0]), int.parse(selectDates.toString().split('-')[1]), int.parse(selectDates.toString().split('-')[2].split(' ')[0])) : DateTime.now();
    var currentDate      = DateTime.now();
    var difference       = currentDate.difference(endDate).inHours;
    String formattedDate = DateFormat('kk:mm').format(DateTime.now());

    var url = Uri.parse('$baseUrl/get-common-section-data');
    var res = await http.get(url);

    var status = json.decode(res.body)['status'];
    var getTimes = json.decode(res.body)['data']['time_slots'];
    if(status==1){
      for(var i = 0; i< getTimes.length; i++){
        if(difference >= 0 && timeConvert(formattedDate) > timeConvert(time12to24Format(getTimes[i]['disable_at'] != null ? getTimes[i]['disable_at'] : '0:00'))){
        }
        else{
          timeList.value.add(getTimes[i]);
          timeList.refresh();
        }
      }
    }
    return timeList;
  }

  String time12to24Format(String time) {
    int h = int.parse(time.split(":").first);
    int m = int.parse(time.split(":").last.split(" ").first);
    String meridium = time.split(":").last.split(" ").last.toLowerCase();
    if (meridium == "pm") {
      if (h != 12) {
        h = h + 12;
      }
    }
    if (meridium == "am") {
      if (h == 12) {
        h = 00;
      }
    }
    String newTime = "${h == 0 ? "00" : h}:${m == 0 ? "00" : m}";

    return newTime;
  }
  timeConvert(time){
    var minutes = time.toString().split(':')[0];
    var seconds = time.toString().split(':')[1];

    var times = int.parse(minutes) * 60 + int.parse(seconds);
    return times;
  }
}