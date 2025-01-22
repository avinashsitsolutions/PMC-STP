import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpmc/widgets/constants.dart';

class SocietyServices {
  static updatelatlong(
    String address,
    String lat,
    String long,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/update_society'),
      body: {
        "id": id,
        "ni_lat": lat,
        "ni_long": long,
        "ni_address": address,
        "society_status": "1"
      },
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  // ${Config.baseUrl}/society_name_order?id=1441
  static getlatlong() async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/society_name_order?id=$id'),
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static reportsociety(String fromdate, String todate) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.get(
      Uri.parse(
          '${Config.baseUrl}/Society_Report?from_date=$fromdate&to_date=$todate&user_id=1445'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static tankerlistsociety(
    String capacity,
    String stp,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("manager_id");
    final response = await http.get(
      Uri.parse(
          '${Config.baseUrl}/tanker_info_society?id=$id&ni_tanker_capacity=$capacity&ni_nearest_stp=$stp&ni_user_type=Tanker'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static OrderSociety(
    String projectname,
    String capacity,
    String stp,
    String distance,
    String amt,
    String name,
    String tcapacity,
    String mobno,
    String tno,
    String tmob,
    String id,
    String watercharges,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var societyid = prefss.getString("id");
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/society_orders'),
      body: {
        "ni_society_name": projectname,
        "ni_water_capacity": capacity,
        "ni_nearest_stp": stp,
        "ni_distance": distance,
        "ni_estimated_amount": amt,
        "ni_owner_ful_name": name,
        "ni_tanker_capacity": tcapacity,
        "ni_contact_no": mobno,
        "ni_tanker_no": tno,
        "ni_tanker_mo_no": tmob,
        "tanker_id": id,
        "user_id": societyid,
        "price": watercharges
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }
}
