// To parse this JSON data, do
//
//     final allCountriesModel = allCountriesModelFromJson(jsonString);

import 'dart:convert';

AllCountriesModel allCountriesModelFromJson(String str) => AllCountriesModel.fromJson(json.decode(str));

String allCountriesModelToJson(AllCountriesModel data) => json.encode(data.toJson());

class AllCountriesModel {
    bool? success;
    String? message;
    List<GetCountry>? data;

    AllCountriesModel({
        this.success,
        this.message,
        this.data,
    });

    factory AllCountriesModel.fromJson(Map<String, dynamic> json) => AllCountriesModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<GetCountry>.from(json["data"]!.map((x) => GetCountry.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class GetCountry {
    int? countryId;
    String? countryKey;
    String? countryName;
    dynamic iso;
    String? flag;

    GetCountry({
        this.countryId,
        this.countryKey,
        this.countryName,
        this.iso,
        this.flag,
    });

    factory GetCountry.fromJson(Map<String, dynamic> json) => GetCountry(
        countryId: json["countryId"],
        countryKey: json["countryKey"],
        countryName: json["countryName"],
        iso: json["iso"],
        flag: json["flag"],
    );

    Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "countryKey": countryKey,
        "countryName": countryName,
        "iso": iso,
        "flag": flag,
    };
}
