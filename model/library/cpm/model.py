# set gams model
def get_gams_model():
    ''' wait-and-see model '''
    #return 'gams\\library\\cpm\\cpm_WS.gms'
    ''' expected-value model '''
    #return 'gams\\library\\cpm\\cpm_EV.gms'
    ''' min-max model '''
    #return 'gams\\library\\cpm\\cpm_MM.gms'
    ''' individual scenario model'''
    #return 'gams\\library\\cpm\\cpm_IS.gms'
    ''' two-staged model'''
    #return 'gams\\library\\cpm\\cpm_TS.gms'
    ''' two-staged model with EVPI and VSS'''
    return 'gams\\library\\cpm\\cpm_EVPI_EEV_VSS.gms'


# list of values to return from optimized gams model
def get_return_values():
    # return types
    ## - var = variable
    ## - par = parameter
    ## - sca = scalar
    '''WS, EV, MM'''
    #return_values = {'Z': 'var'}
    '''IS'''
    #return_values = {'Z': 'var', 'ver': 'par'}
    '''TS'''
    #return_values = {'Z': 'var', 'resc': 'sca'}
    '''TS with EVPI and VSS'''
    return_values = {'EVPI': 'sca', 'EEV': 'sca', 'VSS': 'sca'}
    return return_values


# sets, parameters and variables will be accesible in the gams model
def set_model(db, data, scenarios_data):
    ##
    ## START DEFINING MODEL DATA
    ## These sets, parameters and variables will be accesible in the gams model
    ##

    # python does index from 0, gams from 1
    i_indexes = range(1, data.get("i"))
    j_indexes = range(1, data.get("j"))
    if "s" in data:
        s_indexes = range(1, data.get("s"))

    # i
    i = db.add_set("i", 1, "i dimension")
    for item in i_indexes:
        # +1 becase python generates numbers from 0
        i.add_record(str(item))

    # j
    j = db.add_set("j", 1, "j dimension")
    for item in j_indexes:
        j.add_record(str(item))

    # c(j)
    c = db.add_parameter_dc("c", [j], "significance")
    for j_item, item in zip(j_indexes, data.get("c")):
        c.add_record(str(j_item)).value = item

    if not "s" in data and not "p" in data:
    # SIMPLE MODEL
        # xi(i)
        if "xi" in scenarios_data:
            xi = db.add_parameter_dc("xi", [i], "scenario")
            for ii, item in zip(i_indexes, scenarios_data.get("xi")):
                xi.add_record(str(ii)).value = item

    else:
    # COMPLEX MODEL - scenario of scenarios
        # s - number of scenarios (+1)
        if "s" in data:
            s = db.add_set("s", 1, "number of scenarios")
            for item in s_indexes:
                s.add_record(str(item))
#
        # p - scenarios probabilities
        if "p" in data:
            p = db.add_parameter_dc("p", [s], "scenarios probabilities")
            for ii, item in zip(s_indexes, data.get("p")):
                p.add_record(str(ii)).value = float(item)

        xi = db.add_parameter_dc("xi", [i, s], "One scenario of scenarios")
        for scenario_data in scenarios_data:
            #print(scenario_data)
            xi_data = scenario_data.get("xi")
            for xi_s_data in xi_data:
                #print('s=' + str(xi_s_data.get("index_s")), ':', xi_s_data.get("xi_s"))
                # filling the two-dimensional parameter
                for key, val in xi_s_data.get("xi_s").items():
                    #print(key, float(val))
                    xi.add_record(key).value = float(val)

        # TS
        # - i1 edges where recourse variables are not used
        # - i2 edges where recourse variables are used
        if "i1" in data and "i2" in data:
            i1 = db.add_set_dc("i1", [i], "edges where recourse variables are not used")
            for item in data.get("i1"):
                i1.add_record(str(item))

            i2 = db.add_set_dc("i2", [i], "edges where recourse variables are used")
            for item in data.get("i2"):
                i2.add_record(str(item))

        # qp - defining recourse variables values for edges in each scenario (plus)
        if "qp" in scenario_data:
            qp = db.add_parameter_dc("qp", [i, s], "defining recourse variables values for edges in each scenario (plus)")
            for scenario_data in scenarios_data:
                # print(scenario_data)
                qp_data = scenario_data.get("qp")
                for qp_s_data in qp_data:
                    # filling the two-dimensional parameter
                    for key, val in qp_s_data.get("xi_s").items():
                        # edit index by data i2 parameter
                        index = (str(data.get("i2")[int(key[0]) - 1]), key[1])
                        #print(index, str(float(val)))
                        qp.add_record(index).value = float(val)

        # qm - defining recourse variables values for edges in each scenario (minus)
        if "qm" in scenario_data:
            qm = db.add_parameter_dc("qm", [i, s], "defining recourse variables values for edges in each scenario (minus)")
            for scenario_data in scenarios_data:
                # print(scenario_data)
                qm_data = scenario_data.get("qm")
                for qm_s_data in qm_data:
                    # filling the two-dimensional parameter
                    for key, val in qm_s_data.get("xi_s").items():
                        # edit index by data i2 parameter
                        index = (str(data.get("i2")[int(key[0]) - 1]), key[1])
                        # print(index, str(float(val)))
                        qm.add_record(index).value = float(val)


    ##
    ## END DEFINING MODEL DATA
    ##

    return db