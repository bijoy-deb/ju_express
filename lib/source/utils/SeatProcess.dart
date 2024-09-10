import 'dart:convert';
import 'dart:developer';

import '../data/model/departure_details/BusSeat.dart';
import '../data/model/departure_details/DepartureDetails.dart';
import '../data/model/departure_details/SeatLayoutModel.dart';

class SeatProcess {
  late int j,
      divider,
      totalSeat,
      totalColumn = 0,
      lastColumn,
      sTotalRow,
      sTotalSeatItem,
      spaceFromLeft,
      stEnginePosition;
  int column = 0;

  SeatLayoutModel processData(
      String response, String stType, List<Seat>? seats) {
    int position = -1;
    int cIndex = 0;
    int total = 0;
    int rest = 0;
    int seatPosition = 0;
    int lastIndex = 0;
    int k = 0;
    List<Seat> seatList = [];
    if (seats != null) {
      if (seats.isNotEmpty) {
        seatList = seats;
      }
    }
    Map json = jsonDecode(response);

    Map seatTemplate = json["seatTemplate"];

    List stData = seatTemplate["stData"];

    int countK = 0;
    List<BusSeat> seatArrayList = [];
    if (stType == "4") {
      seatArrayList.clear();
      totalColumn = getColumnCount(stData);
      String t = "", n = "", c = "", r = "", sc = "0";
      for (int i = 0; i < stData.length; i++) {
        try {
          var row = stData.elementAt(i);
          if (row is Map) {
            var keys = row.keys.iterator;
            var rowKeys = row.keys;

            /*for (int j = 0; j < rowKeys.length; j++)*/
            while (keys.moveNext()) {
              t = "";
              n = "";
              c = "";
              r = "";
              sc = "0";
              // var key = rowKeys.elementAt(j);
              var key = keys.current;
              countK++;
              String index = keys.current.toString();
              int in_Dex = int.parse(index);
              Map data = row[key];

              if (data.containsKey("t")) {
                t = data["t"];
              }

              if (data.containsKey("n")) {
                n = data["n"];
              }

              if (data.containsKey("sc")) {
                sc = data["sc"];
              }

              if (data.containsKey("c")) {
                c = data["c"];
              } else {
                c = "0";
              }

              if (data.containsKey("r")) {
                r = data["r"];
              }
              int v = int.parse(index) - lastIndex;
              // print("sssc->c");

              if (v > 1) {
                // print("blank->$index-$lastIndex");
                for (int p = 0; p < v - 1; p++) {
                  BusSeat seat = BusSeat(
                    "",
                    "",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              }

              if (t == "dr") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p == 0) {
                      BusSeat seat = BusSeat(
                        "",
                        "Driver",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  position++;
                  BusSeat seat = BusSeat(
                    "",
                    "Driver",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              } else if (t == "c") {
                if (r.isNotEmpty) {
                  total = int.parse(r);
                  cIndex = int.parse(index);
                }

                position++;
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "") {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "b") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p != 0) {
                      ++in_Dex;
                      index = in_Dex.toString();
                    }
                    BusSeat seat = BusSeat(
                      "",
                      "",
                      "",
                      -1,
                      sc,
                    );
                    seatArrayList.add(seat);
                  }
                } else {
                  position++;
                  if (n.isNotEmpty) {
                    log("n.isNotEmpty ->$n");
                  }
                  BusSeat seat = BusSeat(
                    "",
                    n.isNotEmpty ? n : "",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              } else if (t == "do") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p == 0) {
                      BusSeat seat = BusSeat(
                        "",
                        "Door",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  position++;
                  BusSeat seat = BusSeat(
                    "",
                    "Door",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              } else if (t == "s") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    if (p == 0) {
                      Seat dd = seatList.elementAt(seatPosition);
                      BusSeat seat = BusSeat(
                        "${dd.dsId}",
                        "${dd.seatName}",
                        "${dd.seatStatus}",
                        dd.forSale!,
                        sc,
                        gender: dd.gender,
                        fareDetails: dd.fareDetails,
                      );

                      seatArrayList.add(seat);

                      seatPosition++;
                      position++;
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  Seat dd = seatList.elementAt(seatPosition);
                  BusSeat seat = BusSeat(
                    "${dd.dsId}",
                    "${dd.seatName}",
                    "${dd.seatStatus}",
                    dd.forSale!,
                    sc,
                    gender: dd.gender,
                    fareDetails: dd.fareDetails,
                  );

                  seatArrayList.add(seat);

                  seatPosition++;
                  position++;
                }
              } else if (t == "h") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p == 0) {
                      BusSeat seat = BusSeat(
                        "",
                        "Hostess",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  position++;
                  BusSeat seat = BusSeat(
                    "",
                    "Hostess",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              } else if (t == "l") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p == col - 1) {
                      BusSeat seat = BusSeat(
                        "",
                        "Lavatory",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  position++;
                  BusSeat seat = BusSeat(
                    "",
                    "Lavatory",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              } else if (t == "st") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p == 0) {
                      BusSeat seat = BusSeat(
                        "",
                        "Staff",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  position++;
                  BusSeat seat = BusSeat(
                    "",
                    "Staff",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              } else if (t == "e") {
                int col = int.parse(c);
                if (col > 1) {
                  for (int p = 0; p < col; p++) {
                    position++;
                    if (p == 0) {
                      BusSeat seat = BusSeat(
                        "",
                        "Engine",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    } else {
                      ++in_Dex;
                      index = in_Dex.toString();
                      BusSeat seat = BusSeat(
                        "",
                        "",
                        "",
                        -1,
                        sc,
                      );
                      seatArrayList.add(seat);
                    }
                  }
                } else {
                  position++;
                  BusSeat seat = BusSeat(
                    "",
                    "Engine",
                    "",
                    -1,
                    sc,
                  );
                  seatArrayList.add(seat);
                }
              }
              lastIndex = int.parse(index);
            }

            if (countK > k) {
              k = countK;
            }
            countK = 0;
          } else {
            List rowlist = row as List;
            //  print(row.toString());
            int jLength = row.length;
            if (rowlist.length > k) {
              k = rowlist.length;
            }
            Map data;
            for (int l = 0; l < rowlist.length; l++) {
              data = rowlist.elementAt(l);
              // jsonObject1 = jsonArray.getJSONArray(i).getJSONObject(l);
              //   Log.e(TAG, "object : " + jsonObject1.toString());

              if (data.containsKey("t")) {
                t = data["t"];
              }

              if (data.containsKey("n")) {
                n = data["n"];
              }

              if (data.containsKey("sc")) {
                sc = data["sc"];
              }

              if (data.containsKey("c")) {
                c = data["c"];
              } else {
                c = "0";
              }

              if (data.containsKey("r")) {
                r = data["r"];
              }

              if (t == "st") {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "Staff",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "e") {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "Engine",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "dr") {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "Driver",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "c") {
                //  print("object->$r");
                if (r.isNotEmpty) {
                  total = int.parse(r);
                }
                //   cIndex = Integer.parseInt(index);
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "") {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "b") {
                position++;
                if (n.isNotEmpty) {
                  log("n.isNotEmpty ->$n");
                }
                BusSeat seat = BusSeat(
                  "",
                  n.isNotEmpty ? n : "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "do") {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "Door",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "s") {
                Seat dd = seatList.elementAt(seatPosition);
                BusSeat seat = BusSeat(
                  "${dd.dsId}",
                  "${dd.seatName}",
                  "${dd.seatStatus}",
                  dd.forSale!,
                  sc,
                  gender: dd.gender,
                  fareDetails: dd.fareDetails,
                );

                seatArrayList.add(seat);

                seatPosition++;
                position++;
              } else if (t == "h") {
                int col = int.parse(c);

                for (int p = 0; p < col; p++) {
                  position++;
                  if (p == 0) {
                    BusSeat seat = BusSeat(
                      "",
                      "Hostess",
                      "",
                      -1,
                      sc,
                    );
                    seatArrayList.add(seat);
                  } else {
                    BusSeat seat = BusSeat(
                      "",
                      "",
                      "",
                      -1,
                      sc,
                    );
                    seatArrayList.add(seat);
                  }
                }
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              } else if (t == "l") {
                int col = int.parse(c);
                for (int p = 0; p < col; p++) {
                  position++;
                  if (p == 0) {
                    BusSeat seat = BusSeat(
                      "",
                      "",
                      "",
                      -1,
                      sc,
                    );
                    seatArrayList.add(seat);
                  } else {
                    BusSeat seat = BusSeat(
                      "",
                      "Lavatory",
                      "",
                      -1,
                      sc,
                    );
                    seatArrayList.add(seat);
                  }
                }
              }
            }
            if (jLength < totalColumn) {
              int restColumn = totalColumn - jLength;

              for (int j = 0; j < restColumn; j++) {
                position++;
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              }
            }
          }
        } catch (e) {
          print("exc--${e}");
        }
        lastIndex = 0;
      }

      //  print(seatArrayList.length);
    } else {
      List stData = seatTemplate["stData"];
      totalSeat = int.parse(seatTemplate["stTotalSeat"]);
      spaceFromLeft = int.parse(seatTemplate["stColumnRight"]);

      totalColumn = int.parse(seatTemplate["stTotalColumn"]);
      lastColumn = int.parse(seatTemplate["stLastColumnSeat"]);
      stEnginePosition = int.parse(seatTemplate["stEnginePosition"]);

      j = SeatProcess.getSpaceFrom(spaceFromLeft, totalColumn);
      divider = SeatProcess.getDivider(j, spaceFromLeft);

      int l = 0;
      String sc = "0";
      if (stType == "3") {
        sTotalRow = SeatProcess.getRow(totalSeat, totalColumn) + 1;
      } else {
        sTotalRow = SeatProcess.getRow(totalSeat, totalColumn);
      }

      int c = totalColumn + 1;
      sTotalSeatItem = SeatProcess.getTotalItem(sTotalRow, c);

      for (int i = 0; i < sTotalSeatItem; i++) {
        if (stType == "3") {
          if (i == 0 || i == 1) {
            BusSeat seat = BusSeat(
              "",
              "",
              "",
              -1,
              sc,
            );
            seatArrayList.add(seat);
          } else if (j % divider == 0) {
            if (totalColumn != lastColumn) {
              if (j / divider == sTotalRow) {
                Seat dd = seatList.elementAt(l);
                BusSeat seat = BusSeat(
                  "${dd.dsId}",
                  "${dd.seatName}",
                  "${dd.seatStatus}",
                  dd.forSale!,
                  sc,
                  gender: dd.gender,
                  fareDetails: dd.fareDetails,
                );
                seatArrayList.add(seat);

                l++;
              } else {
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              }
            } else {
              BusSeat seat = BusSeat(
                "",
                "",
                "",
                -1,
                sc,
              );
              seatArrayList.add(seat);
            }
          } else {
            Seat dd = seatList.elementAt(l);
            BusSeat seat = BusSeat(
              "${dd.dsId}",
              "${dd.seatName}",
              "${dd.seatStatus}",
              dd.forSale!,
              sc,
              gender: dd.gender,
              fareDetails: dd.fareDetails,
            );
            seatArrayList.add(seat);
            l++;
          }
        } else {
          if (j % divider == 0) {
            if (totalColumn != lastColumn) {
              if (j / divider == sTotalRow) {
                Seat dd = seatList.elementAt(l);
                BusSeat seat = BusSeat(
                  "${dd.dsId}",
                  "${dd.seatName}",
                  "${dd.seatStatus}",
                  dd.forSale!,
                  sc,
                  gender: dd.gender,
                  fareDetails: dd.fareDetails,
                );
                seatArrayList.add(seat);

                l++;
              } else {
                BusSeat seat = BusSeat(
                  "",
                  "",
                  "",
                  -1,
                  sc,
                );
                seatArrayList.add(seat);
              }
            } else {
              BusSeat seat = BusSeat(
                "",
                "",
                "",
                -1,
                sc,
              );
              seatArrayList.add(seat);
            }
          } else {
            Seat dd = seatList.elementAt(l);
            BusSeat seat = BusSeat(
              "${dd.dsId}",
              "${dd.seatName}",
              "${dd.seatStatus}",
              dd.forSale!,
              sc,
              gender: dd.gender,
              fareDetails: dd.fareDetails,
            );
            seatArrayList.add(seat);
            l++;
          }
        }

        j++;
      }
    }

    column = 0;
    if (stType == "4") {
      column = totalColumn;
    } else {
      column = totalColumn + 1;
    }

    // print("column->${column}---$totalColumn");
    return SeatLayoutModel(column, seatArrayList);
  }

  int getColum() {
    return column;
  }

  int getColumnCount(List stData) {
    int indexValue = 0;
    int k = 0;
    for (int i = 0; i < stData.length; i++) {
      try {
        var row = stData.elementAt(i);
        if (row is Map) {
          var keys = row.keys.iterator;
          while (keys.moveNext()) {
            indexValue = int.parse(keys.current.toString()) + 1;
          }
          if (indexValue > k) {
            k = indexValue;
          }
          indexValue = 0;
        } else {
          int size = 0;
          size = (row as List).length;
          if (size > k) {
            k = size;
          }
        }
      } catch (e) {
        print("ex-$i-${e.toString()}");
      }
    }

    return k;
  }

  static int getRow(int totalSeat, int column) {
    return totalSeat ~/ column;
  }

  static int getTotalItem(int totalRow, int column) {
    return totalRow * column;
  }

  static int getDivider(int j, int spaceFrom) {
    return j + spaceFrom;
  }

  static int getSpaceFrom(int spaceFromLeft, int totalColumn) {
    int j = 3;
    if (spaceFromLeft == 1 && totalColumn == 3) {
      j = 3;
    } else if (spaceFromLeft == 1 && totalColumn == 4) {
      j = 4;
    } else if (spaceFromLeft == 2 && totalColumn == 3) {
      j = 2;
    } else if (spaceFromLeft == 2 && totalColumn == 4) {
      j = 3;
    } else if (spaceFromLeft == 3 && totalColumn == 3) {
      j = 1;
    } else if (spaceFromLeft == 3 && totalColumn == 4) {
      j = 2;
    }
    return j;
  }
}
