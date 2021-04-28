import csv

def parse_scenarios_probabilities(input_file):
    probabilities = list()
    with open(input_file) as file:
        for row in file:
            probabilities.append(row.strip())

    return probabilities

def parse_file_by_row(input_file):
    tmp = dict()
    with open(input_file) as file:
        row_num = 1
        for row in file:
            tmp[str(row_num)] = float(row)
            row_num += 1

    #print(input_file)
    #print(tmp)
    return tmp

# csv parsing function
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
    #print([scenarios])
    return [scenarios]


# deterministic data
def get_data():
    data = dict()

    scenarios_probabilities_data_file = 'data/library/tetour/scenarios/small_data_probabilities.csv'
    rozsah_spotreby_vody_v_case_d = 'data/library/tetour/datafiles/rozsah_spotreby_vody_d.txt'
    rozsah_spotreby_vody_v_case_h = 'data/library/tetour/datafiles/rozsah_spotreby_vody_h.txt'
    rozsah_minimalnich_teplot_mesice_d = 'data/library/tetour/datafiles/rozsah_minimalnich_teplot_mesice_d.txt'
    rozsah_minimalnich_teplot_mesice_h = 'data/library/tetour/datafiles/rozsah_minimalnich_teplot_mesice_h.txt'
    rozsah_maximalnich_teplot_mesice_d = 'data/library/tetour/datafiles/rozsah_maximalnich_teplot_mesice_d.txt'
    rozsah_maximalnich_teplot_mesice_h = 'data/library/tetour/datafiles/rozsah_maximalnich_teplot_mesice_h.txt'


    data['i'] = ['Bio1', 'Bio2']  # typ kotle na biomasu
    data['j'] = ['Plyn']   # typ kotle na plyn
    data['t'] = 49         # uvazovane casy
    # uvazovane scenare
    data['s'] = sum(1 for line in open(scenarios_probabilities_data_file))
    data['m'] = 12         # mesice
    data['r'] = ['d', 'h'] # hranice pro generatory
    data['l'] = 4          # pocet simulaci

    data['o'] = 2.3        # prumerny pocet obyvatel v domacnosti
    data['d'] = 5000       # pocet domacnosti
    data['Td'] = 35        # mnozstvi poptavane teple vody v case t scenari s

    data['A'] = 1933.88202706417  # horni asymptota
    data['e'] = 2.71828182845905  # konstantní Eulerovo cislo
    data['Kg'] = -0.735635517649199  # logisticky rustovy koeficien
    data['T0'] = 9.41541981244695 # logisticky rustovy koeficient

    data['cap'] = [550, 750]  # maximalni kapacita kotle typu i
    data['bc'] = 0.65  # jednotkova cena za kWh vyrobenou biomasou
    data['gc'] = 1.40  # jednotkova cena za kWh vyrobenou plynem
    data['gjp'] = 552  # zisk z jednoho GJ vyrobene energie

    #pravdepodobnost scenare
    data['pst'] = parse_scenarios_probabilities(input_file=scenarios_probabilities_data_file)

    data['v_d'] = parse_file_by_row(input_file=rozsah_spotreby_vody_v_case_d)
    data['v_h'] = parse_file_by_row(input_file=rozsah_spotreby_vody_v_case_h)

    data['min_d'] = parse_file_by_row(input_file=rozsah_minimalnich_teplot_mesice_d)
    data['min_h'] = parse_file_by_row(input_file=rozsah_minimalnich_teplot_mesice_h)

    data['max_d'] = parse_file_by_row(input_file=rozsah_maximalnich_teplot_mesice_d)
    data['max_h'] = parse_file_by_row(input_file=rozsah_maximalnich_teplot_mesice_h)

    return data


# scenarios data
def get_scenarios_data():
    # get scenarios data from file
    return parse_scenarios_data(input_file='data/library/tetour/scenarios/small_data.csv')