* CALCULATE EVPI AND VSS CHARARACTERISTICS FOR SMALL DATA
* Setting of dimension for table
set i / 1 * 18 /,
    j / 1 * 13 /;
* Distinction of edges where recourse variables are used i2
set i1(i) / 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 /;
set i2(i) / 5, 13, 16 /;
scalar resc / 0 /;
* Indexes of scenarios
set s / 1 * 2 /;
alias(s,ss);
* Used variables
variable Z, x(j);
positive variable x(j), yp(i2, s), ym(i2, s);
* Node t (for calculate the critical path)
parameter c(j) /1 0, 2 0, 3 0, 4 0, 5 0, 6 0, 7 0, 8 0, 9 0, 10 0, 11 0, 12 0, 13 1/;
* Matrix rigth sides for each scenario
parameter Xi(i, s) /
* scenario 1
1.1 4.25, 2.1 4.25, 3.1 4.25, 4.1 4.25, 5.1 2.25, 6.1 54, 7.1 23, 8.1 54, 9.1 23, 10.1 2, 11.1 3.5, 12.1 2, 13.1 1.00, 14.1 7, 15.1 1, 16.1 3.00, 17.1 6, 18.1 3,
* scenario 2
1.2 4.25, 2.2 4.25, 3.2 4.25, 4.2 4.25, 5.2 1.25, 6.2 54, 7.2 23, 8.2 54, 9.2 23, 10.2 2, 11.2 3.5, 12.2 2, 13.2 2.25, 14.2 7, 15.2 1, 16.2 4.75, 17.2 6, 18.2 3
/ ;
* Defining recourse variables valus for edges in each scenario (plus)
parameter qp(i2, s) / 5.1 1.25, 13.1 3.78, 16.1 2.78, 5.2 2.30, 13.2 2.85, 16.2 1.85/;
* Defining recourse variables valus for edges in each scenario (minus)
parameter qm(i2, s) / 5.1 6.45, 13.1 8.20, 16.1 7.20, 5.2 7.15, 13.2 7.45, 16.2 6.45 /;
* scenarios probability
parameter p(s) / 1 0.6, 2 0.4 /;
*output file
file out /"cpm_EVPI_VSS_SD.txt"/; put out;
put "=== Legend ===" /;
put "i = scenario index" /;
put "stat = optimization status, 1 = optimal, else http://www.gamsworld.org/performance/status_codes.htm" /;
put "p = scenario probability" /;
put "Z = critical path length" /;
put "bj = constraints, depends on scenario( 1..18 )" /;
put "xj = start time of activity j, j is from ( 1..13 ), a13 = END NODE" /;
put "ypk, ymk = recourse variables for constraint (edge) k, k is from {5, 13, 16}" /;
put "resc = recoursion for a scenario" /;
* Scalars and parameters for calculate EVPI and VSS
parameter bbTS(i, s), bbWS(i), bbEV(i), zWSmin(s), zEVmin(s), xEVmax(j);
scalar ZminHN, EzWS, EVPI, ZminEV, EEV, VSS;
* Constraints
table A(i,j)
         1       2       3       4       5       6       7       8       9       10      11      12      13
1        -1      1
2        -1              1
3        -1                              1
4        -1                                      1
5                        -1      1
6                                1       -1
7                                1               -1
8                                        -1              1
9                                                -1      1
10                               -1                      1
11               -1                                              1
12                               -1                              1
13                                                       -1              1
14                                                               -1      1
15                                                                       -1      1
16                                                                               -1      1
17                                                                                       -1      1
18                                                                                               -1      1;
*
* TS MODEL DEFINITION
*
* Equations declaration
equation objective_funcTS, constraint_without_resc_varsTS(i1), constraint_with_resc_varsTS(i2, s);
* Objective function declaration with adding compensatory variables
objective_funcTS.. Z =E= sum(j, c(j)*x(j)) + sum(s, p(s)* sum(i2, qp(i2,s) * yp(i2,s) + qm(i2,s) * ym(i2,s)));
* Constraint withoud recourse variables
constraint_without_resc_varsTS(i1).. sum(j, A(i1,j) * x(j)) =G= bbTS(i1, "1");
* Constraint with recourse variables
constraint_with_resc_varsTS(i2, s).. sum(j, A(i2,j) * x(j)) =E= bbTS(i2, s) + yp(i2, s) -  ym(i2, s);
* CPM model declaration

