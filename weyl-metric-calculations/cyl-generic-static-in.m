(* ::Package:: *)

(* 
 CompInRW.m, sample file for Components. This contains the
 spatially flat Robertson-Walker metric of an isotropic universe.
*) 

Dimension = 4

CompSimpRules = {}

CompSimp[a_] := Together[Expand[a //. CompSimpRules]]

x/: x[1] = \[Rho]
 
x/: x[2] = z
 
x/: x[3] = \[Phi]
 
x/: x[4] = t
 
Metricg/: Metricg[-1, -1] = -Exp[2*(\[Nu][\[Rho],z]-\[Lambda][\[Rho],z])]
 
Metricg/: Metricg[-2, -1] = 0
 
Metricg/: Metricg[-3, -1] = 0
 
Metricg/: Metricg[-4, -1] = 0
 
Metricg/: Metricg[-2, -2] = -Exp[2*(\[Nu][\[Rho],z]-\[Lambda][\[Rho],z])]
 
Metricg/: Metricg[-3, -2] = 0
 
Metricg/: Metricg[-4, -2] = 0
 
Metricg/: Metricg[-3, -3] = -\[Rho]^2*Exp[-2*\[Lambda][\[Rho],z]]
 
Metricg/: Metricg[-4, -3] = 0
 
Metricg/: Metricg[-4, -4] = Exp[2*\[Lambda][\[Rho],z]]

Rmsign = 1

Rcsign = 1

CalcEinstein = 1   

CalcRiemann = 1 

CalcWeyl = 1 

(* End of file CompInRW.m *)
