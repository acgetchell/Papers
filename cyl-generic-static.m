CompSimp[a_] := Together[Expand[a /. CompSimpRules]]


CompSimpOptions := {SetOptions[Together, Trig -> False], SetOptions[Expand, Trig -> False]}


CompSimpRules = {Cos[theta]^2 -> 1 - Sin[theta]^2, Cos[theta]^4 -> (1 - Sin[theta]^2)^2}


Evaluate[CompSimpOptions]

Off[MetricgFlag]

Print["MetricgFlag has been turned off."]

Rmsign = Rmsign

Rcsign = Rcsign

Dimension = Dimension

MatrixMetricgLower =
Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]

MatrixMetricgUpper =
Inverse[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]

Detg = Det[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]


Null


Metricg[a_, b_] := Metricg[b, a] /; IndicesAndNotOrderedQ[{a, b}]


AffineG[a_, b_, c_] := AffineG[a, c, b] /; IndicesAndNotOrderedQ[{b, c}]


RicciR[a_, b_] := RicciR[b, a] /; IndicesAndNotOrderedQ[{a, b}]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[b, s199]*RicciR[a, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[a, s299]*Metricg[b, s199]*RicciR[-s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b]


ScalarR = Sum[Metricg[i999, i999]*RicciR[-i999, -i999], {i999, 1, Dimension}] + 2*Sum[Metricg[j999, k999]*RicciR[-j999, -k999], {j999, 1, Dimension}, {k999, 1 + j999, Dimension}]


(* Done *)
CompSimp[a_] := Together[Expand[a /. CompSimpRules]]


CompSimpOptions := {SetOptions[Together, Trig -> False], SetOptions[Expand, Trig -> False]}


CompSimpRules = {Cos[theta]^2 -> 1 - Sin[theta]^2, Cos[theta]^4 -> (1 - Sin[theta]^2)^2}


Evaluate[CompSimpOptions]

Off[MetricgFlag]

Print["MetricgFlag has been turned off."]

Rmsign = Rmsign

Rcsign = Rcsign

Dimension = Dimension

MatrixMetricgLower =
Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]

MatrixMetricgUpper =
Inverse[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]

Detg = Det[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]


Null


Metricg[a_, b_] := Metricg[b, a] /; IndicesAndNotOrderedQ[{a, b}]


AffineG[a_, b_, c_] := AffineG[a, c, b] /; IndicesAndNotOrderedQ[{b, c}]


RicciR[a_, b_] := RicciR[b, a] /; IndicesAndNotOrderedQ[{a, b}]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[b, s199]*RicciR[a, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[a, s299]*Metricg[b, s199]*RicciR[-s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b]


ScalarR = Sum[Metricg[i999, i999]*RicciR[-i999, -i999], {i999, 1, Dimension}] + 2*Sum[Metricg[j999, k999]*RicciR[-j999, -k999], {j999, 1, Dimension}, {k999, 1 + j999, Dimension}]


(* Done *)
CompSimp[a_] := Together[Expand[a /. CompSimpRules]]


CompSimpOptions := {SetOptions[Together, Trig -> False], SetOptions[Expand, Trig -> False]}


CompSimpRules = {Cos[theta]^2 -> 1 - Sin[theta]^2, Cos[theta]^4 -> (1 - Sin[theta]^2)^2}


Evaluate[CompSimpOptions]

Off[MetricgFlag]

Print["MetricgFlag has been turned off."]

Rmsign = Rmsign

Rcsign = Rcsign

Dimension = Dimension

MatrixMetricgLower =
Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]

MatrixMetricgUpper =
Inverse[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]

Detg = Det[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]


Null


Metricg[a_, b_] := Metricg[b, a] /; IndicesAndNotOrderedQ[{a, b}]


AffineG[a_, b_, c_] := AffineG[a, c, b] /; IndicesAndNotOrderedQ[{b, c}]


