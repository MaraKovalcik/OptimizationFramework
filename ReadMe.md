### Pre-úvod
Tento návod je napsán v jazyce Markdown. Doporučuju stáhnout PyCharm komunitní verzi (či jiný 
program umožňující zobrazení markdown souborů) pro správné zobrazení tohoto souboru
a zároveň efektivní práci s Python skripty. Lze je však číst v jakémkoliv textovém editoru,
soubor pak však může ztratit vlastnosti mardown zobrazení.

### Úvod
V tomto dokumentu bude popsán způsob zprovoznění aplikačního rozhraní mezi programem Gams
verze 30.1.0 a Python 3.7.7. Dále bude otestována funkčnost integrace a nakonec popsán
princip fungování a možnosti spouštění upraveného frameworku s připravenou úlohou, která obsahuje 
dvoustupňovou stochastickou verzi 'farmářova problému' v kombinaci s řízením a importem/exportem
dat s pomocí programovacího jazyka python.

Vhodné, né však nutné, je použití komunitní verze integrovaného vývojové prostředí 
PyCharm, které je možné stáhnout z https://www.jetbrains.com/pycharm/download/#section=windows.
Výhodné je to pro efektivní editaci Pythonovských skriptů a zobrazení tohoto markdown souboru.

Gams i Python můžete mít nainstalovaný v libovolných složkách, a proto jejich názvy v této
dokumentaci budu nahrazovat za GAMS_DEFAULFT_DIR a PYTHON_DEFAULT_DIR. Postup instalace a
zprovoznění je velmi podobný pro platformy Windows i MAC OSX. Dle oficiální
dokumentace je vhodné, né však nezbytné, aby na počítači byla nainstalovaná pouze jedna
verze programu Gams. Při více přítomných instalacích, může docházet k referenčím chybám a 
bylo by možná nutné oddělit také prostředí Pythonu. Na svém počítači však nainstalované dvě verze
Gamsu a to 30.1.0 a 32.0.0. Na žádný velký problém jsem nenarazil, avšak v případě nějakých problémů
doporučuju následovat kroky oficiální dokumentace na https://www.gams.com/latest/docs/API_PY_TUTORIAL.html#PY_GETTING_STARTED

##### Instalace GAMS 30.1.0
- https://www.gams.com/download/
- použita verze Gams win64 30.1.0
- instalační složka -> GAMS_DEFAULT_DIR (př. C:\gams)

#### Instalace PYTHONU 3.7.7
- https://www.python.org/downloads/release/python-377/
- instalační složka -> PYTHON_DEFAULT_DIR (př. C:\python37)
- zjištění správnosti instalace a instalované verze python -> otevřete příkazový řádek 
(stiknutí kláves Win+R -> napiště cmd -> enter), napiště 
```python -V ``` a pokud je python
instalovaný správně a je správě v systémové proměnné PATH, zobrazí se vám verze pythonu. 
(-V -> velké písmeno V)

### Konfigurace aplikačního rozhraní
##### 1) Přidání složky aplikačních rozhraní do proměnných prostředí systému

- Na OS Windows:

```
    set PYTHONPATH=GAMS_DEFAULT_DIR\apifiles\Python\api_37
    set PYTHONPATH=C:\path\to\gams\apifiles\Python\gams;%PYTHONPATH%
```    
- Na OS Windows:
    
```    
    export PYTHONPATH=GAMS_DEFAULT_DIR/apifiles/Python/api_37
    export PYTHONPATH=PYTHON_DEFAULT_DIR/apifiles/Python/gams:$PYTHONPATH
```
##### 2) Instalace modulů aplikačního rozhraní Python-Gams

Otevřete příkazový řádek (stiknutí kláves Win+R -> napiště cmd -> enter) a přejdete do 
adresáře, kde je gams nainstalován a do složky souborů potřebných pro instalaci modulů
aplikačního rozhraní. Uvedené příkazy jsou demonstrovány pro OS Windows.
```    
# přechod do adresáře s nainstalovýnm Gamsem
cd GAMS_DEFAULT_DIR\apifiles\Python\api_37
# instalace modulu pro aplikační rohraní
python setup.py install
```    
##### 3) Otestování správnosti konfigurace aplikačního rozhraní Python-Gams  

