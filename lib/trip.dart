class Trip {
  Trip(this.id, this.busName, this.busType, this.busOperator, this.rating,
      this.price,
      {required this.canBargain, required this.hasFlashsales});
  final int id;
  final String busName;
  final String busType;
  final String busOperator;
  final int rating;
  final bool canBargain;
  final bool hasFlashsales;
  final double price;
}