RicciR[a_, b_] := RicciR[b, a] /; IndicesAndNotOrderedQ[{a, b}]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[b, s199]*RicciR[a, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[a, s299]*Metricg[b, s199]*RicciR[-s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b]


ScalarR = Sum[Metricg[i999, i999]*RicciR[-i999, -i999], {i999, 1, Dimension}] + 2*Sum[Metricg[j999, k999]*RicciR[-j999, -k999], {j999, 1, Dimension}, {k999, 1 + j999, Dimension}]


(* Done *)
CompSimp[a_] := Together[Expand[a /. CompSimpRules]]


CompSimpOptions := {SetOptions[Together, Trig -> False], SetOptions[Expand, Trig -> False]}


CompSimpRules = {Cos[theta]^2 -> 1 - Sin[theta]^2, Cos[theta]^4 -> (1 - Sin[theta]^2)^2}


Evaluate[CompSimpOptions]

Off[MetricgFlag]

Print["MetricgFlag has been turned off."]

Rmsign = Rmsign

Rcsign = Rcsign

Dimension = Dimension

MatrixMetricgLower =
Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]

MatrixMetricgUpper =
Inverse[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]

Detg = Det[Table[Metricg[-i999, -j999], {i999, Dimension}, {j999, Dimension}]]


Null


Metricg[a_, b_] := Metricg[b, a] /; IndicesAndNotOrderedQ[{a, b}]


AffineG[a_, b_, c_] := AffineG[a, c, b] /; IndicesAndNotOrderedQ[{b, c}]


RicciR[a_, b_] := RicciR[b, a] /; IndicesAndNotOrderedQ[{a, b}]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[b, s199]*RicciR[a, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[a, s299]*Metricg[b, s199]*RicciR[-s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b]


ScalarR = Sum[Metricg[i999, i999]*RicciR[-i999, -i999], {i999, 1, Dimension}] + 2*Sum[Metricg[j999, k999]*RicciR[-j999, -k999], {j999, 1, Dimension}, {k999, 1 + j999, Dimension}]


(* Done *)
CompSimp[a_] := Together[Expand[a //. CompSimpRules]]


CompSimpOptions := {SetOptions[Together, Trig -> False], SetOptions[Expand, Trig -> False]}


CompSimpRules = {}


Evaluate[CompSimpOptions]

Off[MetricgFlag]

Print["MetricgFlag has been turned off."]

Rmsign = 1

Rcsign = 1

Dimension = 4

MatrixMetricgLower =
{{-E^(2*(-\[Lambda][\[Rho], z] + \[Nu][\[Rho], z])), 0, 0, 0}, {0, -E^(2*(-\[Lambda][\[Rho], z] + \[Nu][\[Rho], z])), 0, 0}, {0, 0, -(\[Rho]^2/E^(2*\[Lambda][\[Rho], z])), 0}, {0, 0, 0, E^(2*\[Lambda][\[Rho], z])}}

MatrixMetricgUpper =
{{-E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z]), 0, 0, 0}, {0, -E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z]), 0, 0}, {0, 0, -(E^(2*\[Lambda][\[Rho], z])/\[Rho]^2), 0}, {0, 0, 0, E^(-2*\[Lambda][\[Rho], z])}}

Detg = -(E^(-4*\[Lambda][\[Rho], z] + 4*\[Nu][\[Rho], z])*\[Rho]^2)


x[1] = \[Rho]
 
x[2] = z
 
x[3] = \[Phi]
 
x[4] = t


Metricg[-4, -4] = E^(2*\[Lambda][\[Rho], z])
 
Metricg[-4, -3] = 0
 
Metricg[-4, -2] = 0
 
Metricg[-4, -1] = 0
 
Metricg[-4, 1] = 0
 
Metricg[-4, 2] = 0
 
Metricg[-4, 3] = 0
 
Metricg[-4, 4] = 1
 
Metricg[-3, -3] = -(\[Rho]^2/E^(2*\[Lambda][\[Rho], z]))
 
Metricg[-3, -2] = 0
 
Metricg[-3, -1] = 0
 
