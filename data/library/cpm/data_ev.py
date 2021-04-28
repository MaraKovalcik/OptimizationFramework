import csv

# probabilities parsing function
def parse_scenarios_probabilities(input_file):
    probabilities = list()
    with open(input_file) as file:
        for row in file:
            probabilities.append(row.strip())

    return probabilities

# deterministic data
def get_data():
    data = dict()

    # dimensions
    data['i'] = 19 # 18 dimension, python generates numbers from 0
    data['j'] = 14 # 13 dimension, python generates numbers from 0
    # c - significance
    data['c'] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
    # s - number of scenarios
    data['s'] = sum(1 for line in open('data/library/cpm/scenarios_data.csv')) + 1
    # p -scenarios probabilities
    data['p'] = parse_scenarios_probabilities(input_file='data/library/cpm/scenarios_prob.csv')
    return data

# csv data parsing function
def parse_scenarios_data(input_file):

    scenarios = list()
    with open(input_file) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        row_index = 0

        for row in csv_reader:
            row_index += 1
            scenario = dict()
            scenario["index_s"] = row_index

            column_index = 0
            scen = dict()
            for column in row:
                column_index += 1
                scen[(str(column_index), str(row_index))] = column
            scenario["xi_s"] = scen

            scenarios.append(scenario)

    # return sceario of scenarios
    return scenarios


# scenarios data
def get_scenarios_data():

    # get scenarios data from file
    # - comment two line below to use only one scenario (scenario above)
    scenarios = parse_scenarios_data(input_file='data/library/cpm/scenarios_data.csv')

    return [[{"index": 1, "xi": scenarios}]]


if __name__ == '__main__':
    print(get_scenarios_data())