$title The Farmer's Problem formulated for GAMS/LP (FARM,SEQ=199)

$onText
This model helps a farmer to decide how to allocate
his or her land. The yields are uncertain.


Birge, R, and Louveaux, F V, Introduction to Stochastic Programming.
Springer, 1997.

Keywords: linear programming, stochastic programming, agricultural cultivation,
          farming, cropping
$offText

Set
   crop         'crops'               
   cropr(crop)  'crops required for feeding cattle'
   cropx        'beets1 - up to 6000 ton, beets2 - in excess of 6000 ton';

$gdxin %gdxincname%
$load crop cropr cropx
$gdxin

Parameter
   yield(crop)       'tons per acre'
   plantcost(crop)   'dollars per acre'
   sellprice(cropx)  'dollars per ton'
   purchprice(cropr) 'dollars per ton'
   minreq(cropr)     'minimum requirements in ton';
   
$gdxin %gdxincname%
$load yield plantcost sellprice purchprice minreq
$gdxin

Scalar
   land      'available land'
   maxbeets1 'max allowed';
   
$gdxin %gdxincname%
$load land maxbeets1
$gdxin

*--------------------------------------------------------------------------
* First a non-stochastic version
*--------------------------------------------------------------------------
Variable
   x(crop)          'acres of land'
   w(cropx)         'crops sold'
   y(cropr)         'crops purchased'
   yld(crop)        'yield'
   profit_det       'objective variable';

Positive Variable x, w, y;

Equation
   profitdef  'objective function'
   landuse    'capacity'
   req(cropr) 'crop requirements for cattle feed'
   ylddef     'calc yields'
   beets      'total beet production';

profitdef..    profit_det =e= - sum(crop,  plantcost(crop)*x(crop))
                       -    sum(cropr, purchprice(cropr)*y(cropr))
                       +    sum(cropx, sellprice(cropx)*w(cropx));

landuse..      sum(crop, x(crop)) =l= land;

ylddef(crop).. yld(crop) =e= yield(crop)*x(crop);

req(cropr)..   yld(cropr) + y(cropr) - sum(sameas(cropx,cropr),w(cropx)) =g= minreq(cropr);

beets..        w('beets1') + w('beets2') =l= yld('sugarbeets');

w.up('beets1') = maxbeets1;

Model simple / profitdef, landuse, req, beets, ylddef /;

solve simple using lp maximizing profit_det;

*--------------------------------------------------------------------------
* Extensive form stochastic model
* This is a standard LP.
*--------------------------------------------------------------------------
*Following eplaced by python optimizer
Set s 'scenarios';

$gdxin %gdxincname%
$load s
$gdxin

Variable
   ws(cropx, s) 'crops sold under scenario s'
   ys(cropr, s) 'crops purchased under scenario s'
   profit_stoch     'objective variable';

Positive Variable ws, ys;

Parameter p(s) 'probabilities'
          e(s) 'earnings';
          
$gdxin %gdxincname%
$load p e
$gdxin

abort$(abs(sum(s,p(s)) - 1.0) > 0.001) "probabilities don't add up";

Parameter syield(crop,s);
syield(crop,s) = e(s)*yield(crop);

Equation
   sprofitdef    'objective function extensive form stochastic model'
   sreq(cropr,s)
   sbeets(s);

sprofitdef..    profit_stoch =e= - sum(crop, plantcost(crop)*x(crop))
                           + sum(s, p(s)*(- sum(cropr, purchprice(cropr)*ys(cropr,s))
                                          + sum(cropx, sellprice(cropx)*ws(cropx,s))));

sreq(cropr,s)..    syield(cropr,s)*x(cropr) + ys(cropr,s)
                -  sum(sameas(cropx,cropr),ws(cropx,s))
               =g= minreq(cropr);

sbeets(s)..    ws('beets1',s) + ws('beets2',s) =l= syield('sugarbeets',s)*x('sugarbeets');

ws.up('beets1',s) = maxbeets1;

Model extform / sprofitdef, landuse, sreq, sbeets /;

solve extform using lp maximizing profit_stoch;

display  x.L, w.L, y.L, yld.L, profit_stoch.L;