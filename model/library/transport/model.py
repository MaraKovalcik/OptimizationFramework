# set gams model
def get_gams_model():
    return 'gams\\library\\transport\\transport.gms'


# list of values to return from optimized gams model
def get_return_values():
    return_values = {'z': 'var'}
    return return_values


# sets, parameters and variables will be accesible in the gams model
def set_model(db, data, scenarios_data=None):
    ##
    ## START DEFINING MODEL DATA
    ## These sets, parameters and variables will be accesible in the gams model
    ##

    # canning plants
    i = db.add_set("i", 1, "canning plants ")
    for ii in data.get("i"):
        i.add_record(ii)

    # markets
    j = db.add_set("j", 1, "markets ")
    for jj in data.get("j"):
        j.add_record(jj)

    # capacity of plant i in cases
    a = db.add_parameter_dc("a", [i], "capacity of plant i in cases")
    for key, val in zip(data.get("i"), data.get("a")):
        a.add_record(key).value = val

    # demand at market j in cases
    b = db.add_parameter_dc("b", [j], "demand at market j in cases")
    for key, val in zip(data.get("j"), data.get("b")):
        b.add_record(key).value = val

    # Table distance in thousands of miles (parameter with dimension 2, depends on canning plants (i) and markets (j))
    d = db.add_parameter_dc("d", [i, j], "Distance in thousands of miles")
    for key, val in data.get("d").items():
        d.add_record(key).value = val

    # Freight in dollars per case per thousand miles
    f = db.add_parameter("f", 0, "freight in dollars per case per thousand miles")
    f.add_record().value = scenarios_data.get("f")

    ##
    ## END DEFINING MODEL DATA
    ##

    return db