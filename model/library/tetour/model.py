# set gams model
def get_gams_model():
    return 'gams\\library\\tetour\\model_optimized.gms'


# list of values to return from optimized gams model
def get_return_values():
    # return types
    ## - var = variable
    ## - par = parameter
    ## - sca = scalar
    return_values = {'z': 'var', 'tc': 'var', 'tr': 'var'}
    return return_values


# sets, parameters and variables will be accesible in the gams model
def set_model(db, data, scenarios_data):
    ##
    ## START DEFINING MODEL DATA
    ## These sets, parameters and variables will be accesible in the gams model
    ##

    # sets - i, j, t, s, m, r l

    i = db.add_set("i", 1, "typ kotle na biomasu")
    for item in data.get("i"):
        i.add_record(str(item))

    j = db.add_set("j", 1, "typ kotle na plyn")
    for item in data.get("j"):
        j.add_record(str(item))

    t = db.add_set("t", 1, "uvazovane casy")
    for item in range(1, data.get("t") + 1):
        t.add_record(str(item))

    s = db.add_set("s", 1, "uvazovane scenare")
    for item in range(1, data.get("s") + 1):
        s.add_record(str(item))

    m = db.add_set("m", 1, "mesice")
    for item in range(1, data.get("m") + 1):
        m.add_record(str(item))

    r = db.add_set("r", 1, "hranice pro generatory")
    for item in data.get("r"):
        r.add_record(str(item))

    l = db.add_set("l", 1, "pocet simulaci")
    for item in range(1, data.get("l") + 1):
        l.add_record(str(item))

    o = db.add_parameter("o", 0, "prumerny pocet obyvatel v domacnosti")
    o.add_record().value = data.get("o")

    d = db.add_parameter("d", 0, "pocet domacnosti")
    d.add_record().value = data.get("d")

    Td = db.add_parameter("Td", 0, "teplotni rozdil ohrivane vody")
    Td.add_record().value = data.get("Td")

    A = db.add_parameter("A", 0, "horni asymptota")
    A.add_record().value = data.get("A")

    e = db.add_parameter("e", 0, "konstantní Eulerovo cislo")
    e.add_record().value = data.get("e")

    Kg = db.add_parameter("Kg", 0, "logisticky rustovy koeficient")
    Kg.add_record().value = data.get("Kg")

    T0 = db.add_parameter("T0", 0, "Sigmoiduv stredni bod")
    T0.add_record().value = data.get("T0")

    bc = db.add_parameter("bc", 0, "jednotkova cena za kWh vyrobenou biomasou")
    bc.add_record().value = data.get("bc")

    gc = db.add_parameter("gc", 0, "jednotkova cena za kWh vyrobenou plynem")
    gc.add_record().value = data.get("gc")

    gjp = db.add_parameter("gjp", 0, "zisk z jednoho GJ vyrobene energie")
    gjp.add_record().value = data.get("gjp")

    cap = db.add_parameter_dc("cap", [i], "maximalni kapacita kotle typu i")
    for i_item, item in zip(data.get("i"), data.get("cap")):
        cap.add_record(str(i_item)).value = item

    s_indexes = range(1, data.get("s"))
    pst = db.add_parameter_dc("pst", [s], "pravdepodobnost scenare")
    for i_item, item in zip(s_indexes, data.get("pst")):
        pst.add_record(str(i_item)).value = float(item)

    v = db.add_parameter_dc("v", [t, r], "rozsah spotreby vody na osobu v case t")
    v_d = data.get('v_d')
    v_h = data.get('v_h')
    for key, val in v_d.items():
        index = (key, 'd')
        v.add_record(index).value = float(val)
    for key, val in v_h.items():
        index = (key, 'h')
        v.add_record(index).value = float(val)

    min = db.add_parameter_dc("min", [m, r], "rozsah minimalnich teplot v mesici m")
    min_d = data.get('min_d')
    min_h = data.get('min_h')
    for key, val in min_d.items():
        index = (key, 'd')
        min.add_record(index).value = float(val)
    for key, val in min_h.items():
        index = (key, 'h')
        min.add_record(index).value = float(val)

    max = db.add_parameter_dc("max", [m, r], "rozsah maximalnich teplot v mesici m")
    max_d = data.get('max_d')
    max_h = data.get('max_h')
    for key, val in max_d.items():
        index = (key, 'd')
        max.add_record(index).value = float(val)
    for key, val in max_h.items():
        index = (key, 'h')
        max.add_record(index).value = float(val)

    # scenarios
    k = db.add_parameter_dc("k", [t, s], "prumerne nominalni teploty v case t scenari s")
    for scenario_data in scenarios_data:
        xi_s = scenario_data.get("xi_s")
        for key, val in xi_s.items():
            # edit index by data i2 parameter
            index = (key[0], key[1])
            k.add_record(index).value = float(val)

    ##
    ## END DEFINING MODEL DATA
    ##

    return db