$eolcom //

set i, j, t, s, m, r, l;
$gdxin %gdxincname%
$load i j t s m r l
$gdxin
alias(s,ss);

Parameter v(t,r) rozsah spotreby vody na osobu v case t;
$gdxin %gdxincname%
$load v
$gdxin

// Parametry pro vypocet poptavky po teple vode
Parameter o, d, Td, Ve(t,s);
$gdxin %gdxincname%
$load o d Td
$gdxin

// Generator poptavky po teple vode v case t scenari s
Ve(t,s) = uniform(v(t,'d'),v(t,'h'))*o*d;

Parameter
    min(m,r) rozsah minimalnich teplot v mesici m,
    max(m,r) rozsah maximalnich teplot v mesici m,
    min_tp     minimalni denni teplota,
    max_tp     maximalni denni teplota;

$gdxin %gdxincname%
$load min max
$gdxin

// generator minimalnich a maximalnich teplot v mesici m
min_tp = uniform(min('10','d'),min('10','h'));
max_tp = uniform(max('10','d'),max('10','h'));

// scenare
Parameter k(t,s) prumerne nominalni teploty v case t scenari s;
$gdxin %gdxincname%
$load k
$gdxin

Parameter A, e, Kg, T0, Tp(t,s), Pt(t,s), Vr(s);
$gdxin %gdxincname%
$load A e Kg T0
$gdxin

// Vypocet denni teploty v case t scenari s
Tp(t,s) = round(k(t,s) * (max_tp - min_tp) +  min_tp,1);

// Vypocet celkove poptavky po energii v case t
// Prvni cast rovnice pocita poptavku po energii potrebnou k vytapeni.
// Druha cast rovnice pocita poptavku po energii potrebnou k ohrevu vody.
Pt(t,s) = A/(1+e**(-Kg*(Tp(t,s)-T0))) + (4.2*Ve(t,s)*Td)/3600;
Pt(t,s) = round(Pt(t,s),0);

Parameter cap(i), bc, gc, gjp, pst(s);
$gdxin %gdxincname%
$load cap bc gc gjp pst
$gdxin

Parameter zmeny(i),
    f(t,s)     nahodne generovana ztrata tepelneho zasobniku,
    poztrate(t,s) energie na skladu po odecteni ztraty,
    pohyb(t,s) energie vzana ze zasobniku po poryti poptavky Pt case t scenari s,
    prubeh(i,t,s) mnozstvi vyrobene kotlem typu i v case t scenari s,
    spinac(i,t) ukazatel here-and-now rozhodnuti kotle typu i v case t;

zmeny(i) = uniform(2,5);
zmeny(i) = round(zmeny(i),0);
f(t,s) = uniform(0.85, 0.95);
f(t,s) = round(f(t,s),2);

variable
    // Promenne pro dilci vypocty nakladu
    bic(s)     naklady na vyrobu biomasou,
    plc(s)     naklady na vyrobu zemnim plynem,
    snc(s)     naklady v-teho scenare na vyrobu,

    // Promenne pro dilci vypoctu prijmu
    bir(s)     prijem z energie vyrobene biomasou,
    plr(s)     prijem z energie vyrobene zemnim plynem,
    snr(s)     prijem  za prodej energie v-teho scenare,

    // Promenne pro ulozeni celkovych nakladu a prijmu
    tc         celkove naklady na vyrobu,
    tr         celkove prijmy za vyrobenou energii,

    // promenna pro ulozeni ucelove funkce
    z          hodnota ucelove funkce;

Binary variables
    x(i,t,s) vyuziti kotle typu i v case t pro scenar s;

Positive variables
    yP(j,t,s) vyuziti kotle typu j v case t pro scenar s,
    yZ(t,s)      zasobn�k se ztratou f,
    deltaxp(i,t,s) citac plus zmen,
    deltaxm(i,t,s) citac minus zmen;

