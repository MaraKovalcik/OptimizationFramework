* MODEL TS for small data
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
* Constraint row, scenarios probability
parameter bb(i, s), parameter p(s) / 1 0.6, 2 0.4 /;
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
objective_func.. Z =E= sum(j, c(j)*x(j)) + sum(s, p(s)* sum(i2, qp(i2,s) * yp(i2,s) + qm(i2,s) * ym(i2,s)));
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
file out /"cpm_TS_SD.txt"/; put out;
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
loop(s, bb(i, s) = Xi(i,s);
         put s.TL:2, p(s):5:2, " ";
         loop(i, put bb(i, s):6:2, " "; );
         put /;
);
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

