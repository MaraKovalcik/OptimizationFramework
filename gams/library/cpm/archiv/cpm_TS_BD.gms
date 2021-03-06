* MODEL TS for big data
* Setting of dimension for table
set i / 1 * 18 /,
    j / 1 * 13 /;
* Distinction of edges where recourse variables are used i2
set i1(i) / 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 18 /;
set i2(i) / 5, 13, 16 /;
scalar resc / 0 /;
* Indexes of scenarios
set s / 1 * 15 /;
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
* Defining recourse variables valus for edges in each scenario (plus)
parameter qp(i2, s) / 5.1 1.25, 13.1 3.78, 16.1 2.78,
                      5.2 2.30, 13.2 2.85, 16.2 1.85,
                      5.3 0.50, 13.3 3.10, 16.3 3.25,
                      5.4 0.50, 13.4 2.90, 16.4 4.50,
                      5.5 1.75, 13.5 3.55, 16.5 3.65,
                      5.6 1.20, 13.6 2.50, 16.6 6.15,
                      5.7 1.25, 13.7 4.00, 16.7 3.25,
                      5.8 2.50, 13.8 3.75, 16.8 2.95,
                      5.9 1.80, 13.9 3.25, 16.9 2.45,
                      5.10 2.00, 13.10 2.85, 16.10 2.75,
                      5.11 2.15, 13.11 3.35, 16.11 3.35,
                      5.12 2.05, 13.12 4.00, 16.12 3.50,
                      5.13 1.85, 13.13 3.15, 16.13 4.00,
                      5.14 0.85, 13.14 3.00, 16.14 3.25,
                      5.15 1.90, 13.15 3.45, 16.15 3.00

/;
* Defining recourse variables valus for edges in each scenario (minus)
parameter qm(i2, s) / 5.1 6.45, 13.1 8.20, 16.1 7.20,
                      5.2 7.15, 13.2 7.45, 16.2 6.45,
                      5.3 6.75, 13.3 7.40, 16.3 7.45,
                      5.4 7.40, 13.4 7.00, 16.4 7.65,
                      5.5 5.45, 13.5 9.00, 16.5 7.00,
                      5.6 6.50, 13.6 8.20, 16.6 8.35,
                      5.7 7.55, 13.7 7.00, 16.7 6.40,
                      5.8 5.80, 13.8 7.85, 16.8 5.35,
                      5.9 6.15, 13.9 8.75, 16.9 9.15,
                      5.10 6.45, 13.10 7.95, 16.10 7.35,
                      5.11 8.00, 13.11 8.00, 16.11 7.15,
                      5.12 6.70, 13.12 8.65, 16.12 8.45,
                      5.13 7.65, 13.13 6.75, 16.13 10.45,
                      5.14 6.45, 13.14 7.15, 16.14 8.65,
                      5.15 7.35, 13.15 8.50, 16.15 7.25
/;
* Constraint row
parameter bb(i, s);
* scenarios probability
parameter p(s) / 1 0.034, 2 0.032, 3 0.15, 4 0.034, 5 0.09, 6 0.0305, 7 0.075, 8 0.095, 9 0.09, 10 0.2, 11 0.033, 12 0.0305, 13 0.035, 14 0.031, 15 0.04 /;
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
*
* OUTPUT FILE
*
* Defining output file  and write legend
file out /"cpm_TS_BD.txt"/; put out;
put "=== Legend ===" /;
put "i = scenario index" /;
put "stat = optimization status, 1 = optimal, else http://www.gamsworld.org/performance/status_codes.htm" /;
put "p = scenario probability" /;
put "Z = critical path length" /;
put "bj = constraints, depends on scenario( 1..18 )" /;
put "xj = start time of activity j, j is from ( 1..13 ), a13 = END NODE" /;
put "ypk, ymk = recourse variables for constraint (edge) k, k is from {5, 13, 16}" /;
put "resc = recoursion for a scenario" /;
* Write scearios informations
put / "=== Scenarios ===" /;
put "i ", "  p     "; loop(i, put " b",i.TL:5:2 ); put /;
* Loop over each scenario

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
put / "=== Result ===" /;
put " stat ", "    Z      "; loop(j, put "x",j.TL:6:2); put "resc" /;
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
* Display results
display Z.L, x.L, bb, yp.L, yp.UP, ym.L, ym.UP;
* Write collected data to output file
put CPM.modelstat:3:0, "   ", Z.L:7:2; loop(j,put x.L(j):7:2;); put resc:8:2 /;
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

