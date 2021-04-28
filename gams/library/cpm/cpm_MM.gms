** MODEL MM
* Setting of dimension for table
set i, j;
$gdxin %gdxincname%
$load i j
$gdxin
* Indexes of scenarios
set s;
$gdxin %gdxincname%
$load s
$gdxin

* Used variables
variable Z, x(j); positive variable x(j);

* Node significance (for calculate the critical path)
parameter c(j);
$gdxin %gdxincname%
$load c
$gdxin

* Matrix rigth sides for each scenario
parameter xi(i, s);;
$gdxin %gdxincname%
$load xi
$gdxin

* Constraint row
parameter b(i), bb(i,s);

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

* Equations declaration
equation objective_func, constraint(i, s);

* Objective function declaration
objective_func..    Z =E= sum(j, c(j) * x(j));

* Constraints declaration
constraint(i, s)..  sum(j, A(i,j)* x(j)) =G= bb(i,s);

* CPM model declaration
model CPM / objective_func, constraint /;

* Model solving
bb(i,s) = xi(i,s);
solve CPM minimizing Z using LP;