class Calculate{
  double getmargin( mrp, discount) {
    double difference = (double.parse(mrp) -double.parse(discount));
    double profit = difference / double.parse(mrp);
    // print("???/" + mrp.toString() + "..." + discount.toString());
    return profit * 100;
  }

}