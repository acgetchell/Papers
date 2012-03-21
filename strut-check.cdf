(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 8.0' *)

(*************************************************************************)
(*                                                                       *)
(*  The Mathematica License under which this file was created prohibits  *)
(*  restricting third parties in receipt of this file from republishing  *)
(*  or redistributing it by any means, including but not limited to      *)
(*  rights management or terms of use, without the express consent of    *)
(*  Wolfram Research, Inc.                                               *)
(*                                                                       *)
(*************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       835,         17]
NotebookDataLength[      7932,        310]
NotebookOptionsPosition[      7628,        280]
NotebookOutlinePosition[      7975,        295]
CellTagsIndexPosition[      7932,        292]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell[BoxData[
 RowBox[{
  RowBox[{"\[Lambda]", "[", 
   RowBox[{"r_", ",", "z_"}], "]"}], "=", 
  RowBox[{
   RowBox[{"-", "m"}], "/", 
   RowBox[{"Sqrt", "[", 
    RowBox[{
     SuperscriptBox["r", "2"], "+", 
     SuperscriptBox[
      RowBox[{"(", 
       RowBox[{"z", "-", "z0"}], ")"}], "2"]}], "]"}]}]}]], "Input",
 CellChangeTimes->{{3.5413114349145947`*^9, 3.5413114982553234`*^9}}],

Cell[BoxData[
 RowBox[{"-", 
  FractionBox["m", 
   SqrtBox[
    RowBox[{
     SuperscriptBox["r", "2"], "+", 
     SuperscriptBox[
      RowBox[{"(", 
       RowBox[{"z", "-", "z0"}], ")"}], "2"]}]]]}]], "Output",
 CellChangeTimes->{3.541311500158432*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"\[Nu]", "[", 
   RowBox[{"r_", ",", "z_"}], "]"}], "=", 
  RowBox[{
   RowBox[{"-", 
    SuperscriptBox["m", "2"]}], 
   RowBox[{
    SuperscriptBox["r", "2"], "/", 
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{
       SuperscriptBox["r", "2"], "+", 
       SuperscriptBox[
        RowBox[{"(", 
         RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "2"]}]}]}]], "Input",
 CellChangeTimes->{{3.541311578876333*^9, 3.541311628056851*^9}}],