Metricg[-3, 1] = 0
 
Metricg[-3, 2] = 0
 
Metricg[-3, 3] = 1
 
Metricg[-3, 4] = 0
 
Metricg[-2, -2] = -E^(2*(-\[Lambda][\[Rho], z] + \[Nu][\[Rho], z]))
 
Metricg[-2, -1] = 0
 
Metricg[-2, 1] = 0
 
Metricg[-2, 2] = 1
 
Metricg[-2, 3] = 0
 
Metricg[-2, 4] = 0
 
Metricg[-1, -1] = -E^(2*(-\[Lambda][\[Rho], z] + \[Nu][\[Rho], z]))
 
Metricg[-1, 1] = 1
 
Metricg[-1, 2] = 0
 
Metricg[-1, 3] = 0
 
Metricg[-1, 4] = 0
 
Metricg[1, 1] = -E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])
 
Metricg[1, 2] = 0
 
Metricg[1, 3] = 0
 
Metricg[1, 4] = 0
 
Metricg[2, 2] = -E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])
 
Metricg[2, 3] = 0
 
Metricg[2, 4] = 0
 
Metricg[3, 3] = -(E^(2*\[Lambda][\[Rho], z])/\[Rho]^2)
 
Metricg[3, 4] = 0
 
Metricg[4, 4] = E^(-2*\[Lambda][\[Rho], z])
 
Metricg[a_, b_] := Metricg[b, a] /; IndicesAndNotOrderedQ[{a, b}]


AffineG[1, -4, -4] = E^(4*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*Derivative[1, 0][\[Lambda]][\[Rho], z]
 
AffineG[1, -4, -3] = 0
 
AffineG[1, -4, -2] = 0
 
AffineG[1, -4, -1] = 0
 
AffineG[1, -3, -3] = (\[Rho]*(-1 + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]))/E^(2*\[Nu][\[Rho], z])
 
AffineG[1, -3, -2] = 0
 
AffineG[1, -3, -1] = 0
 
AffineG[1, -2, -2] = Derivative[1, 0][\[Lambda]][\[Rho], z] - Derivative[1, 0][\[Nu]][\[Rho], z]
 
AffineG[1, -2, -1] = -Derivative[0, 1][\[Lambda]][\[Rho], z] + Derivative[0, 1][\[Nu]][\[Rho], z]
 
AffineG[1, -1, -1] = -Derivative[1, 0][\[Lambda]][\[Rho], z] + Derivative[1, 0][\[Nu]][\[Rho], z]
 
AffineG[2, -4, -4] = E^(4*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*Derivative[0, 1][\[Lambda]][\[Rho], z]
 
AffineG[2, -4, -3] = 0
 
AffineG[2, -4, -2] = 0
 
AffineG[2, -4, -1] = 0
 
AffineG[2, -3, -3] = (\[Rho]^2*Derivative[0, 1][\[Lambda]][\[Rho], z])/E^(2*\[Nu][\[Rho], z])
 
AffineG[2, -3, -2] = 0
 
AffineG[2, -3, -1] = 0
 
AffineG[2, -2, -2] = -Derivative[0, 1][\[Lambda]][\[Rho], z] + Derivative[0, 1][\[Nu]][\[Rho], z]
 
AffineG[2, -2, -1] = -Derivative[1, 0][\[Lambda]][\[Rho], z] + Derivative[1, 0][\[Nu]][\[Rho], z]
 
AffineG[2, -1, -1] = Derivative[0, 1][\[Lambda]][\[Rho], z] - Derivative[0, 1][\[Nu]][\[Rho], z]
 
AffineG[3, -4, -4] = 0
 
AffineG[3, -4, -3] = 0
 
AffineG[3, -4, -2] = 0
 
AffineG[3, -4, -1] = 0
 
AffineG[3, -3, -3] = 0
 
AffineG[3, -3, -2] = -Derivative[0, 1][\[Lambda]][\[Rho], z]
 
AffineG[3, -3, -1] = (1 - \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z])/\[Rho]
 
