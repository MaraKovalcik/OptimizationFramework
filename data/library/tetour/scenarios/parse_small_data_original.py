import csv

first_scenario = list()
second_scenario = list()
third_scenario = list()

with open('small_data_original.txt') as file:
    for row in file:
        row_splitted = row.split(',')

        first_scenario.append(float(row_splitted[0].split(" ")[1]))
        second_scenario.append(float(row_splitted[1].split(" ")[1]))
        third_scenario.append(float(row_splitted[2].split(" ")[1]))

with open('small_data.csv', 'w', newline='') as file:
    writer = csv.writer(file, delimiter=';')

    writer.writerow(first_scenario[:-1])
    writer.writerow(second_scenario[:-1])
    writer.writerow(third_scenario[:-1])