Cell[BoxData[
 RowBox[{"-", 
  FractionBox[
   RowBox[{
    SuperscriptBox["m", "2"], " ", 
    SuperscriptBox["r", "2"]}], 
   SuperscriptBox[
    RowBox[{"(", 
     RowBox[{
      SuperscriptBox["r", "2"], "+", 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "2"]]}]], "Output",
 CellChangeTimes->{3.54131163147896*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"A", "=", 
  RowBox[{"D", "[", 
   RowBox[{
    RowBox[{"\[Lambda]", "[", 
     RowBox[{"r", ",", "z"}], "]"}], ",", "z"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.541311777288289*^9, 3.541311825751069*^9}, 
   3.541313771126891*^9}],

Cell[BoxData[
 FractionBox[
  RowBox[{"m", " ", 
   RowBox[{"(", 
    RowBox[{"z", "-", "z0"}], ")"}]}], 
  SuperscriptBox[
   RowBox[{"(", 
    RowBox[{
     SuperscriptBox["r", "2"], "+", 
     SuperscriptBox[
      RowBox[{"(", 
       RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], 
   RowBox[{"3", "/", "2"}]]]], "Output",
 CellChangeTimes->{3.541311829823268*^9, 3.541313778287901*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"B", "=", 
  RowBox[{"-", 
   RowBox[{"D", "[", 
    RowBox[{
     RowBox[{"\[Lambda]", "[", 
      RowBox[{"r", ",", "z"}], "]"}], ",", "r"}], "]"}]}]}]], "Input",
 CellChangeTimes->{{3.5413119754390173`*^9, 3.5413119972718725`*^9}}],

Cell[BoxData[
 RowBox[{"-", 
  FractionBox[
   RowBox[{"m", " ", "r"}], 
   SuperscriptBox[
    RowBox[{"(", 
     RowBox[{
      SuperscriptBox["r", "2"], "+", 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], 
    RowBox[{"3", "/", "2"}]]]}]], "Output",
 CellChangeTimes->{3.5413119999810276`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"F", "=", 
   RowBox[{"D", "[", 
    RowBox[{
     RowBox[{"\[Nu]", "[", 
      RowBox[{"r", ",", "z"}], "]"}], ",", "r"}], "]"}]}], 
  "\[IndentingNewLine]"}]], "Input",
 CellChangeTimes->{{3.5413138708985*^9, 3.541313910483732*^9}}],

Cell[BoxData[
 RowBox[{
  FractionBox[
   RowBox[{"4", " ", 
    SuperscriptBox["m", "2"], " ", 
    SuperscriptBox["r", "3"]}], 
   SuperscriptBox[
    RowBox[{"(", 
     RowBox[{
      SuperscriptBox["r", "2"], "+", 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "3"]], "-", 
  FractionBox[
   RowBox[{"2", " ", 
    SuperscriptBox["m", "2"], " ", "r"}], 
   SuperscriptBox[
    RowBox[{"(", 
     RowBox[{
      SuperscriptBox["r", "2"], "+", 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "2"]]}]], "Output",
 CellChangeTimes->{{3.541313891589647*^9, 3.5413139123017874`*^9}}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"G", "=", 
  RowBox[{
   RowBox[{"-", 
    RowBox[{"A", "^", "2"}]}], "-", 
   RowBox[{
    RowBox[{"(", 
     RowBox[{"1", "/", "r"}], ")"}], "F"}], "+", 
   RowBox[{"B", "^", "2"}]}]}]], "Input",
 CellChangeTimes->{{3.541313822638199*^9, 3.5413138501483526`*^9}, {
  3.541313938903943*^9, 3.541313951382021*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"-", 
   FractionBox[
    RowBox[{
     FractionBox[
      RowBox[{"4", " ", 
       SuperscriptBox["m", "2"], " ", 
       SuperscriptBox["r", "3"]}], 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{
         SuperscriptBox["r", "2"], "+", 
         SuperscriptBox[
          RowBox[{"(", 
           RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "3"]], "-", 
     FractionBox[
      RowBox[{"2", " ", 
       SuperscriptBox["m", "2"], " ", "r"}], 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{
         SuperscriptBox["r", "2"], "+", 
         SuperscriptBox[
          RowBox[{"(", 
           RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "2"]]}], "r"]}], 
  "+", 
  FractionBox[
   RowBox[{
    SuperscriptBox["m", "2"], " ", 
    SuperscriptBox["r", "2"]}], 
   SuperscriptBox[
    RowBox[{"(", 
     RowBox[{
      SuperscriptBox["r", "2"], "+", 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "3"]], "-", 
  FractionBox[
   RowBox[{
    SuperscriptBox["m", "2"], " ", 
    SuperscriptBox[
     RowBox[{"(", 
      RowBox[{"z", "-", "z0"}], ")"}], "2"]}], 
   SuperscriptBox[
    RowBox[{"(", 
     RowBox[{
      SuperscriptBox["r", "2"], "+", 
      SuperscriptBox[
       RowBox[{"(", 
        RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "3"]]}]], "Output",
 CellChangeTimes->{3.541313952669057*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"FullSimplify", "[", "G", "]"}]], "Input",
 CellChangeTimes->{{3.541313957228145*^9, 3.541313961253151*^9}}],

Cell[BoxData[
 FractionBox[
  RowBox[{
   SuperscriptBox["m", "2"], " ", 
   RowBox[{"(", 
    RowBox[{
     RowBox[{"-", 
      SuperscriptBox["r", "2"]}], "+", 
     SuperscriptBox[
      RowBox[{"(", 
       RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}]}], 
  SuperscriptBox[
   RowBox[{"(", 
    RowBox[{
     SuperscriptBox["r", "2"], "+", 
     SuperscriptBox[
      RowBox[{"(", 
       RowBox[{"z", "-", "z0"}], ")"}], "2"]}], ")"}], "3"]]], "Output",
 CellChangeTimes->{3.5413139627481527`*^9}]
}, Open  ]]
},
WindowSize->{707, 867},
WindowMargins->{{Automatic, -1446}, {Automatic, 100}},
FrontEndVersion->"8.0 for Microsoft Windows (64-bit) (October 6, 2011)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1257, 32, 390, 12, 33, "Input"],
Cell[1650, 46, 256, 9, 54, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[1943, 60, 483, 16, 33, "Input"],
Cell[2429, 78, 373, 13, 56, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[2839, 96, 257, 7, 31, "Input"],
Cell[3099, 105, 392, 13, 53, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[3528, 123, 257, 7, 31, "Input"],
Cell[3788, 132, 349, 12, 51, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[4174, 149, 268, 8, 52, "Input"],
Cell[4445, 159, 686, 23, 56, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[5168, 187, 337, 10, 31, "Input"],
Cell[5508, 199, 1429, 51, 73, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[6974, 255, 131, 2, 31, "Input"],
Cell[7108, 259, 504, 18, 57, "Output"]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature GwD8dE5W5QcwoBw6y9HhuDgI *)
