** MODEL MM for big data
* Setting of dimension for table
set i / 1 * 18 /, j / 1 * 13 /;
* Indexes of scenarios
set s /1 * 15/;
* Used variables
variable Z, x(j); positive variable x(j);
* Node significance (for calculate the critical path)
parameter c(j) /1 0, 2 0, 3 0, 4 0, 5 0, 6 0, 7 0, 8 0, 9 0, 10 0, 11 0, 12 0, 13 1/;
* Matrix rigth sides for each scenario
parameter Xi(i, s) /
* scenario 1
1.1 4.25, 2.1 4.25, 3.1 4.25, 4.1 4.25, 5.1 2.25, 6.1 54, 7.1 23, 8.1 54, 9.1 23, 10.1 2, 11.1 3.5, 12.1 2, 13.1 1.00, 14.1 7, 15.1 1, 16.1 3.00, 17.1 6, 18.1 3,
* scenario 2
1.2 4.25, 2.2 4.25, 3.2 4.25, 4.2 4.25, 5.2 1.25, 6.2 54, 7.2 23, 8.2 54, 9.2 23, 10.2 2, 11.2 3.5, 12.2 2, 13.2 2.25, 14.2 7, 15.2 1, 16.2 4.75, 17.2 6, 18.2 3,
* scenario 3
1.3 4.25, 2.3 4.25, 3.3 4.25, 4.3 4.25, 5.3 1.00, 6.3 54, 7.3 23, 8.3 54, 9.3 23, 10.3 2, 11.3 3.5, 12.3 2, 13.3 2.50, 14.3 7, 15.3 1, 16.3 2.00, 17.3 6, 18.3 3,
* scenario 4
1.4 4.25, 2.4 4.25, 3.4 4.25, 4.4 4.25, 5.4 1.25, 6.4 54, 7.4 23, 8.4 54, 9.4 23, 10.4 2, 11.4 3.5, 12.4 2, 13.4 2.75, 14.4 7, 15.4 1, 16.4 4.75, 17.4 6, 18.4 3,
* scenario 5
1.5 4.25, 2.5 4.25, 3.5 4.25, 4.5 4.25, 5.5 2.50, 6.5 54, 7.5 23, 8.5 54, 9.5 23, 10.5 2, 11.5 3.5, 12.5 2, 13.5 1.25, 14.5 7, 15.5 1, 16.5 3.00, 17.5 6, 18.5 3,
* scenario 6
1.6 4.25, 2.6 4.25, 3.6 4.25, 4.6 4.25, 5.6 2.00, 6.6 54, 7.6 23, 8.6 54, 9.6 23, 10.6 2, 11.6 3.5, 12.6 2, 13.6 3.00, 14.6 7, 15.6 1, 16.6 4.25, 17.6 6, 18.6 3,
* scenario 7
1.7 4.25, 2.7 4.25, 3.7 4.25, 4.7 4.25, 5.7 2.00, 6.7 54, 7.7 23, 8.7 54, 9.7 23, 10.7 2, 11.7 3.5, 12.7 2, 13.7 2.50, 14.7 7, 15.7 1, 16.7 4.75, 17.7 6, 18.7 3,
* scenario 8
1.8 4.25, 2.8 4.25, 3.8 4.25, 4.8 4.25, 5.8 3.00, 6.8 54, 7.8 23, 8.8 54, 9.8 23, 10.8 2, 11.8 3.5, 12.8 2, 13.8 2.50, 14.8 7, 15.8 1, 16.8 4.75, 17.8 6, 18.8 3,
* scenario 9
1.9 4.25, 2.9 4.25, 3.9 4.25, 4.9 4.25, 5.9 2.50, 6.9 54, 7.9 23, 8.9 54, 9.9 23, 10.9 2, 11.9 3.5, 12.9 2, 13.9 2.75, 14.9 7, 15.9 1, 16.9 4.25, 17.9 6, 18.9 3,
* scenario 10
1.10 4.25, 2.10 4.25, 3.10 4.25, 4.10 4.25, 5.10 2.75, 6.10 54, 7.10 23, 8.10 54, 9.10 23, 10.10 2, 11.10 3.5, 12.10 2, 13.10 1.25, 14.10 7, 15.10 1, 16.10 3.50, 17.10 6, 18.10 3,
* scenario 11
1.11 4.25, 2.11 4.25, 3.11 4.25, 4.11 4.25, 5.11 3.00, 6.11 54, 7.11 23, 8.11 54, 9.11 23, 10.11 2, 11.11 3.5, 12.11 2, 13.11 1.50, 14.11 7, 15.11 1, 16.11 3.75, 17.11 6, 18.11 3,
* scenario 12
1.12 4.25, 2.12 4.25, 3.12 4.25, 4.12 4.25, 5.12 3.00, 6.12 54, 7.12 23, 8.12 54, 9.12 23, 10.12 2, 11.12 3.5, 12.12 2, 13.12 1.25, 14.12 7, 15.12 1, 16.12 2.75, 17.12 6, 18.12 3,
* scenario 13
1.13 4.25, 2.13 4.25, 3.13 4.25, 4.13 4.25, 5.13 2.75, 6.13 54, 7.13 23, 8.13 54, 9.13 23, 10.13 2, 11.13 3.5, 12.13 2, 13.13 2.00, 14.13 7, 15.13 1, 16.13 3.25, 17.13 6, 18.13 3,
* scenario 14
1.14 4.25, 2.14 4.25, 3.14 4.25, 4.14 4.25, 5.14 1.25, 6.14 54, 7.14 23, 8.14 54, 9.14 23, 10.14 2, 11.14 3.5, 12.14 2, 13.14 1.25, 14.14 7, 15.14 1, 16.14 2.50, 17.14 6, 18.14 3,
* scenario 15
1.15 4.25, 2.15 4.25, 3.15 4.25, 4.15 4.25, 5.15 2.50, 6.15 54, 7.15 23, 8.15 54, 9.15 23, 10.15 2, 11.15 3.5, 12.15 2, 13.15 1.00, 14.15 7, 15.15 1, 16.15 2.50, 17.15 6, 18.15 3
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
file out /"cpm_MM_BD.txt"/; put out;
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