Pokud jste vynechali krok 2 nebo zavřeli terminál, otevřete příkazový řádek 
(stiknutí kláves Win+R -> napiště cmd -> enter) a přejdete do adresáře, kde je gams 
nainstalován. Správnost konfigurace otestujeme na ukázkovém skriptu transport1.py, který je součástí gams instalace.
```    
# přechod do adresáře s nainstalovýnm Gamsem
cd GAMS_DEFAULT_DIR\apifiles\Python
# spuštění testovacího skriptu transport1.py
python transport1.py
```    
V případě, že vše proběhlo v pořádku, měl by se na obrazovce zobrazit výstup propojení 
transport1.py a transport.gms a mohl by vypadat přibližně takto:
```
Ran with Default:
x(seattle,new-york): level=50.0 marginal=0.0
x(seattle,chicago): level=300.0 marginal=0.0
x(seattle,topeka): level=0.0 marginal=0.036000000000000004
x(san-diego,new-york): level=275.0 marginal=0.0
x(san-diego,chicago): level=0.0 marginal=0.009000000000000008
x(san-diego,topeka): level=275.0 marginal=0.0
... + další informace
```   
### Python -> Gams -> Python -> Výstup
Jak na použití optimalizátoru?
Pokud si přiložené soubory otevřete ve vývojovém prostředí (př. Pycharm), můžete vidět 
následující adresářovou strukturu. Hodnota NAME zde zastupuje název modulu, těchto modulů zde může být více.


```
│_   ReadMe.md
│_   optimizer.py
|_   requirements.txt   
│
└───data
│   └───NAME
│       │_   data.py
│   
└───gams
│   └───NAME
│       │_   gams.gms
│   
└───model
|   └───NAME
|       │_   model.py
|  
└───settings
    └───optimizer_settings.py 
```
V souboru ReadMe.md je 
uložen tento návod. Soubor optimizer.py je řídím programem optimalizace a obsahuje třídu, která načítá 
vstupní data ze souboru data.py, definici množin, parametrů a proměnných ze souboru model.py a 
následně s nimi pracuje v souboru gams.gms. V souboru optimizer_settings.gms je definováno,
se kterým modelem NAME má optimizer pracovat. 
Výstupy optimalizace jsou zpracován opět souborem optimizer.py.

####Virtuální prostředí
Virutální prostředí je možné vytvořit následujícím příkazem. 
Tento krok můžete vynechat pokud nemáte na počítači více pythonovských aplikacích, které vyžudají velké množství balíků. Můžete tak nutné balíky instalovat do globálního adresáře.
```
# vytvoření virtuální prostředí
# env je název virtuálního prostředí
python -m venv env
# aktivace virtuální prostředí
.\env\Scripts\activate
```

Pokud se rozhodnete používat virtuální prostředí, bude nutné ho aktivovat při každém novém otevření příkazové řádky!

####Instalace nutných balíků
Soubor requirements.txt obsahuje soupis balíků nutných k doinstalování do prostředí pythonu.
Lze je instalovat následujícím příkazem, doporučeno je použít virtuální python prostředí, není to však nutné.
```
# instalace nutných balíků
pip install -r requirements.txt
```

####Možnosti spuštění programu:
```
# vypsání nápovědy k programu
python optimizer.py -h
# dostanete následující popis možných parametrů

usage: optimizer.py [-h] [-r] [-s] [-m] [-o OUTPUT] [-x EXCEL]

Integrated Python->Gams optimizer for model:

optional arguments:
  -h, --help            show this help message and exit
  -r, --results         not to print results
  -s, --scenarios       print scenarios data
  -m, --model_print     print all parameters, sets and scalars
  -o OUTPUT, --output OUTPUT
                        direct the output to a name of your choice (without an
                        extension)
  -x EXCEL, --excel EXCEL
                        generate output file as an excel document```
