$eolcom //

//Castecne vypnuti vypisu
option limrow = 0;
option limcol = 0;
option solprint = off;

set i          typ kotle na biomasu         / Bio1, Bio2 /,
    j          typ kotle na plyn            / Plyn /,
    t          uvazovane casy               / 1 * 49 /,
    s          uvazovane scenare            / 1 * 3 /,
    m          mesice                       / 1 * 12 /,
    r          hranice pro generatory       / d, h /,
    l          pocet simulaci               / 1*4 /;
alias(s,ss);

Parameter
    v(t,r) rozsah spotreby vody na osobu v case t /
       1.d  1.12,   1.h  1.12,   2.d  0.68,   2.h  0.68,
       3.d  0.68,   3.h  0.68,   4.d  0.48,   4.h  0.48,
       5.d  0.48,   5.h  0.48,   6.d  0.28,   6.h  0.28,
       7.d  0.28,   7.h  0.28,   8.d  0.12,   8.h  0.12,
       9.d  0.12,   9.h  0.12,  10.d  0.04,  10.h  0.04,
      11.d  0.04,  11.h  0.04,  12.d  0.08,  12.h  0.08,
      13.d  0.08,  13.h  0.08,  14.d  0.24,  14.h  0.24,
      15.d  0.24,  15.h  0.24,  16.d  0.52,  16.h  0.52,
      17.d  0.52,  17.h  0.52,  18.d  0.56,  18.h  0.56,
      19.d  0.56,  19.h  0.56,  20.d  1.064, 20.h  1.064,
      21.d  1.06,  21.h  1.06,  22.d  1.024, 22.h  1.024,
      23.d  1.02,  23.h  1.02,  24.d  1.08,  24.h  1.08,
      25.d  1.08,  25.h  1.08,  26.d  0.984, 26.h  0.984,
      27.d  0.98,  27.h  0.98,  28.d  1.28,  28.h  1.28,
      29.d  1.28,  29.h  1.28,  30.d  1.104, 30.h  1.104,
      31.d  1.1,   31.h  1.1,   32.d  0.96,  32.h  0.96,
      33.d  0.96,  33.h  0.96,  34.d  0.76,  34.h  0.76,
      35.d  0.76,  35.h  0.76,  36.d  0.8,   36.h  0.8,
      37.d  0.8,   37.h  0.8,   38.d  1,     38.h  1,
      39.d  1,     39.h  1,     40.d  1.008, 40.h  1.008,
      41.d  1.008, 41.h  1.008, 42.d  1.16,  42.h  1.16,
      43.d  1.16,  43.h  1.16,  44.d  1.344, 44.h  1.344,
      45.d  1.34,  45.h  1.34,  46.d  1.264, 46.h  1.264,
      47.d  1.26,  47.h  1.26,  48.d  1.12,  48.h  1.12,
      49.d  1.12,  49.h  1.12/;

    // Parametry pro vypocet poptavky po teple vode
Parameter    o          prumerny pocet obyvatel v domacnosti      / 2.3 /,
    d          pocet domacnosti                          / 5000 /,
    Td         teplotni rozdil ohrivane vody             / 35 /,
    Ve(t,s)    mnozstvi poptavane teple vody v case t scenari s;

// Generator poptavky po teple vode v case t scenari s
Ve(t,s) = uniform(v(t,'d'),v(t,'h'))*o*d;

