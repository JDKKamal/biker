class PickUpResponse
{
   final int  inquiryNo;
   final String name;
   final String brand;
   final String mobile;
   final String address;
   final String model;
   final String pickUpDateTime;

   PickUpResponse({this.inquiryNo, this.name, this.brand, this.mobile, this.address, this.model, this.pickUpDateTime});

   factory PickUpResponse.fromJson(Map<String, dynamic> json) {
      return new  PickUpResponse(
         inquiryNo: json['INQUIRYNO'],
         name: json['NAME'],
         brand: json['BRAND'],
         mobile: json['MOBILENO'],
         address: json['ADDRESS'],
         model: json['MODEL'],
         pickUpDateTime: json['PICKUPDATETIME'],
      );
   }
}