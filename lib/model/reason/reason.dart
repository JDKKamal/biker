class ReasonResponse
{
   final int id;
   final String reasonName;
   bool isSelected = false;

   ReasonResponse({this.isSelected, this.id, this.reasonName});

   factory ReasonResponse.fromJson(Map<String, dynamic> json) {
      return new  ReasonResponse(
         isSelected: false,
         id: json['ID'],
         reasonName: json['LISTDESC'],
      );
   }
}