AffineG[3, -2, -2] = 0
 
AffineG[3, -2, -1] = 0
 
AffineG[3, -1, -1] = 0
 
AffineG[4, -4, -4] = 0
 
AffineG[4, -4, -3] = 0
 
AffineG[4, -4, -2] = Derivative[0, 1][\[Lambda]][\[Rho], z]
 
AffineG[4, -4, -1] = Derivative[1, 0][\[Lambda]][\[Rho], z]
 
AffineG[4, -3, -3] = 0
 
AffineG[4, -3, -2] = 0
 
AffineG[4, -3, -1] = 0
 
AffineG[4, -2, -2] = 0
 
AffineG[4, -2, -1] = 0
 
AffineG[4, -1, -1] = 0
 
AffineG[a_, b_, c_] := AffineG[a, c, b] /; IndicesAndNotOrderedQ[{b, c}]


RiemannR[-4, -3, -4, -3] = E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*\[Rho]*(\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2)
 
RiemannR[-4, -3, -4, -2] = 0
 
RiemannR[-4, -3, -4, -1] = 0
 
RiemannR[-4, -3, -3, -2] = 0
 
RiemannR[-4, -3, -3, -1] = 0
 
RiemannR[-4, -3, -2, -1] = 0
 
RiemannR[-4, -2, -4, -2] = -(E^(2*\[Lambda][\[Rho], z])*(2*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] + Derivative[0, 2][\[Lambda]][\[Rho], z] - Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z]))
 
RiemannR[-4, -2, -4, -1] = -(E^(2*\[Lambda][\[Rho], z])*(3*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] - Derivative[0, 1][\[Nu]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] - Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] + Derivative[1, 1][\[Lambda]][\[Rho], z]))
 
RiemannR[-4, -2, -3, -2] = 0
 
RiemannR[-4, -2, -3, -1] = 0
 
RiemannR[-4, -2, -2, -1] = 0
 
RiemannR[-4, -1, -4, -1] = E^(2*\[Lambda][\[Rho], z])*(Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] - 2*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - Derivative[2, 0][\[Lambda]][\[Rho], z])
 
RiemannR[-4, -1, -3, -2] = 0
 
RiemannR[-4, -1, -3, -1] = 0
 
RiemannR[-4, -1, -2, -1] = 0
 
RiemannR[-3, -2, -3, -2] = (\[Rho]*(\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + Derivative[1, 0][\[Nu]][\[Rho], z] - \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z]))/E^(2*\[Lambda][\[Rho], z])
 
