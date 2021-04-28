POCET_SCENARU = 5
POCET_CASU = 49
NAZEV_SOUBORU_SCENARE = 'big_data.csv'
NAZEV_SOUBORU_PRAVDEPODOBNOSTI = 'big_data_probabilities.csv'

MIN = 0.05
MAX = 0.95

print("[INFO] Generating", POCET_SCENARU, "scenarios")

import random, csv, numpy

with open(NAZEV_SOUBORU_SCENARE, 'w', newline='') as file:
    writer = csv.writer(file, delimiter=';')
    for i in range(POCET_SCENARU):
        scenario = list()
        for t in range(POCET_CASU):
            scenario.append(random.uniform(MIN, MAX))
        writer.writerow(scenario[:-1])

with open(NAZEV_SOUBORU_PRAVDEPODOBNOSTI, 'w', newline='') as file:
    probabilities = numpy.random.dirichlet(numpy.ones(POCET_SCENARU),size=1)
    for p in probabilities[0]:
        file.write(str(p) + "\n")

print("[INFO] Generated", POCET_SCENARU, 'scenarios and probabilities')