Parameter
    min(m,r) rozsah minimalnich teplot v mesici m /
       1.d  -12.0,   1.h  -1.3,   2.d   -8.8,   2.h  -0.4,
       3.d   -7.0,   3.h   6.4,   4.d   -0.2,   4.h  13.9,
       5.d    4.6,   5.h  12.8,   6.d   11.5,   6.h  17.9,
       7.d    7.9,   7.h  19.1,   8.d   11.7,   8.h  20.3,
       9.d    4.8,   9.h  16.6,  10.d    1.1,  10.h  11.9,
      11.d   -0.3,  11.h   9.3,  12.d   -4.3,  12.h   1.6/,

    max(m,r) rozsah maximalnich teplot v mesici m /
       1.d   -4.0,   1.h   2.7,   2.d    1.1,   2.h  10.9,
       3.d   -2.9,   3.h  16.5,   4.d    8.8,   4.h  20.0,
       5.d   11.4,   5.h  23.2,   6.d   23.7,   6.h  28.7,
       7.d   21.4,   7.h  34.3,   8.d   21.6,   8.h  33.2,
       9.d   17.1,   9.h  25.8,  10.d   10.8,  10.h  21.0,
      11.d    2.6,  11.h  16.2,  12.d   -0.5,  12.h   7.4/,

    // Parametry pro ulozeni generovanych teplot
    min_tp     minimalni denni teplota,
    max_tp     maximalni denni teplota;

// generator minimalnich a maximalnich teplot v mesici m
min_tp = uniform(min('10','d'),min('10','h'));
max_tp = uniform(max('10','d'),max('10','h'));

Parameter
    k(t,s) prumerne nominalni teploty v case t scenari s/
       1.1  0.354674309,   1.2  0.086248725,   1.3  0.923192406,
       2.1  0.318634411,   2.2  0.091846069,   2.3  0.883791134,
       3.1  0.282594514,   3.2  0.097443412,   3.3  0.844389862,
       4.1  0.25424421,    4.2  0.102140038,   4.3  0.846222927,
       5.1  0.225893907,   5.2  0.106836663,   5.3  0.848055992,
       6.1  0.214925707,   6.2  0.106914519,   6.3  0.813868309,
       7.1  0.203957507,   7.2  0.106992374,   7.3  0.779680626,
       8.1  0.185810702,   8.2  0.098657273,   8.3  0.748160407,
       9.1  0.167663897,   9.2  0.090322172,   9.3  0.716640188,
      10.1  0.145636411,  10.2  0.087045836,  10.3  0.702258859,
      11.1  0.123608925,  11.2  0.0837695,    11.3  0.68787753,
      12.1  0.118744572,  12.2  0.075635441,  12.3  0.659389107,
      13.1  0.113880219,  13.2  0.067501383,  13.3  0.630900683,
      14.1  0.130192748,  14.2  0.075373312,  14.3  0.597032709,
      15.1  0.146505277,  15.2  0.083245241,  15.3  0.563164735,
      16.1  0.190840978,  16.2  0.125146605,  16.3  0.576333307,
      17.1  0.235176678,  17.2  0.167047969,  17.3  0.589501879,
      18.1  0.312723195,  18.2  0.21562668,   18.3  0.621222204,
      19.1  0.390269711,  19.2  0.26420539,   19.3  0.652942529,
      20.1  0.47794189,   20.2  0.305839061,  20.3  0.649772213,
      21.1  0.565614069,  21.2  0.347472732,  21.3  0.646601898,
      22.1  0.64002258,   22.2  0.413595203,  22.3  0.650245141,
      23.1  0.714431091,  23.2  0.479717675,  23.3  0.653888384,
      24.1  0.762820866,  24.2  0.52887104,   24.3  0.690372855,
      25.1  0.811210641,  25.2  0.578024405,  25.3  0.726857325,
      26.1  0.844439643,  26.2  0.62197175,   26.3  0.735073874,
      27.1  0.877668644,  27.2  0.665919095,  27.3  0.743290423,
      28.1  0.903662235,  28.2  0.709730662,  28.3  0.741237925,
      29.1  0.929655826,  29.2  0.753542229,  29.3  0.739185427,
      30.1  0.923823275,  30.2  0.797130018,  30.3  0.754200761,
      31.1  0.917990723,  31.2  0.840717808,  31.3  0.769216094,
      32.1  0.90562569,   32.2  0.855828273,  32.3  0.742536687,
      33.1  0.893260658,  33.2  0.870938737,  33.3  0.715857281,
      34.1  0.875587882,  34.2  0.843878548,  34.3  0.658098893,
      35.1  0.857915107,  35.2  0.816818359,  35.3  0.600340506,
      36.1  0.822153244,  36.2  0.797633413,  36.3  0.541040939,
      37.1  0.786391381,  37.2  0.778448466,  37.3  0.481741372,
      38.1  0.739045953,  38.2  0.779015084,  38.3  0.421615824,
      39.1  0.691700526,  39.2  0.779581702,  39.3  0.361490276,
      40.1  0.641371997,  40.2  0.754616093,  40.3  0.305766209,
      41.1  0.591043468,  41.2  0.729650483,  41.3  0.250042141,
      42.1  0.541011028,  42.2  0.743940745,  42.3  0.225461984,
      43.1  0.490978588,  43.2  0.758231006,  43.3  0.200881826,
      44.1  0.440488378,  44.2  0.772004342,  44.3  0.167503346,
      45.1  0.389998167,  45.2  0.785777679,  45.3  0.134124867,
      46.1  0.361089001,  46.2  0.803653719,  46.3  0.120841812,
      47.1  0.332179834,  47.2  0.821529758,  47.3  0.107558758,
      48.1  0.302628665,  48.2  0.832776704,  48.3  0.078117686,
      49.1  0.273077495,  49.2  0.844023649,  49.3  0.048676615/;



