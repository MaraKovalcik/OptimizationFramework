# deterministic data
def get_data():
    data = dict()

    # canning plants
    data['i'] = ['Seattle', 'San-Diego']
    # markets
    data['j'] = ['New-York', 'Chicago', 'Topeka']
    # capacity of plant i in cases
    data['a'] = [350, 600]
    # demand at market j in cases
    data['b'] = [325, 300, 275]
    # table of distance in thousands of miles

    data['d'] = {
        (data['i'][0], data['j'][0]): 2.5, # ("Seattle", "New-York"): 2.5
        (data['i'][0], data['j'][1]): 1.7, # ("Seattle", "Chicago"): 1.7
        (data['i'][0], data['j'][2]): 1.8, # ("Seattle", "Topeka"): 1.8
        (data['i'][1], data['j'][0]): 2.5, # ("San-Diego", "New-York"): 2.5
        (data['i'][1], data['j'][1]): 1.8, # ("San-Diego", "Chicago"): 1.8
        (data['i'][1], data['j'][2]): 1.4, # ("San-Diego", "Topeka"): 1.4
    }

    return data


# scenarios data
def get_scenarios_data():
    f = [0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3]
    scenarios = list()

    # Load scenarios
    index = 1
    for ff in f:
        scenario = dict()
        scenario["index"] = index
        # Freight in dollars per case per thousand miles
        scenario['f'] = ff
        scenarios.append(scenario)
        index+=1

    return scenarios