model CPM_TS / objective_funcTS, constraint_without_resc_varsTS, constraint_with_resc_varsTS /;
*
* OUTPUT FILE
*
* Write scearios informations
put / "=== Scenarios ===" /;
put "i ", "  p     "; loop(i, put " b",i.TL:5:2 ); put /;
* Loop over each scenario
loop(s, bbTS(i, s) = Xi(i,s);
         put s.TL:2, p(s):5:2, " ";
         loop(i, put bbTS(i, s):6:2, " "; );
         put /;
);
*
*
*        TS MODEL
*
* Write recourse variables informations
put / "=== Recourse variables ===" /;
put "i ", "  p     ",  " yp5 ", "  yp13 ", "  yp16", "    ym5 ", "  ym13 ", "  ym16 ",  put /;
* Loop over each scenario
loop(s,
         put s.TL:2, p(s):5:2, " ";
         loop(i2, put qp(i2,s):6:2, " "; );
         loop(i2, put qm(i2,s):6:2, " "; );
         put /;
);
* Write results
put / "=== Result for TS (HN) ===" /;
put " stat ", "    Z      "; loop(j, put "x",j.TL:6:2); put "resc" /;
*
* SOLVE
*
* recourse variables limits
yp.UP(i2, s) =  smax(ss, bbTS(i2,ss)) - bbTS(i2, s);
ym.UP(i2, s) =  bbTS(i2, s) - smin(ss, bbTS(i2,ss));
* Solving
solve CPM_TS minimizing Z using LP;
ZminHN = Z.L;
* recourse
resc = sum(s, p(s)* sum( i2, qp(i2,s) * yp.L(i2,s) + qm(i2,s) * ym.L(i2,s)) );
* Display results
display Z.L, x.L, bbTS, yp.L, yp.UP, ym.L, ym.UP;
* Write collected data to output file
put CPM_TS.modelstat:3:0, "   ", Z.L:7:2; loop(j,put x.L(j):7:2;); put resc:8:2 /;
* recourse
put "  === Recourse ===" /;
put "  i ", "   yp5 ", "   ym5 ", "  yp13", "   ym13 ", "   yp16 ", "  ym16 ",  put /;
loop(s,
         put "  ", s.TL:2;
         loop(i2,
                 put "  ", yp.L(i2, s):5:2;
                 put "  ", ym.L(i2, s):5:2;
         );
         put /;
);

put / "ZminHN           = ", ZminHN:10:3 /;

*
*
*        WS MODEL
*
equation objective_funcWS, constraintWS(i);
* Purpose function declaration
objective_funcWS..  Z =E= sum(j, c(j) * x(j));
* Constraint declaration
constraintWS(i)..   sum(j, A(i,j)* x(j)) =G= bbWS(i);
* CPM model declaration
model CPM_WS / objective_funcWS, constraintWS /;

put / "=== Results for WS ===" /;
* Output table header
put "i ", " stat ", "  p ", "    Z      "; loop(j, put "x",j.TL:6:2); put /;
* Loop over each scenario
loop(s, bbWS(i) = Xi(i,s);
* Model solving
         solve CPM_WS minimizing Z using LP;
         zWSmin(s) = z.L;
* Display results
         display Z.L;
* Write collected data to output file
         put s.TL:2, CPM_WS.modelstat:3:0, "   ", p(s):5:2, Z.L:7:2;loop(j,put x.L(j):7:2;);
         put /;
);

EzWS = sum(s, p(s) * zWSmin(s));
put / "EzminWS          = ", EzWS:10:3 /;
EVPI = ZminHN - EzWS;
put   "EVPI             = ", EVPI:10:3 /;
*
*
*        EEV and VSS

put / "=== Results for EV (HN) ===" /;
* Equations declaration
equation objective_funcEV, constraintEV(i);
* Objective function declaration
objective_funcEV..        Z =E= sum(j, c(j) * x(j));
* Constraints declaration
constraintEV(i)..     sum(j, A(i,j)* x(j)) =G= bbEV(i);
* CPM model declaration
model CPM_EV / objective_funcEV, constraintEV /;
put  " stat ", "    Z     "; loop(j, put "x",j.TL:6:2); put /;
bbEV(i) = sum(s, p(s) * Xi(i,s) );
solve CPM_EV minimizing Z using LP;
ZminEV = Z.L;
xEVmax(j) = x.L(j);
put CPM_EV.modelstat:3:0, "   ", Z.L:7:2; loop(j,put x.L(j):7:2;);
put /;
put / "=== EEV verification ===" /;
ym.UP(i2, s) =  smax(ss, bbTS(i2,ss)); ym.Lo(i2, s) = 0; yp.UP(i2, s) =  inf; yp.LO(i2, s) = 0;
* Fix x by EV model and verificate
x.LO(j) = xEVmax(j); x.UP(j) = xEVmax(j)
solve CPM_TS minimizing Z using LP;
put " stat ", "    Z      "; loop(j, put "x",j.TL:6:2); put "resc" /;
EEV = Z.L;
* recourse
resc = sum(s, p(s)* sum( i2, qp(i2,s) * yp.L(i2,s) + qm(i2,s) * ym.L(i2,s)) );
* Write collected data to output file
put CPM_TS.modelstat:3:0, "   ", Z.L:7:2; loop(j,put x.L(j):7:2;); put resc:8:2 /;
* EEV and VSS characteristic
put / "EEV              = ", EEV:10:3;
VSS = EEV - ZminHN;
put / "VSS              = ", VSS:10:3 / /;