Parameter
    // Parametry pro vypocet poptavky po vytapeni
    A          horni asymptota                / 1933.88202706417 /,
    e          konstantní Eulerovo cislo      / 2.71828182845905 /,
    Kg         logisticky rustovy koeficient  / -0.735635517649199 /,
    T0         Sigmoiduv stredni bod          / 9.41541981244695 /,
    Tp(t,s)    venkovni teplota v case t scenari s,
    Pt(t,s)    celkova poptavka Pt po teple v case t scenari s,
    Vr(s)      celkova vyrobena energie beze ztrat ve scenari s;

// Vypocet denni teploty v case t scenari s
Tp(t,s) = round(k(t,s) * (max_tp - min_tp) +  min_tp,1);

// Vypocet celkove poptavky po energii v case t
// Prvni cast rovnice pocita poptavku po energii potrebnou k vytapeni.
// Druha cast rovnice pocita poptavku po energii potrebnou k ohrevu vody.
Pt(t,s) = A/(1+e**(-Kg*(Tp(t,s)-T0))) + (4.2*Ve(t,s)*Td)/3600;
Pt(t,s) = round(Pt(t,s),0);

Parameter
    // Parametry kapacit kotlu
    cap(i)  maximalni kapacita kotle typu i / Bio1 550, Bio2 750 /,

    // Parametry pro vypocet nakladu a prijmu
    bc         jednotkova cena za kWh vyrobenou biomasou / 0.65 /,
    gc         jednotkova cena za kWh vyrobenou plynem   / 1.40 /,
    gjp        zisk z jednoho GJ vyrobene energie        / 552 /,
    pst(s)     pravdepodobnost scenare                   / 1 0.8,
                                                           2 0.1,
                                                           3 0.1 /
    zmeny(i),
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
    yZ(t,s)      zasobník se ztratou f,
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

file out1 / "vysledky.txt" /;
put out1;

solve OptimTepla maximizing z using MIP;
display z.L, x.L, yP.L, yZ.L, omez.L, Pt, cap, bc, gc, delta.L;
display f, zmeny, pocetzmen.L, deltaxp.L, deltaxm.L;
poztrate(t,s) =  f(t,s)*yZ.L(t,s);
pohyb(t,s) = sum(i,x.L(i,t,s)*cap(i))+sum(j,yP.L(j,t,s))-Pt(t,s);
prubeh(i,t,s) = x.L(i,t,s)*(cap(i));
spinac(i,t) = sum(s, x.L(i,t,s))/3;
Vr(s) = sum(t,sum(i,x.L(i,t,s)*cap(i))+sum(j,yP.L(j,t,s)))

