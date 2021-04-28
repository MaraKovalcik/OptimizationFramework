** MODEL MM for small data
* Setting of dimension for table
set i / 1 * 18 /, j / 1 * 13 /;
* Indexes of scenarios
set s /1 * 2/;
* Used variables
variable Z, x(j); positive variable x(j);
* Node significance (for calculate the critical path)
parameter c(j) /1 0, 2 0, 3 0, 4 0, 5 0, 6 0, 7 0, 8 0, 9 0, 10 0, 11 0, 12 0, 13 1/;
* Matrix rigth sides for each scenario
parameter Xi(i, s) /
* scenario 1
1.1 4.25, 2.1 4.25, 3.1 4.25, 4.1 4.25, 5.1 2.25, 6.1 54, 7.1 23, 8.1 54, 9.1 23, 10.1 2, 11.1 3.5, 12.1 2, 13.1 1.00, 14.1 7, 15.1 1, 16.1 3.00, 17.1 6, 18.1 3,
* scenario 2
1.2 4.25, 2.2 4.25, 3.2 4.25, 4.2 4.25, 5.2 1.25, 6.2 54, 7.2 23, 8.2 54, 9.2 23, 10.2 2, 11.2 3.5, 12.2 2, 13.2 2.25, 14.2 7, 15.2 1, 16.2 4.75, 17.2 6, 18.2 3
/ ;
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
* Defining output file  and write legend
file out /"cpm_MM_SD.txt"/; put out;
put "=== Legend ===" /;
put "i = scenario index" /;
put "stat = optimization status, 1 = optimal, else http://www.gamsworld.org/performance/status_codes.htm" /;
put "Z = critical path length" /;
put "bj = constraints, depends on scenario( 1..18 )" /;
put "xj = start time of activity j, j is from ( 1..13 ), a13 = END NODE" /;
* Write scearios informations
put / "=== Scenarios ===" /;
put "i  "; loop(i, put " b",i.TL:5:2 ); put /;
* Loop over each scenario
loop(s, b(i) = Xi(i,s);
         put s.TL:2;
         loop(i, put b(i):6:2, " "; );
         put /;
);

put / "=== Results ===" /;
* Output table header
put "stat ", "  Z      "; loop(j, put "x",j.TL:6:2); put /;
* Model solving
bb(i,s) = Xi(i,s);
solve CPM minimizing Z using LP;
* Display results
display Z.L;
* Write collected data to output file
put CPM.modelstat:3:0, " ", Z.L:7:2;loop(j,put x.L(j):7:2;);