```
Spustění programu s přepínačem -h vypíše nápovědu výše. Pokud je použit přepínač -r nebudou se
počítat a vypisovat získané hodnoty. Pokud je zapnutý přepinač -s budou se 
vypisovat jednotlivé hodnoty, které se mění s jednotlivými scénáři a přepínačem -m se budou
vypisovat také hodnoty, které se scénařemi nemění. Při použití přepínače o a definování jména
výstupního souboru se výstup uloží do tohoto souboru s příponou txt. Pokud je použit přepínač -x, 
bude vygenerován také soubor typu MS Excel.

Místo zkratek přepínačů lze používat také jejich delší název, jak je vidět v nápovědě výše. Přepínače
se řídí standardní politikou, kdy je je možné kombinovat. Například následující dva příkazy
mají identický smysl.

```
# spočítání model, vypíše optimální hodnotu, vypíše scénáře i hodnoty modelu
python optimizer.py -s -m
python optimizer.py -sm
```

#### Ukázka spuštění optmilizace a zobrazení výsledků:
 - Tato ukázka používá dvoustupňový stochastický model farmářova problému.
 - Obsah souboru optimizer_settings.py definuje vstupní data a definici modelu a vypadá následovně:
 
 ```
'''
## Specify data input and model input file
## - uncomment model, that you want to use
## - only one model can be used at time!
'''

'''
## Model farm
'''
from data.farm.data import *
from model.farm.model import *

'''
## Model transport
'''
#from data.transport.data import *
#from model.transport.model import *


'''
## Model CPM
'''
''' wait-and-see model'''
#from data.cpm.data_ws import *
''' expected values model'''
#from data.cpm.data_ev import *
''' min-max model'''
#from data.cpm.data_mm import *
'''individual scenario model'''
#fr om data.cpm.data_is import *
''' two-staged model'''
#from data.cpm.data_ts import *
''' two-staged with evpi and vss'''
#from data.cpm.data_ts_evpi_eev_vss import *
'''
# Model file here is the same, you need to select which gams model
# you want to use in model.com.model in get_gams_model() and get_return_values()
'''
#from model.cpm.model import *
```
 Pokud chcete použít model transport, odkomentujte importy a zakomentujte importy modelu farm.
 V souboru model.py je také definován vstupní gms soubor.
 
#####Spuštění optimizátoru pro takto definovaný model. 
Po úspěšném dokončení běhu programu lze vidět výstup na obrazovce, stejný výstup je také 
obsahem souboru out1.txt a upravený výstup je obsahem soubrou out2.xlsx.
 
```
PROJECT DIRECTORY> python optimizer.py -sm -o out1 -x out2
[INFO] Working with model:  gams\farm\farm02.gms
[INFO] TXT Output will be stored to out1.txt
[INFO] EXCEL Output will be stored to out2.txt
Model:
        crop: ['wheat', 'corn', 'sugarbeets']
        cropr: ['wheat', 'corn']
        cropx: ['wheat', 'corn', 'beets1', 'beets2']
        yield: [2.5, 3, 20]
        plantcost: [150, 230, 260]
        sellprice: [170, 150, 36, 10]
        purchprice: [238, 210]
        minreq: [200, 240]
        land: 500
        maxbeets1: 6000
        scenarios: ['above', 'avg', 'below']

1. scenarios
Data:
        index: 1
        probabilities: [0.3333333333333333, 0.3333333333333333, 0.3333333333333333]
        earnings: [0.8, 1, 1.2]
Result:
        profit_det: 118600.0
        profit_stoch: 108390.0

2. scenarios
Data:
        index: 2
        probabilities: [0.5, 0.3, 0.2]
        earnings: [0.9, 1, 1.5]
Result:
        profit_det: 118600.0
        profit_stoch: 117672.2222222222
```

Tento soubor neslouží k vysvětlení fungování celého programu, ale pouze k vysvětlení součástí
potřebných k jeho spuštění, otestování funkčnosti a demonstraci dosažených výsledků. Pro bližší pochopení fungování programu je
třeba zjistit, jak fungují soubory *.py a *.gms. Toto bude popsáno v dokumentaci doplomové práce.

Autor: Marek Kovalčík, mara.kovalcik@gmail.com, 28. 4. 2021