put "Vysledky" /;
put "========" / /;

If(OptimTepla.modelstat EQ 1,
put "Nalezeno optimalni reseni";);
If(OptimTepla.modelstat EQ 2,
put "Nalezeno lokalne optimalni reseni";);
If(OptimTepla.modelstat EQ 3,
put "Neomezena ucelova funkce na mnozine pripustnych reseni";);
If(OptimTepla.modelstat EQ 4,
put "Neexistuje pripustne reseni";);
If(OptimTepla.modelstat EQ 5,
put "Lokalne neexistuje pripustne reseni";);
If(OptimTepla.modelstat EQ 6,
put "Prubezne neexistuje pripustne reseni";);
If(OptimTepla.modelstat EQ 7,
put "Prubezne neoptimalni reseni";);
If(OptimTepla.modelstat EQ 8,
put "Celociselne reseni";);

put / /;
put "Naklady = ", tc.L:10:2 /;
put "Vynosy  = ", tr.L:10:2 /;
put "Zisk    = ", z.L:10:2 / /;

put "Minimalni denni teplota = ", min_tp:6:2 /;
put "Maximalni denni teplota = ",max_tp:6:2 / /;

put "t  ",  "    symbol", " | naklad", " | kapacita", " | Prepinani |      ";
loop(s, put s.TL:3," |      ";); put /;
put "   ",  "    pst(s)", " |      ", "  |          |", "         ";
put "  |",loop(s, put pst(s):9:2," |";); put /;
put "              |        |          |           |          |          |          |" /;
put "   ",  "    scn(s)", " |      ", "  |          |", "         ";
put "  |",loop(s, put snc.L(s):9," |";); put /;
put "   ",  "    scr(s)", " |      ", "  |          |", "         ";
put "  |",loop(s, put snr.L(s):9," |";); put /;
put "   ",  "     Pt(s)", " |      ", "  |          |", "         ";
put "  |",loop(s, put sum(t,Pt(t,s)):9," |";); put /;
put "   ",  "     Vr(s)", " |      ", "  |          |", "         ";
put "  |",loop(s, put Vr(s):9," |";); put /;
put "================================================================================"/;
loop(t,

put t.TL:3, "   Ve(t,s)", " |      ", "  |          |", "           |";
loop(s, put Ve(t,s):9:2," |";);  put / ;
put "      Tp(t,s)", " |      ", "  |          |", "           |";
loop(s, put Tp(t,s):9:2," |";);  put / ;
put "      Pt(t,s)", " |      ", "  |          |", "           |";
loop(s, put Pt(t,s):9:2," |";);  put / ;
put "              |        |          |           |     <=   |     <=   |     <=   |" /;
put  "   ", "    omez.L", " |      ", "  |          |", "           |";
loop(s, put omez.L(t,s):9:2," |";); put /;
put  "       f(t,s)", " |      ", "  |          |", "           |";
loop(s, put f(t-1,s):9:2," |";); put /;
        put  "   ", " Po ztrate", " |      ", "  |          |", "           |";
loop(s, put poztrate(t-1,s):9:2," |";); put /;
loop(i, put  "   ", "      ", i.TL:4, " |  ", bc:4:2,"  |  ", cap(i):6,"  |",spinac(i,t):8, "   |";
loop(s, put prubeh(i,t,s):9:2," |";); put /;);
loop(j, put  "   ", "      ",j.TL:4, " |  ", gc:4:2,"  |", " 9300.00", "  |           |";
loop(s, put yP.L(j,t,s):9:2," |";); put /;);
        put  "   ", "     Pohyb", " |      ", "  |          |", "           |";
loop(s, put pohyb(t,s):9:2," |";); put /;
        put  "   ", " Na sklade", " |      ", "  |          |", "           |";
loop(s, put yZ.L(t,s):9:2," |";); put /;
put "--------------------------------------------------------------------------------"/;
);
put /;