RiemannR[-3, -2, -3, -1] = (\[Rho]*(-Derivative[0, 1][\[Nu]][\[Rho], z] - \[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[0, 1][\[Nu]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - \[Rho]*Derivative[1, 1][\[Lambda]][\[Rho], z]))/E^(2*\[Lambda][\[Rho], z])
 
RiemannR[-3, -2, -2, -1] = 0
 
RiemannR[-3, -1, -3, -1] = (\[Rho]*(\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - \[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] - Derivative[1, 0][\[Lambda]][\[Rho], z] - Derivative[1, 0][\[Nu]][\[Rho], z] + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z]))/E^(2*\[Lambda][\[Rho], z])
 
RiemannR[-3, -1, -2, -1] = 0
 
RiemannR[-2, -1, -2, -1] = -(E^(-2*\[Lambda][\[Rho], z] + 2*\[Nu][\[Rho], z])*(Derivative[0, 2][\[Lambda]][\[Rho], z] - Derivative[0, 2][\[Nu]][\[Rho], z] + Derivative[2, 0][\[Lambda]][\[Rho], z] - Derivative[2, 0][\[Nu]][\[Rho], z]))
 
RiemannR[i_, j_, k_, l_] := RiemannR[k, l, i, j] /; i == k && IndicesAndNotOrderedQ[{j, l}]
 
RiemannR[i_, j_, k_, l_] := 0 /; i == j || k == l
 
RiemannR[a_, b_, c_, d_] := -RiemannR[b, a, c, d] /; IndicesAndNotOrderedQ[{a, b}]
 
RiemannR[a_, b_, c_, d_] := -RiemannR[a, b, d, c] /; IndicesAndNotOrderedQ[{c, d}]
 
RiemannR[a_, b_, c_, d_] := RiemannR[c, d, a, b] /; IndicesAndNotOrderedQ[{a, c}]
 
RiemannR[a_, b_, c_, d_] := CompSimp[Sum[Metricg[d, s199]*RiemannR[a, b, c, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && NegIntegerQ[b] && NegIntegerQ[c] && PosIntegerQ[d]
 
RiemannR[a_, b_, c_, d_] := CompSimp[Sum[Metricg[c, s299]*Metricg[d, s199]*RiemannR[a, b, -s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; NegIntegerQ[a] && NegIntegerQ[b] && PosIntegerQ[c] && PosIntegerQ[d]
 
RiemannR[a_, b_, c_, d_] := CompSimp[Sum[Metricg[b, s299]*Metricg[d, s199]*RiemannR[a, -s299, c, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b] && NegIntegerQ[c] && PosIntegerQ[d]
 
RiemannR[a_, b_, c_, d_] := CompSimp[Sum[Metricg[b, s399]*Metricg[c, s299]*Metricg[d, s199]*RiemannR[a, -s399, -s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}, {s399, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b] && PosIntegerQ[c] && PosIntegerQ[d]
 
RiemannR[a_, b_, c_, d_] := CompSimp[Sum[Metricg[a, s499]*Metricg[b, s399]*Metricg[c, s299]*Metricg[d, s199]*RiemannR[-s499, -s399, -s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}, {s399, 1, Dimension}, {s499, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b] && PosIntegerQ[c] && PosIntegerQ[d]
 
RiemannR[a_, b_, c_, d_] := CompSimp[Sum[Metricg[b, s199]*RiemannR[a, -s199, c, d], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b] && NegIntegerQ[c] && NegIntegerQ[d]


RicciR[-4, -4] = (E^(4*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*(\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] + Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z]))/\[Rho]
 
RicciR[-4, -3] = 0
 
RicciR[-4, -2] = 0
 
RicciR[-4, -1] = 0
 
RicciR[-3, -3] = (\[Rho]*(\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] + Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z]))/E^(2*\[Nu][\[Rho], z])
 
RicciR[-3, -2] = 0
 
RicciR[-3, -1] = 0
 
RicciR[-2, -2] = (-2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 + \[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] + Derivative[1, 0][\[Lambda]][\[Rho], z] - Derivative[1, 0][\[Nu]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z])/\[Rho]
 
RicciR[-2, -1] = (Derivative[0, 1][\[Nu]][\[Rho], z] - 2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z])/\[Rho]
 
RicciR[-1, -1] = (\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] + Derivative[1, 0][\[Lambda]][\[Rho], z] - 2*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + Derivative[1, 0][\[Nu]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z])/\[Rho]
 
RicciR[a_, b_] := RicciR[b, a] /; IndicesAndNotOrderedQ[{a, b}]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[b, s199]*RicciR[a, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b]
 
RicciR[a_, b_] := CompSimp[Sum[Metricg[a, s299]*Metricg[b, s199]*RicciR[-s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b]


ScalarR = (2*E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*(\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - \[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] - Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/\[Rho]


EinsteinG[-4, -4] = -((E^(4*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*(\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - 2*\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] - 2*Derivative[1, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - 2*\[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/\[Rho])
 
EinsteinG[-4, -3] = 0
 
EinsteinG[-4, -2] = 0
 
EinsteinG[-4, -1] = 0
 
EinsteinG[-3, -3] = (\[Rho]^2*(Derivative[0, 1][\[Lambda]][\[Rho], z]^2 + Derivative[0, 2][\[Nu]][\[Rho], z] + Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + Derivative[2, 0][\[Nu]][\[Rho], z]))/E^(2*\[Nu][\[Rho], z])
 
EinsteinG[-3, -2] = 0
 
EinsteinG[-3, -1] = 0
 
EinsteinG[-2, -2] = (-(\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2) + \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - Derivative[1, 0][\[Nu]][\[Rho], z])/\[Rho]
 
EinsteinG[-2, -1] = (Derivative[0, 1][\[Nu]][\[Rho], z] - 2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z])/\[Rho]
 
EinsteinG[-1, -1] = (\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - \[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + Derivative[1, 0][\[Nu]][\[Rho], z])/\[Rho]
 
EinsteinG[i_, j_] := EinsteinG[j, i] /; IndicesAndNotOrderedQ[{i, j}]
 
EinsteinG[a_, b_] := CompSimp[Sum[Metricg[b, s199]*EinsteinG[a, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b]
 
EinsteinG[a_, b_] := CompSimp[Sum[Metricg[a, s299]*Metricg[b, s199]*EinsteinG[-s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b]


WeylC[-4, -3, -4, -3] = (E^(2*\[Lambda][\[Rho], z] - 2*\[Nu][\[Rho], z])*\[Rho]*(2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 + \[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] - 2*Derivative[1, 0][\[Lambda]][\[Rho], z] + 2*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/3
 
WeylC[-4, -3, -4, -2] = 0
 
WeylC[-4, -3, -4, -1] = 0
 
WeylC[-4, -3, -3, -2] = 0
 
WeylC[-4, -3, -3, -1] = 0
 
WeylC[-4, -3, -2, -1] = 0
 
WeylC[-4, -2, -4, -2] = -(E^(2*\[Lambda][\[Rho], z])*(8*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - 6*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] + 4*\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] - 2*Derivative[1, 0][\[Lambda]][\[Rho], z] - 4*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - 3*Derivative[1, 0][\[Nu]][\[Rho], z] + 6*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - 2*\[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/(6*\[Rho])
 
WeylC[-4, -2, -4, -1] = (E^(2*\[Lambda][\[Rho], z])*(-Derivative[0, 1][\[Nu]][\[Rho], z] - 4*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] + 2*\[Rho]*Derivative[0, 1][\[Nu]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] + 2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - 2*\[Rho]*Derivative[1, 1][\[Lambda]][\[Rho], z]))/(2*\[Rho])
 
WeylC[-4, -2, -3, -2] = 0
 
WeylC[-4, -2, -3, -1] = 0
 
WeylC[-4, -2, -2, -1] = 0
 
WeylC[-4, -1, -4, -1] = (E^(2*\[Lambda][\[Rho], z])*(4*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - 6*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] + 2*\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] + 2*Derivative[1, 0][\[Lambda]][\[Rho], z] - 8*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - 3*Derivative[1, 0][\[Nu]][\[Rho], z] + 6*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - 4*\[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/(6*\[Rho])
 
WeylC[-4, -1, -3, -2] = 0
 
WeylC[-4, -1, -3, -1] = 0
 
WeylC[-4, -1, -2, -1] = 0
 
WeylC[-3, -2, -3, -2] = -(\[Rho]*(4*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - 6*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] + 2*\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] + 2*Derivative[1, 0][\[Lambda]][\[Rho], z] - 8*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - 3*Derivative[1, 0][\[Nu]][\[Rho], z] + 6*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - 4*\[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] + \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/(6*E^(2*\[Lambda][\[Rho], z]))
 
WeylC[-3, -2, -3, -1] = (\[Rho]*(-Derivative[0, 1][\[Nu]][\[Rho], z] - 4*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] + 2*\[Rho]*Derivative[0, 1][\[Nu]][\[Rho], z]*Derivative[1, 0][\[Lambda]][\[Rho], z] + 2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - 2*\[Rho]*Derivative[1, 1][\[Lambda]][\[Rho], z]))/(2*E^(2*\[Lambda][\[Rho], z]))
 
WeylC[-3, -2, -2, -1] = 0
 
WeylC[-3, -1, -3, -1] = (\[Rho]*(8*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 - 6*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]*Derivative[0, 1][\[Nu]][\[Rho], z] + 4*\[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] - 2*Derivative[1, 0][\[Lambda]][\[Rho], z] - 4*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 - 3*Derivative[1, 0][\[Nu]][\[Rho], z] + 6*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]*Derivative[1, 0][\[Nu]][\[Rho], z] - 2*\[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/(6*E^(2*\[Lambda][\[Rho], z]))
 
WeylC[-3, -1, -2, -1] = 0
 
WeylC[-2, -1, -2, -1] = -(E^(-2*\[Lambda][\[Rho], z] + 2*\[Nu][\[Rho], z])*(2*\[Rho]*Derivative[0, 1][\[Lambda]][\[Rho], z]^2 + \[Rho]*Derivative[0, 2][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[0, 2][\[Nu]][\[Rho], z] - 2*Derivative[1, 0][\[Lambda]][\[Rho], z] + 2*\[Rho]*Derivative[1, 0][\[Lambda]][\[Rho], z]^2 + \[Rho]*Derivative[2, 0][\[Lambda]][\[Rho], z] - \[Rho]*Derivative[2, 0][\[Nu]][\[Rho], z]))/(3*\[Rho])
 
WeylC[i_, j_, k_, l_] := 0 /; i == j || k == l
 
WeylC[i_, j_, k_, l_] := -WeylC[i, j, l, k] /; IndicesAndNotOrderedQ[{k, l}]
 
WeylC[i_, j_, k_, l_] := -WeylC[j, i, k, l] /; IndicesAndNotOrderedQ[{i, j}]
 
WeylC[i_, j_, k_, l_] := WeylC[k, l, i, j] /; IndicesAndNotOrderedQ[{i, k}]
 
WeylC[i_, j_, k_, l_] := WeylC[k, l, i, j] /; i == k && IndicesAndNotOrderedQ[{j, l}]
 
WeylC[a_, b_, c_, d_] := CompSimp[Sum[Metricg[d, s199]*WeylC[a, b, c, -s199], {s199, 1, Dimension}]] /; NegIntegerQ[a] && NegIntegerQ[b] && NegIntegerQ[c] && PosIntegerQ[d]
 
WeylC[a_, b_, c_, d_] := CompSimp[Sum[Metricg[c, s299]*Metricg[d, s199]*WeylC[a, b, -s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; NegIntegerQ[a] && NegIntegerQ[b] && PosIntegerQ[c] && PosIntegerQ[d]
 
WeylC[a_, b_, c_, d_] := CompSimp[Sum[Metricg[b, s299]*Metricg[d, s199]*WeylC[a, -s299, c, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b] && NegIntegerQ[c] && PosIntegerQ[d]
 
WeylC[a_, b_, c_, d_] := CompSimp[Sum[Metricg[b, s399]*Metricg[c, s299]*Metricg[d, s199]*WeylC[a, -s399, -s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}, {s399, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b] && PosIntegerQ[c] && PosIntegerQ[d]
 
WeylC[a_, b_, c_, d_] := CompSimp[Sum[Metricg[a, s499]*Metricg[b, s399]*Metricg[c, s299]*Metricg[d, s199]*WeylC[-s499, -s399, -s299, -s199], {s199, 1, Dimension}, {s299, 1, Dimension}, {s399, 1, Dimension}, {s499, 1, Dimension}]] /; PosIntegerQ[a] && PosIntegerQ[b] && PosIntegerQ[c] && PosIntegerQ[d]
 
WeylC[a_, b_, c_, d_] := CompSimp[Sum[Metricg[b, s199]*RiemannR[a, -s199, c, d], {s199, 1, Dimension}]] /; NegIntegerQ[a] && PosIntegerQ[b] && NegIntegerQ[c] && NegIntegerQ[d]


(* Done *)
