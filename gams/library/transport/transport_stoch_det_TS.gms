$ontext

   Transportation problem with stochastic demands.

   Erwin Kalvelagen, January 2003
         Source: http://www.amsterdamoptimization.com/pdf/twostage.pdf
         Code: http://www.amsterdamoptimization.com/models/twostage/stochdeteq.gms

$offtext

sets
  i 'factories' /f1*f3/
  j 'distribution centers' /d1*d5/
  s 'individual scenarios' /lo,mid,hi/
;

parameter capacity(i) /f1 500, f2 450, f3 650/;

table demand(j,s) 'possible outcomes for demand'
      lo  mid   hi
  d1 150  160  170
  d2 100  120  135
  d3 250  270  300
  d4 300  325  350
  d5 600  700  800
;

table prob(j,s) 'probabilities for table demand'
      lo  mid   hi
  d1 .25  .50  .25
  d2 .25  .50  .25
  d3 .25  .50  .25
  d4 .30  .40  .30
  d5 .30  .40  .30
;

loop(j, abort$(abs(sum(s,prob(j,s))-1)>0.001) "probabilities don't add up");


*
* set up joint probabilities
* total scenarios =  3**5 = 243
*
set js 'scenarios for joint probabilities' /js1*js243/;
parameter jdemand(j,js) 'joint distribution: outcomes';
parameter jprob(js)   'joint distribution: probabilities';

alias (s,s1,s2,s3,s4,s5);
set current(js);
current('js1') = yes;
loop((s1,s2,s3,s4,s5),
   jdemand('d1',current) = demand('d1',s1);
   jdemand('d2',current) = demand('d2',s2);
   jdemand('d3',current) = demand('d3',s3);
   jdemand('d4',current) = demand('d4',s4);
   jdemand('d5',current) = demand('d5',s5);
   jprob(current) = prob('d1',s1)*prob('d2',s2)*prob('d3',s3)*prob('d4',s4)*prob('d5',s5);
   current(js) = current(js-1);
);
**display jdemand,jprob;

scalar sumprob;
sumprob = sum(js, jprob(js));
**display sumprob;
abort$(abs(sumprob-1)>0.00001) "joint probabilities don't add up";

table transcost(i,j) 'unit transportation cost'
       d1    d2    d3    d4    d5
  f1   2.49  5.21  3.76  4.85  2.07
  f2   1.46  2.54  1.83  1.86  4.76
  f3   3.26  3.08  2.60  3.76  4.45
;

scalar prodcost  'unit production cost' /14/;
scalar price     'sales price' /24/;
scalar wastecost 'cost of removal of overstocked products' /4/;


*-----------------------------------------------------------------------
* first we formulate a non-stochastic version of the model
* we just use 'mid' values for the demand.
*-----------------------------------------------------------------------

variables
   ship(i,j)   'shipments'
   product(i)  'production'
   sales(j)    'sales (actually sold)'
   waste(j)    'overstocked products'
   profit
;
positive variables ship,product,sales,waste;

equations
   obj
   production(i)
   selling(j)
;


obj.. profit =e= sum(j, price*sales(j)) - sum((i,j), transcost(i,j)*ship(i,j))
                 - sum(j, wastecost*waste(j)) - sum(i,prodcost*product(i));


production(i).. product(i) =e= sum(j, ship(i,j));
product.up(i) = capacity(i);

selling(j).. sum(i, ship(i,j)) =e= sales(j)+waste(j);
sales.up(j) = demand(j,'mid');

model nonstoch /obj,production,selling/;
solve nonstoch maximizing profit using lp;

display ship.l,product.l,sales.l,waste.l;
parameter shipnonstoch(i,j);
shipnonstoch(i,j) = ship.l(i,j);

*-----------------------------------------------------------------------
* now we formulate a stochastic version of the model
* We form here the deterministic equivalent
*-----------------------------------------------------------------------

variables
   salesw(j,js) 'stochastic version of sales'
   wastew(j,js)  'stochastic version of waste'
   received(j)  'amount of product received in distribution center'
;
positive variable salesw,wastew;

equations
   objw
   sellingw(j,js)
   receive(j)
;

objw.. profit =e= sum((j,js),price*jprob(js)*salesw(j,js))
                 - sum((i,j), transcost(i,j)*ship(i,j))
                 - sum((j,js), wastecost*jprob(js)*wastew(j,js))
                 - sum(i,prodcost*product(i));

receive(j)..     received(j) =e= sum(i, ship(i,j));
sellingw(j,js).. received(j) =e= salesw(j,js)+wastew(j,js);
salesw.up(j,js) = jdemand(j,js);

model stoch /objw,production,receive,sellingw/;
solve stoch maximizing profit using lp;

**display ship.l,product.l,salesw.l,wastew.l;

*-----------------------------------------------------------------------
* Compare with nonstochastic solution
*-----------------------------------------------------------------------

ship.fx(i,j) = shipnonstoch(i,j);
solve stoch maximizing profit using lp;
