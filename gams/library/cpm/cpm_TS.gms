* MODEL TS
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
* MODEL DEFINITION
*
* Equations declaration
equation objective_func, constraint_without_resc_vars(i1), constraint_with_resc_vars(i2, s);
* Objective function declaration with adding compensatory variables
objective_func.. Z =E= sum(j, c(j)*x(j))+ sum(s, p(s)* sum(i2, qp(i2,s) * yp(i2,s) +
                     qm(i2,s) * ym(i2,s)));

* Constraint withoud recourse variables
constraint_without_resc_vars(i1).. sum(j, A(i1,j) * x(j)) =G= bb(i1, "1");

* Constraint with recourse variables
constraint_with_resc_vars(i2, s).. sum(j, A(i2,j) * x(j)) =E= bb(i2, s) + yp(i2, s) -  ym(i2, s);

* CPM model declaration
model CPM / objective_func, constraint_without_resc_vars, constraint_with_resc_vars /;

loop(s, bb(i, s) = Xi(i,s););

*
* SOLVE FOR EACH SCENARIO
*
* recourse variables limits
yp.UP(i2, s) =  smax(ss, bb(i2,ss)) - bb(i2, s);
ym.UP(i2, s) =  bb(i2, s) - smin(ss, bb(i2,ss));

* Solving
solve CPM minimizing Z using LP;

* recourse
resc = sum(s, p(s)* sum( i2, qp(i2,s) * yp.L(i2,s) + qm(i2,s) * ym.L(i2,s)) );