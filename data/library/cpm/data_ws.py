# deterministic data
def get_data():
    data = dict()

    # dimensions
    data['i'] = 19 # 18 dimension, python generates numbers from 0
    data['j'] = 14 # 13 dimension, python generates numbers from 0
    # c - significance
    data['c'] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]

    return data


import csv
# csv parsing function
def parse_scenarios_data(input_file):

    scenarios = list()
    with open(input_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        index = 1
        for row in csv_reader:
            scenario = dict()
            scenario["index"] = index
            index += 1
            scenario["xi"] = [float(item) for item in row]
            scenarios.append(scenario)

    return scenarios


# scenarios data
def get_scenarios_data():

    scenarios = list()

    # Scenario 1
    #scenario = dict()
    # scenario index
    #scenario["index"] = 1
    # time length for each line in cpm
    #scenario['xi'] = [4.25, 4.25, 4.25, 4.25, 2.25, 54, 23, 54, 23, 2, 3.5, 2, 1.00, 7, 1, 3.00, 6, 3]
    #scenarios.append(scenario)

    # get scenarios data from file
    # - comment two line below to use only one scenario (scenario above)
    scenarios = parse_scenarios_data(input_file='data/library/cpm/scenarios_data.csv')

    return scenarios