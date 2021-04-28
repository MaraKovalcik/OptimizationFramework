# set gams model
def get_gams_model():
    return 'gams\\library\\farm\\farm.gms'


# list of values to return from optimized gams model
def get_return_values():
    return_values = {'profit_det': 'var', 'profit_stoch': 'var'}
    return return_values


# sets, parameters and variables will be accesible in the gams model
def set_model(db, data, scenarios_data):
    ##
    ## START DEFINING MODEL DATA
    ## These sets, parameters and variables will be accesible in the gams model
    ##

    # crops
    crop = db.add_set("crop", 1, "used crops")
    for c in data.get("crop"):
        crop.add_record(c)

    # crops required for feeding cattle
    cropr = db.add_set_dc("cropr", [crop], "crops required for feeding cattle")
    for c in data.get("cropr"):
        cropr.add_record(c)

    # beets1 - up to 6000 ton, beets2 - in excess of 6000 ton
    cropx = db.add_set("cropx", 1, "cropx explanatory text")
    for c in data.get("cropx"):
        cropx.add_record(c)

    # tons per acre for each crop
    d_yield = db.add_parameter_dc("yield", [crop], "tons per acre for each crop")
    for crop, value in zip(data.get("crop"), data.get("yield")):
        d_yield.add_record(crop).value = value

    # dollars per acre for each crop
    plantcost = db.add_parameter_dc("plantcost", [crop], "dollars per acre for each crop")
    for crop, value in zip(data.get("crop"), data.get("plantcost")):
        plantcost.add_record(crop).value = value

    # dollars per ton for each cropx
    sellprice = db.add_parameter_dc("sellprice", [cropx], "dollars per ton for each cropx")
    for cropx, value in zip(data.get("cropx"), data.get("sellprice")):
        sellprice.add_record(cropx).value = value

    # dollars per ton for each cropr
    purchprice = db.add_parameter_dc("purchprice", [cropx], "dollars per ton for each cropr")
    for cropr, value in zip(data.get("cropr"), data.get("purchprice")):
        purchprice.add_record(cropr).value = value

    # minimum requirements in ton for each cropr
    minreq = db.add_parameter_dc("minreq", [cropx], "minimum requirements in ton for each cropr")
    for cropr, value in zip(data.get("cropr"), data.get("minreq")):
        minreq.add_record(cropr).value = value

    # available land
    land = db.add_parameter("land", 0, "available land")
    land.add_record().value = data.get("land")

    # maximum of beets produce
    maxbeets1 = db.add_parameter("maxbeets1", 0, "maxbeets1 allowed")
    maxbeets1.add_record().value = data.get("maxbeets1")

    # model scenarios
    s = db.add_set("s", 1, "scenarios")
    for scenario in data.get("scenarios"):
        s.add_record(scenario)

    # probabilities coeficients for each scenario
    probabilities = db.add_parameter_dc("p", [s], "probabilities of each scenario")
    for s, value in zip(data.get("scenarios"), scenarios_data.get("probabilities")):
        probabilities.add_record(s).value = float(value)

    # earnings of each scenario
    earnings = db.add_parameter_dc("e", [s], "earnings of each scenario")
    for s, value in zip(data.get("scenarios"), scenarios_data.get("earnings")):
        earnings.add_record(s).value = float(value)

    ##
    ## END DEFINING MODEL DATA
    ##

    return db