deltaxp.L(i,t,s) = 0;
deltaxm.L(i,t,s) = 0;

// horni mez pro vyuziti jednoho kotle
x.UP(i,t,s) = 1;
// maximalni kapacitu kotle typu j
yP.UP(j,t,s) = 9600;
// maximalni kapacita zasobniku yZ
yZ.UP(t,s) = 2000;
// omezeni zasobniku yZ v case t = 49
yZ.L('49',s) = 0;

Equations
    bio_cost(s)      naklady na vyrobu z biomasy ve scenari s,
    zpl_cost(s)      naklady na vyrobu ze zemniho plynu ve scenari s,
    scn_cost(s)      celkove naklady ve scenari s;

bio_cost(s)..
    bic(s) =E= pst(s) * (sum(t,(x('Bio1',t,s)*cap('Bio1')
                         + x('Bio2',t,s)*cap('Bio2')))) * bc;
zpl_cost(s)..
    plc(s) =E= pst(s) * sum(t,yP('Plyn',t,s)) * gc;

scn_cost(s)..  snc(s) =E=  bic(s) + plc(s);

Equations
    scn_revenue(s)   celkove primy za scenar s ;

scn_revenue(s)..  snr(s) =E=  pst(s) * sum(t,Pt(t,s))/277.78*gjp;


Equations
   total_cost        celkove naklady za vsechny scenare,
   total_revenue     celkove prijmy za vsechny scenare;

total_cost..         tc =E= sum(s, snc(s));
total_revenue..      tr =E= sum(s, snr(s));

Equations
   profit            ucelova funkce predmetem maximalizacet;

profit..             z =E= tr - tc;

Equations
    omez(t,s)        omezeni pro splneni poptavky v case t pro scenar s,
    omez1(t,s)       omezeni pro splneni poptavky v case 1 pro scenar s,
    HNWS(i,t,s)      neanticipativni omezeni v case t pro scenare s,
    delta(i,t,s)     pomocne omezeni,
    pocetzmen(i,s) omezeni poctu zmen;

$ontext
omez1(t,s)$(ord(t) EQ 1)..
    sum(i,x(i,t,s)*cap(i)) + sum(j,yP(j,t,s)) =E= Pt(t,s);

omez(t,s)$(ord(t) GT 1)..
    sum(i,cap(i)*x(i,t,s)) + sum(j,yP(j,t,s)) =E= Pt(t,s);
$offtext
//$ontext
omez(t,s)$(ord(t) GT 1)..
    f(t-1,s)*yZ(t-1,s) + sum(i,cap(i)*x(i,t,s)) + sum(j,yP(j,t,s)) - yZ(t,s)
    =E= Pt(t,s);

omez1(t,s)$(ord(t) EQ 1)..
    sum(i,x(i,t,s)*cap(i)) + sum(j,yP(j,t,s)) - yZ(t,s) =E= Pt(t,s);
//$offtext

HNWS(i,t,s)..
    sum(ss, pst(ss) * x(i,t,ss)) =E= x(i,t,s);

delta(i,t,s)$(ord(t) GT 1)..
    deltaxp(i,t,s)-deltaxm(i,t,s) =E= x(i,t,s)-x(i,t-1,s);

pocetzmen(i,s)..
    sum(t, deltaxp(i,t,s) + deltaxm(i,t,s) ) =L= zmeny(i);

model OptimTepla /all/;

solve OptimTepla maximizing z using MIP;
poztrate(t,s) =  f(t,s)*yZ.L(t,s);
pohyb(t,s) = sum(i,x.L(i,t,s)*cap(i))+sum(j,yP.L(j,t,s))-Pt(t,s);
prubeh(i,t,s) = x.L(i,t,s)*(cap(i));
spinac(i,t) = sum(s, x.L(i,t,s))/3;
Vr(s) = sum(t,sum(i,x.L(i,t,s)*cap(i))+sum(j,yP.L(j,t,s)))