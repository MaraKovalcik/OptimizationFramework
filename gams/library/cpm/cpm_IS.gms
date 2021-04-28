** MODEL IS
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
variable Z, Z_ver, x(j); positive variable x(j);
scalar zWSmin / 0 /;
parameter xWSmax(j);

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

* Constraint i
parameter bb(i);

* scenarios probability
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

* Equations declaration
equation objective_func, objective_func_ver, constraint(i);

* Objective function declaration
objective_func..    Z =E= sum(j, c(j) * x(j));

* Objective function declaration for model verification
objective_func_ver..    Z_ver =E= sum(j, c(j) * x(j));

* Constraints declaration
constraint(i)..     sum(j, A(i,j)* x(j)) =G= bb(i);

* CPM model declaration
model CPM / objective_func, constraint /;
model CPM_ver / objective_func_ver, constraint /;

bb(i) = xi(i,"1");
solve CPM minimizing Z using LP;
zWSmin = Z.L;
xWSmax(j) = x.L(j);

parameter ver(s);

* === Results verification ===
* Loop over each scenario
loop(s, bb(i) = xi(i,s);
* Constraint from the first scenario
         x.UP(j) = xWSmax(j);
* Model solving
         solve CPM_ver minimizing Z_ver using LP;
         ver(s) = CPM_ver.modelstat;
);