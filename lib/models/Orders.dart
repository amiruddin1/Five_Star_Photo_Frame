class Orders {
  int Order_Id;
  String ServiceType;
  int FrameId;
  String Width;
  String Height;
  int FinalPrice;
  int Quantity;
  int AdvancePrice;
  String Status;

  Orders(
      {
        required this.Order_Id,
        required this.Width,
        required this.Height,
        required this.ServiceType,
        required this.FrameId,
        required this.FinalPrice,
        required this.Quantity,
        required this.AdvancePrice,
        required this.Status
      });
    }
