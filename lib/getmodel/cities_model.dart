// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

List<CityModel> cityModelFromJson(String str) => List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String cityModelToJson(List<CityModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
    int? cityId;
    String? cityName;
    String? arabicCityName;
    int? countryId;
    String? countryName;
    String? countryNameAr;
    String? icon;

    CityModel({
        this.cityId,
        this.cityName,
        this.arabicCityName,
        this.countryId,
        this.countryName,
        this.countryNameAr,
        this.icon,
    });

    factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        cityId: json["cityId"],
        cityName: json["cityName"],
        arabicCityName: json["arabicCityName"],
        countryId: json["countryId"],
        countryName: json["countryName"],
        countryNameAr: json["countryNameAr"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "cityName": cityName,
        "arabicCityName": arabicCityName,
        "countryId": countryId,
        "countryName": countryName,
        "countryNameAr": countryNameAr,
        "icon": icon,
    };
}
