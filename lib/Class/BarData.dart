class IndividualBar {
  final int x;
  final double y;
  final double a;
  final double b;
  final double c;
  final double d;
  final double r;

  IndividualBar({required this.x, required this.y, required this.a, required this.b, required this.c, required this.d, required this.r});
}

class DayBarData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  final List<double> monGrade;
  final List<double> tueGrade;
  final List<double> wedGrade;
  final List<double> thuGrade;
  final List<double> friGrade;
  final List<double> satGrade;
  final List<double> sunGrade;

  DayBarData({
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
    required this.monGrade,
    required this.tueGrade,
    required this.wedGrade,
    required this.thuGrade,
    required this.friGrade,
    required this.satGrade,
    required this.sunGrade,
  });

  List<IndividualBar> barData = [];

  List<List<double>> allGrade = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: monAmount, a: monGrade[1], b: monGrade[2], c: monGrade[3], d: monGrade[4], r: monGrade[5]),
      IndividualBar(x: 1, y: tueAmount, a: tueGrade[1], b: tueGrade[2], c: tueGrade[3], d: tueGrade[4], r: tueGrade[5]),
      IndividualBar(x: 2, y: wedAmount, a: wedGrade[1], b: wedGrade[2], c: wedGrade[3], d: wedGrade[4], r: wedGrade[5],),
      IndividualBar(x: 3, y: thuAmount, a: thuGrade[1], b: thuGrade[2], c: thuGrade[3], d: thuGrade[4], r: thuGrade[5]),
      IndividualBar(x: 4, y: friAmount, a: friGrade[1], b: friGrade[2], c: friGrade[3], d: friGrade[4], r: friGrade[5]),
      IndividualBar(x: 5, y: satAmount, a: satGrade[1], b: satGrade[2], c: satGrade[3], d: satGrade[4], r: satGrade[5]),
      IndividualBar(x: 6, y: sunAmount, a: sunGrade[1], b: satGrade[2], c: satGrade[3], d: satGrade[4], r: satGrade[5]),
    ];
    allGrade = [
      monGrade,
      tueGrade,
      wedGrade,
      thuGrade,
      friGrade,
      satGrade,
      sunGrade
    ];
  }

  List<List<int>> machineTotal = [];
  void initializeMachineTotal(List<List<int>> total){
    machineTotal = total;
  }
}

class WeekBarData {
  final double firstWeek;
  final double secondWeek;
  final double thirdWeek;
  final double fourthWeek;
  final double fifthWeek;

  final List<double> firstGrade;
  final List<double> secondGrade;
  final List<double> thirdGrade;
  final List<double> fourthGrade;
  final List<double> fifthGrade;

  WeekBarData(
      {required this.firstWeek,
      required this.secondWeek,
      required this.thirdWeek,
      required this.fourthWeek,
      required this.fifthWeek,
      required this.firstGrade,
      required this.secondGrade,
      required this.thirdGrade,
      required this.fourthGrade,
      required this.fifthGrade});

  List<IndividualBar> barData = [];
  List<List<double>> allGrade = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: firstWeek, a:firstGrade[1], b:firstGrade[2], c:firstGrade[3], d:firstGrade[4], r:firstGrade[5]),
      IndividualBar(x: 1, y: secondWeek, a:secondGrade[1], b:secondGrade[2], c:secondGrade[3], d:secondGrade[4], r:secondGrade[5]),
      IndividualBar(x: 2, y: thirdWeek, a:thirdGrade[1], b:thirdGrade[2], c:thirdGrade[3], d:thirdGrade[4], r:thirdGrade[5]),
      IndividualBar(x: 3, y: fourthWeek, a:fourthGrade[1], b:fourthGrade[2], c:fourthGrade[3], d:fourthGrade[4], r:fourthGrade[5], ),
      IndividualBar(x: 4, y: fifthWeek, a:fifthGrade[1], b:fifthGrade[2], c:fifthGrade[3], d:fifthGrade[4], r:fifthGrade[5])
    ];
    allGrade = [firstGrade, secondGrade, thirdGrade, fourthGrade, fifthGrade];
  }

  List<List<int>> machineTotal = [];
  void initializeMachineTotal(List<List<int>> total){
    machineTotal = total;
  }
}

