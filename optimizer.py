from __future__ import print_function

from gams import *
import threading
import argparse
from settings.optimizer_settings import *


# Main optimizer class
class Optimizer(object):
    ws = None
    gams_file = None

    # Constructor
    def __init__(self, gams_file):
        if Optimizer.ws == None:
            Optimizer.ws = GamsWorkspace(debug=DebugLevel.KeepFiles)

        self.gams_file = gams_file


    # Returns gams model from gams input file
    def get_model_text(self):
        with open(self.gams_file) as f:
            return f.read()


    # Optimization solver, returns just objective function value
    def solve(self, data, scenarios_data):
        db = Optimizer.ws.add_database()

        # set model data
        db = set_model(db, data, scenarios_data)

        # Get the gams model text, from input gams file
        job = Optimizer.ws.add_job_from_string(Optimizer.get_model_text(self))

        # Input file name for use in gams macros
        opt = Optimizer.ws.add_options()
        opt.defines["gdxincname"] = db.name
        # Run the optimizition
        job.run(opt, databases=db)

        ## START GETTING VALUES FROM MODEL
        result = dict()
        return_values = get_return_values()

        for key, val in return_values.items():
            if val == 'var':
                result[key] = job.out_db.get_variable(key).first_record().level

            elif val == 'sca':
                for rec in job.out_db.get_parameter(key):
                    result[key] = rec.value

            elif val == 'par':
                tmp = list()
                for rec in job.out_db.get_parameter(key):
                    tmp.append(rec)

                result[key] = tmp

        ## END GETTING VALUES FROM MODELS

        return result



# Checking application arguments
def check_arguments():
    parser = argparse.ArgumentParser(description='Integrated Python->Gams optimizer for model: ')
    parser.add_argument('-r', '--results', help='not to print results', action='store_true')
    parser.add_argument('-s', '--scenarios', help='print scenarios data', action='store_true')
    parser.add_argument('-m', '--model_print', help='print all parameters, sets and scalars', action='store_true')
    parser.add_argument('-o', '--output', help="direct the output to a name of your choice (without an extension)")
    parser.add_argument('-x', '--excel', help="generate output file as an excel document")
    #parser.add_argument('-g', '--graph', help="generate output graph file")


    p = parser.parse_args()

    PRINT_RESULTS = False if p.results else True
    PRINT_SCENARIOS = True if p.scenarios else False
    PRINT_MODEL = True if p.model_print else False
    OUTPUT_FILE = p.output
    OUTPUT_XLXS = p.excel
    OUTPUT_GRAPH = False

    return PRINT_SCENARIOS, PRINT_RESULTS, PRINT_MODEL, OUTPUT_FILE, OUTPUT_XLXS, OUTPUT_GRAPH


# generate excel output
def create_excel_output(OUTPUT_XLXS, OUTPUT_XLXS_DATA):
    import xlsxwriter
    # Create a workbook and add a worksheet.
    workbook = xlsxwriter.Workbook(OUTPUT_XLXS + '.xlsx')
    #TODO..optimalize view#data_worksheet = workbook.add_worksheet('Data')
    results_worksheet = workbook.add_worksheet('Results')

    # Control variables
    row = 0
    col = 0
    # Worksheets headings
    #TODO..optimalize view#data_worksheet.write(row, col, 'Scenario')
    results_worksheet.write(row, col, 'Scenario')
    #scenario_variables = OUTPUT_XLXS_DATA[0].get('data')
    scenario_results = OUTPUT_XLXS_DATA[0].get('results')

    #print("[DEBUG] data", OUTPUT_XLXS_DATA)
    '''for key, val in scenario_variables.items():
        data_worksheet.write(row, col + 1, key)
        col += 1'''

    col =0
    for key, val in scenario_results.items():
        results_worksheet.write(row, col + 1, key)
        col += 1

    '''# Worksheets body, starting from second line
    row = 1
    # data worksheet ... todo optimalize view
    for s_data in OUTPUT_XLXS_DATA:
        col = 0
        data_worksheet.write(row, col, s_data.get('index'))
        for key, val in s_data.get('data').items():
            data_worksheet.write(row, col + 1, val)
            col += 1
        row += 1'''

    row = 1
    # results worksheet
    for s_data in OUTPUT_XLXS_DATA:
        col = 0
        results_worksheet.write(row, col, s_data.get('index'))
        for key, val in s_data.get('results').items():
            results_worksheet.write(row, col + 1, val)
            col += 1
        row += 1

    # add filters for indexes
    #TODO..optimalize view#data_worksheet.autofilter(0,0,0,0)
    results_worksheet.autofilter(0,0,0,0)

    workbook.close()


