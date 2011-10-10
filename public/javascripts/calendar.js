function show_calendar(){
// ****************
// **   下準備   **
// ****************
var myDate    = new Date();                                    // 今日の日付データ取得
var myWeekTbl = new Array("日","月","火","水","木","金","土");  // 曜日テーブル定義
var myMonthTbl= new Array(31,28,31,30,31,30,31,31,30,31,30,31);// 月テーブル定義
var myYear = myDate.getYear();                                 // 下２桁の西暦取得
var myYear = (myYear<2000) ? (1900+myYear) : (myYear);         // ４桁の西暦に変換
if (((myYear%4)==0 && (myYear%100)!=0) || (myYear%400)==0) // うるう年だったら...
   myMonthTbl[1] = 29;                                     // 　２月を２９日とする
var myMonth = myDate.getMonth();                               // 月を取得(0月～11月)
var myToday = myDate.getDate();                                // 今日の'日'を退避

myDate.setDate(1);                                         // 日付を'１日'に変えて、
myWeek = myDate.getDay();                                  // 　'１日'の曜日を取得
myTblLine = Math.ceil((myWeek+myMonthTbl[myMonth])/7);     // カレンダーの行数
myTable   = new Array(7*myTblLine);                        // 表のセル数分定義

var i = 0;

for(i=0; i<7*myTblLine; i++) myTable[i]="　";              // myTableを掃除する
for(i=0; i<myMonthTbl[myMonth]; i++)myTable[i+myWeek]=i+1; // 日付を埋め込む

// ***********************
// **  カレンダーの表示  **
// ***********************
document.write("<table border='1' cellspacing='0' ");      // 表の作成開始
document.write("class='calender' ");

document.write("<tr><td colspan='7' class='cal_title'>");  // 見出し行セット
document.write("<strong>",myYear, "年", (myMonth+1), "月カレンダー</strong>");
document.write("</td></tr>");

document.write("<tr>");                                    // 曜日見出しセット
for(i=0; i<7; i++){                                        // 一行(１週間)ループ
   document.write("<td align='center' ");
   if(i==0)document.write("class='sunday_title'>");           // 日曜のセルの色
   else    document.write("class='otherday_title'>");           // 月～土のセルの色
   document.write("<strong>",myWeekTbl[i],"</strong>");    // '日'から'土'の表示
   document.write("</td>");
}
document.write("</tr>");

for(i=0; i<myTblLine; i++){                                // 表の「行」のループ
   document.write("<tr>");                                 // 行の開始
   for(j=0; j<7; j++){                                     // 表の「列」のループ
      document.write("<td align='center' ");               // 列(セル)の作成
      myDat = myTable[j+(i*7)];                            // 書きこむ内容の取得
      if (myDat==myToday)document.write("class='today'"); // 今日のセルの色
      else if(j==0)      document.write("class='sunday'"); // 日曜のセルの色
      else               document.write("class='otherday'"); // 平日のセルの色
      document.write("<strong>",myDat,"</strong>");        // 日付セット
      document.write("</td>");                             // 列(セル)の終わり
   }
   document.write("</tr>");                                // 行の終わり
}
document.write("</table>");                                // 表の終わり
}
