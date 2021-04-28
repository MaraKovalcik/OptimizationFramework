** MODEL Wait-and-see
* Setting of dimension for table
set i, j;
$gdxin %gdxincname%
$load i j
$gdxin

* Used variables
variable Z, x(j); positive variable x(j);

* Node significance (for calculate the critical path)
parameter c(j);
$gdxin %gdxincname%
$load c
$gdxin

* Matrix rigth sides for scenario
parameter xi(i);
$gdxin %gdxincname%
$load xi
$gdxin

* Constraint row
parameter bb(i);

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
equation objective_func, constraint(i);

* Objective function declaration
objective_func..  Z =E= sum(j, c(j) * x(j));

* Constraint declaration
constraint(i)..   sum(j, A(i,j)* x(j)) =G= bb(i);

* CPM model declaration
model CPM / objective_func, constraint /;

* Set constraints
bb(i) = xi(i);

* Model solving
solve CPM minimizing Z using LP;