if __name__ == "__main__":
    # Checking arguments
    PRINT_SCENARIOS, PRINT_RESULTS, PRINT_MODEL, OUTPUT_FILE, OUTPUT_XLXS, OUTPUT_GRAPH = check_arguments()
    # get gams file
    gams_file = get_gams_model()
    print("[INFO] Working with model: ", gams_file)
    # Get deterministic data
    data = get_data()
    # Get scenarios data
    scenarios_data = get_scenarios_data()
    # Creating instance of the optimizer
    optim = Optimizer(gams_file)
    lock = threading.Lock()

    # open file for output (if wanted)
    if OUTPUT_FILE:
        output_txt_file = open(OUTPUT_FILE + '.txt', "w")
    # data for excel output file
    OUTPUT_XLXS_DATA = list()

    # dicts fot collecting data for excel
    excel_data = list()

    # This function starts each scenario and prints the results
    def run_scenario(optim, data, scenario_data):
        global OUTPUT_XLXS_DATA
        # collect data for excell for one scenario
        OUTPUT_XLXS_SCENARIO_DATA = dict()
        OUTPUT_XLXS_SCENARIO_RESULTS = dict()

        result = optim.solve(data, scenario_data)
        lock.acquire()

        if PRINT_RESULTS or PRINT_SCENARIOS:
            if isinstance(scenario_data, dict):
                if 'index' in scenario_data:
                    print("\n" + str(scenario_data.get('index')) + ". scenario")

            if OUTPUT_FILE:
                if isinstance(scenario_data, dict):
                    output_txt_file.write("\n" + str(scenario_data.get('index')) + ". scenario\n")


        if PRINT_SCENARIOS:
            print("Data:")
            if OUTPUT_FILE:
                output_txt_file.write("Data:\n")

            # simple scenarios data
            if isinstance(scenario_data, dict):
                for key, value in scenario_data.items():
                    # not to print index
                    if key == "index":
                        continue
                    print("\t" + str(key) + ": " + str(value))
                    if OUTPUT_FILE:
                        output_txt_file.write("\t" + str(key) + ": " + str(value) + "\n")

            # complex scenarios data
            elif isinstance(scenario_data, list):
                for scen_data in scenario_data:
                    for key, value in scen_data.items():
                        # not to print index
                        if key == "index":
                            continue
                        print("\t" + str(key) + ": " + str(value))
                        if OUTPUT_FILE:
                            output_txt_file.write("\t" + str(key) + ": " + str(value) + "\n")


        if PRINT_RESULTS:
            print("Result:")
            if OUTPUT_FILE:
                output_txt_file.write("Result:\n")
            for key, value in result.items():
                # value is gams parameter
                if isinstance(value, list):
                    print("\t" + str(key) + ":")
                    for val in value:
                        print("\t " + str(val))

                # value is gams variable
                else:
                    print("\t" + str(key) + ": " + str(value))
                    if OUTPUT_FILE:
                        output_txt_file.write("\t" + str(key) + ": " + str(value) + "\n")

        # Collecting data for excel
        if OUTPUT_XLXS:
            # collect scenario data
            if isinstance(scenario_data, dict):
                for key, value in scenario_data.items():
                    # not to get index
                    if key == "index":
                        continue
                    OUTPUT_XLXS_SCENARIO_DATA[str(key)] = str(value)
                # collect result data
                for key, value in result.items():
                    OUTPUT_XLXS_SCENARIO_RESULTS[str(key)] = str(value)

                OUTPUT_XLXS_DATA.append({'index': scenario_data.get('index'), 'data':OUTPUT_XLXS_SCENARIO_DATA, 'results': OUTPUT_XLXS_SCENARIO_RESULTS})

            elif isinstance(scenario_data, list):
                for scen_data in scenario_data:
                    for key, value in scen_data.items():
                        # not to get index
                        if key == "index":
                            continue
                        OUTPUT_XLXS_SCENARIO_DATA[str(key)] = str(value)
                    # collect result data
                    for key, value in result.items():
                        OUTPUT_XLXS_SCENARIO_RESULTS[str(key)] = str(value)

                    OUTPUT_XLXS_DATA.append({'index': scen_data.get('index'), 'data': OUTPUT_XLXS_SCENARIO_DATA, 'results': OUTPUT_XLXS_SCENARIO_RESULTS})

        lock.release()


    if OUTPUT_FILE:
        print("[INFO] TXT Output will be stored to", output_txt_file.name)

    if PRINT_MODEL:
        print("Model:")
        if OUTPUT_FILE:
            output_txt_file.write("Model:\n")
        for key, value in data.items():
            print("\t" + str(key) + ": " + str(value))
            if OUTPUT_FILE:
                output_txt_file.write("\t" + str(key) + ": " + str(value) + "\n")

    if PRINT_RESULTS or PRINT_SCENARIOS or OUTPUT_FILE or OUTPUT_XLXS:
        # Each scenario runs in its own thread
        for scenario_data in scenarios_data:
            t = threading.Thread(target=run_scenario, args=(optim, data, scenario_data))
            t.start()

        # waiting until all thread finishes execution
        t.join()

    if OUTPUT_XLXS:
        create_excel_output(OUTPUT_XLXS, OUTPUT_XLXS_DATA)
        print("[INFO] Generated output excel file to", OUTPUT_XLXS + str(".xlsx"))