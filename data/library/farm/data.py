# deterministic data
def get_data():
    data = dict()

    # crops
    data['crop'] = ['wheat', 'corn', 'sugarbeets']
    # crops required for feeding cattle
    data['cropr'] = ['wheat', 'corn']
    # beets1 - up to 6000 ton, beets2 - in excess of 6000 ton
    data['cropx'] = ['wheat', 'corn', 'beets1', 'beets2']
    # tons per acre for each crop
    data['yield'] = [2.5, 3, 20]
    # dollars per acre for each crop
    data['plantcost'] = [150, 230, 260]
    # dollars per ton for each cropx
    data['sellprice'] = [170, 150, 36, 10]
    # dollars per ton for each cropr
    data['purchprice'] = [238, 210]
    # minimum requirements in ton for each cropr
    data['minreq'] = [200, 240]
    # available land
    data['land'] = 500
    # maximum of beets produce
    data['maxbeets1'] = 6000
    # model scenarios
    data['scenarios'] = ['above', 'avg', 'below']

    return data


# scenarios data
def get_scenarios_data():

    scenarios = list()

    # Scenario 1
    scenario = dict()
    # scenario index
    scenario["index"] = 1
    # probabilities of each scenarios 'above', 'avg', 'below' in Scenario 1
    scenario['probabilities'] = [1/3, 1/3, 1/3]
    # earnings of each scenario 'above', 'avg', 'below' in Scenario 1
    scenario['earnings'] = [0.8, 1, 1.2]
    scenarios.append(scenario)

    # Scenario 2
    scenario = dict()
    scenario["index"] = 2
    # probabilities of each scenarios 'above', 'avg', 'below' in Scenario 2
    scenario['probabilities'] = [0.5, 0.3, 0.2]
    # earnings of each scenario 'above', 'avg', 'below' in Scenario 2
    scenario['earnings'] = [0.9, 1, 1.5]
    scenarios.append(scenario)

    return scenarios