// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) => List<AddressModel>.from(json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
    int? memberShippingAddressId;
    String? memberAddressKey;
    int? memberId;
    String? firstName;
    String? lastName;
    String? email;
    String? phoneCode;
    String? mobileNo;
    String? addressLine1;
    String? addressLine2;
    int? cityId;
    int? countryId;
    String? zipCode;
    String? status;
    bool? isDefault;
    DateTime? lastUpdated;
    dynamic member;
    City? city;
    Country? country;

    AddressModel({
        this.memberShippingAddressId,
        this.memberAddressKey,
        this.memberId,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneCode,
        this.mobileNo,
        this.addressLine1,
        this.addressLine2,
        this.cityId,
        this.countryId,
        this.zipCode,
        this.status,
        this.isDefault,
        this.lastUpdated,
        this.member,
        this.city,
        this.country,
    });

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        memberShippingAddressId: json["memberShippingAddressId"],
        memberAddressKey: json["memberAddressKey"],
        memberId: json["memberId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneCode: json["phoneCode"],
        mobileNo: json["mobileNo"],
        addressLine1: json["addressLine1"],
        addressLine2: json["addressLine2"],
        cityId: json["cityId"],
        countryId: json["countryId"],
        zipCode: json["zipCode"],
        status: json["status"],
        isDefault: json["isDefault"],
        lastUpdated: json["lastUpdated"] == null ? null : DateTime.parse(json["lastUpdated"]),
        member: json["member"],
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
    );

    Map<String, dynamic> toJson() => {
        "memberShippingAddressId": memberShippingAddressId,
        "memberId": memberId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "mobileNo": mobileNo,
        "phoneCode": phoneCode,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "cityId": cityId,
        "countryId": countryId,
        "zipCode": zipCode,
        "isDefault": isDefault,
    };
}

class City {
    int? cityId;
    String? cityKey;
    String? cityName;
    String? cityNameAr;
    bool? cityStatus;
    int? countryId;
    int? createdBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    Country? country;

    City({
        this.cityId,
        this.cityKey,
        this.cityName,
        this.cityNameAr,
        this.cityStatus,
        this.countryId,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.country,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        cityId: json["cityId"],
        cityKey: json["cityKey"],
        cityName: json["cityName"],
        cityNameAr: json["cityNameAr"],
        cityStatus: json["cityStatus"],
        countryId: json["countryId"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        country: json["country"] == null ? null : Country.fromJson(json["country"]),
    );

    Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "cityKey": cityKey,
        "cityName": cityName,
        "cityNameAr": cityNameAr,
        "cityStatus": cityStatus,
        "countryId": countryId,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "country": country?.toJson(),
    };
}

class Country {
    int? countryId;
    String? countryKey;
    String? countryCode;
    String? countryName;
    String? arabicCountryName;
    String? flag;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? createdBy;
    int? updatedBy;

    Country({
        this.countryId,
        this.countryKey,
        this.countryCode,
        this.countryName,
        this.arabicCountryName,
        this.flag,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryId: json["countryId"],
        countryKey: json["countryKey"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        arabicCountryName: json["arabicCountryName"],
        flag: json["flag"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
    );

    Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "countryKey": countryKey,
        "countryCode": countryCode,
        "countryName": countryName,
        "arabicCountryName": arabicCountryName,
        "flag": flag,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
    };
}
