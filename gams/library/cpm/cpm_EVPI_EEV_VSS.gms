* CALCULATE EVPI AND VSS CHARARACTERISTICS
* Setting of dimension for table
set i, j;
$gdxin %gdxincname%
$load i j
$gdxin

* Distinction of edges where recourse variables are used i2
set i1(i);
set i2(i);
$gdxin %gdxincname%
$load i1, i2
$gdxin

scalar resc / 0 /;

* Indexes of scenarios
set s;
$gdxin %gdxincname%
$load s
$gdxin
alias(s,ss);

* Used variables
variable Z, x(j);

positive variable x(j), yp(i2, s), ym(i2, s);

* Node t (for calculate the critical path)
parameter c(j);
$gdxin %gdxincname%
$load c
$gdxin

* Matrix rigth sides for each scenario
parameter xi(i, s);
$gdxin %gdxincname%
$load xi
$gdxin

* Defining recourse variables valus for edges in each scenario (plus)
parameter qp(i2, s);
$gdxin %gdxincname%
$load qp
$gdxin

* Defining recourse variables valus for edges in each scenario (minus)
parameter qm(i2, s);
$gdxin %gdxincname%
$load qm
$gdxin

* Constraint row
parameter bb(i, s);

* scenarios probability
parameter p(s);
parameter p(s);
$gdxin %gdxincname%
$load p
$gdxin

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

* Loop over each scenario
loop(s, bbTS(i, s) = Xi(i,s););
*
*
*        TS MODEL
*

* recourse variables limits
yp.UP(i2, s) =  smax(ss, bbTS(i2,ss)) - bbTS(i2, s);
ym.UP(i2, s) =  bbTS(i2, s) - smin(ss, bbTS(i2,ss));

* Solving
solve CPM_TS minimizing Z using LP;
ZminHN = Z.L;

* recourse
resc = sum(s, p(s)* sum( i2, qp(i2,s) * yp.L(i2,s) + qm(i2,s) * ym.L(i2,s)) );

*
*
*        WS MODEL
*
equation objective_funcWS, constraintWS(i);

* obejctive function declaration
objective_funcWS..  Z =E= sum(j, c(j) * x(j));

* Constraint declaration
constraintWS(i)..   sum(j, A(i,j)* x(j)) =G= bbWS(i);

* CPM model declaration
model CPM_WS / objective_funcWS, constraintWS /;

* Loop over each scenario
loop(s, bbWS(i) = Xi(i,s);
* Model solving
         solve CPM_WS minimizing Z using LP;
         zWSmin(s) = z.L;
);

EzWS = sum(s, p(s) * zWSmin(s));

EVPI = ZminHN - EzWS;

*
*   EEV and VSS
*

* Equations declaration
equation objective_funcEV, constraintEV(i);

* Objective function declaration
objective_funcEV..        Z =E= sum(j, c(j) * x(j));

* Constraints declaration
constraintEV(i)..     sum(j, A(i,j)* x(j)) =G= bbEV(i);

* CPM model declaration
model CPM_EV / objective_funcEV, constraintEV /;
bbEV(i) = sum(s, p(s) * Xi(i,s) );
solve CPM_EV minimizing Z using LP;
ZminEV = Z.L;
xEVmax(j) = x.L(j);
ym.UP(i2, s) =  smax(ss, bbTS(i2,ss)); ym.Lo(i2, s) = 0; yp.UP(i2, s) =  inf; yp.LO(i2, s) = 0;

* Fix x by EV model and verificate
x.LO(j) = xEVmax(j); x.UP(j) = xEVmax(j)
solve CPM_TS minimizing Z using LP;


EEV = Z.L;

* recourse
resc = sum(s, p(s)* sum( i2, qp(i2,s) * yp.L(i2,s) + qm(i2,s) * ym.L(i2,s)) );

VSS = EEV - ZminHN;