class MonthBarData {
  final double january;
  final double february;
  final double march;
  final double april;
  final double may;
  final double june;
  final double july;
  final double august;
  final double september;
  final double october;
  final double november;
  final double december;

  final List<double> januaryGrade;
  final List<double> februaryGrade;
  final List<double> marchGrade;
  final List<double> aprilGrade;
  final List<double> mayGrade;
  final List<double> juneGrade;
  final List<double> julyGrade;
  final List<double> augustGrade;
  final List<double> septemberGrade;
  final List<double> octoberGrade;
  final List<double> novemberGrade;
  final List<double> decemberGrade;

  MonthBarData({
    required this.january,
    required this.february,
    required this.march,
    required this.april,
    required this.may,
    required this.june,
    required this.july,
    required this.august,
    required this.september,
    required this.october,
    required this.november,
    required this.december,
    required this.januaryGrade,
    required this.februaryGrade,
    required this.marchGrade,
    required this.aprilGrade,
    required this.mayGrade,
    required this.juneGrade,
    required this.julyGrade,
    required this.augustGrade,
    required this.septemberGrade,
    required this.octoberGrade,
    required this.novemberGrade,
    required this.decemberGrade,
  });

  List<IndividualBar> barData = [];
  List<List<double>> allGrade = [];
  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: january, a: januaryGrade[1], b: januaryGrade[2], c: januaryGrade[3], d: januaryGrade[4], r: januaryGrade[5]),
      IndividualBar(x: 1, y: february, a: februaryGrade[1], b: februaryGrade[2], c: februaryGrade[3], d: februaryGrade[4], r: februaryGrade[5]),
      IndividualBar(x: 2, y: march, a: marchGrade[1], b: marchGrade[2], c: marchGrade[3], d: marchGrade[4], r: marchGrade[5]),
      IndividualBar(x: 3, y: april, a: aprilGrade[1], b: aprilGrade[2], c: aprilGrade[3], d: aprilGrade[4], r: aprilGrade[5]),
      IndividualBar(x: 4, y: may, a: mayGrade[1], b: mayGrade[2], c: mayGrade[3], d: mayGrade[4], r: mayGrade[5]),
      IndividualBar(x: 5, y: june, a: juneGrade[1], b: juneGrade[2], c: juneGrade[3], d: juneGrade[4], r: juneGrade[5]),
      IndividualBar(x: 6, y: july, a: julyGrade[1],  b: julyGrade[2],  c: julyGrade[3],  d: julyGrade[4],  r: julyGrade[5]),
      IndividualBar(x: 7, y: august, a: augustGrade[1], b: augustGrade[2], c: augustGrade[3], d: augustGrade[4], r: augustGrade[5]),
      IndividualBar(x: 8, y: september, a: septemberGrade[1], b: septemberGrade[2], c: septemberGrade[3], d: septemberGrade[4], r: septemberGrade[5]),
      IndividualBar(x: 9, y: october, a: octoberGrade[1], b: octoberGrade[2], c: octoberGrade[3], d: octoberGrade[4], r: octoberGrade[5]),
      IndividualBar(x: 10, y: november, a: novemberGrade[1], b: novemberGrade[2],c: novemberGrade[3], d: novemberGrade[4], r: novemberGrade[5]),
      IndividualBar(x: 11, y: december, a: decemberGrade[1], b: decemberGrade[2], c: decemberGrade[3], d: decemberGrade[4], r: decemberGrade[5]),
    ];
    allGrade = [
      januaryGrade,
      februaryGrade,
      marchGrade,
      aprilGrade,
      mayGrade,
      juneGrade,
      julyGrade,
      augustGrade,
      septemberGrade,
      octoberGrade,
      novemberGrade,
      decemberGrade
    ];
  }

  List<List<int>> machineTotal = [];
  void initializeMachineTotal(List<List<int>> total){
    machineTotal = total;
  }
}
