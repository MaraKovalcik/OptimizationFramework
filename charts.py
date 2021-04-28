import matplotlib.pyplot as plt
import sys

''' Graph frontend settings '''
SMALL_SIZE = 12
MEDIUM_SIZE = 18
BIGGER_SIZE = 22

plt.rc('font', size=MEDIUM_SIZE)          # controls default text sizes
plt.rc('axes', titlesize=BIGGER_SIZE)     # fontsize of the axes title
plt.rc('axes', labelsize=BIGGER_SIZE)     # fontsize of the x and y labels
plt.rc('xtick', labelsize=MEDIUM_SIZE)    # fontsize of the tick labels
plt.rc('ytick', labelsize=MEDIUM_SIZE)    # fontsize of the tick labels
plt.rc('legend', fontsize=MEDIUM_SIZE)    # legend fontsize
plt.rc('figure', titlesize=MEDIUM_SIZE)   # fontsize of the figure title
#plt.yscale('log')
plt.xscale('log')
plt.figure(figsize=(15, 15))

linestyle = '-'
marker = 'o'
linewidth = 3
markersize = 0


''' This function create list of cumulated values from original list
    Usage: 
        o =[ 0, 1, 2, 3]
        c = cumulate(o)
        # c = [0, 1, 3, 6]
'''
def cumulate(y):
    tmp = list()
    index = 0
    for el in y:
        if index == 0:
            tmp.append(y[index])
        else:
            tmp.append(tmp[index-1] + y[index])
        index += 1
    return tmp


''' This function plots the final graph
    y = list of number on yaxis
        - user list of lists of numbers to view more lines in one graph        
'''
def plot(x, y):
    '''Lines settings '''
    lines = list()

    if isinstance(y, list):
        for line in y:
            l, = plt.plot(x, line.get('values'), linestyle, marker=marker, linewidth=linewidth, markersize=markersize, color=line.get('color'), label=line.get('label'))
            lines.append(l)

    plt.legend(handles=lines, loc='upper left')

    ''' Major grid lines '''
    plt.grid(b=True, which='major', color='gray', alpha=0.6, linestyle='dashdot', lw=1.5)

    ''' Minor grid lines '''
    #plt.minorticks_on()
    #plt.grid(b=True, which='minor', color='beige', alpha=0.8, ls='-', lw=1)

    ''' Axis labels '''
    plt.xlabel(graph_x_label)
    plt.ylabel(graph_y_label)

    ''' Show results '''
    plt.show()


if __name__ == '__main__':

    ''' This switch is used to easily switching when graph plotting'''
    switch = sys.argv[1] if len(sys.argv) == 2 else 0
    switch = int(switch)

    if switch == 0:
        ''' Graph settings '''
        graph_x_label = 'Počet scénářů'
        graph_y_label = 'Čas [h]'

        ''' Graph data definition '''
        x = [1, 10, 100, 1000, 10000, 100000]
        y1 = {'label': 'GAMS Studio',         'values': [0.92/3600, 1.08/3600, 7.04/3600, 64.00/3600, 994/3600, 29556/3600], 'color': 'red'}
        y2 = {'label': 'F: Výpočet',          'values': [0.39/3600, 0.60/3600, 6.03/3600, 54.64/3600, 293/3600, 4269/3600], 'color': 'blue'}
        y3 = {'label': 'F: Export txt',       'values': [0.39/3600, 0.69/3600, 6.13/3600, 54.99/3600, 295/3600, 4275/3600], 'color': 'darkorange'}
        y4 = {'label': 'F: Export xls',       'values': [0.45/3600, 0.72/3600, 6.31/3600, 57.36/3600, 297/3600, 4278/3600], 'color': 'black'}
        y5 = {'label': 'Framework', 'values': [0.72/3600, 0.73/3600, 6.45/3600, 57.72/3600, 301/3600, 4297/3600], 'color': 'green'}
        y = [y1, y5]

    elif switch == 1:
        ''' Graph settings '''
        graph_x_label = 'Počet scénářů'
        graph_y_label = 'Čas [s]'

        ''' Graph data definition '''
        x = [1, 10, 100]
        y1 = {'label': 'GAMS Studio: Výpočet',         'values': [0.92, 1.08, 7.04], 'color': 'red'}
        y2 = {'label': 'Framework: Výpočet',          'values': [0.39, 0.60, 6.03], 'color': 'blue'}
        y3 = {'label': 'Framework: Výpočet + Export txt',       'values': [0.39, 0.69, 6.13], 'color': 'darkorange'}
        y4 = {'label': 'Framework: Výpočet + Export xls',       'values': [0.45, 0.72, 6.31], 'color': 'black'}
        y5 = {'label': 'Framework: Výpočet + Export txt + xls', 'values': [0.72, 0.73, 6.45], 'color': 'green'}
        y = [y1, y2, y3, y4, y5]

    elif switch == 2:
        ''' Graph settings '''
        graph_x_label = 'Počet scénářů'
        graph_y_label = 'Čas [h]'

        ''' Graph data definition '''
        x = [1000, 10000, 100000]
        y1 = {'label': 'GAMS Studio',         'values': [64.00/3600, 994/3600, 29556/3600], 'color': 'red'}
        #y2 = {'label': 'F: Výpočet',          'values': [54.64/60, 293/60, 4269/60], 'color': 'blue'}
        #y3 = {'label': 'F: Export txt',       'values': [54.99/60, 295/60, 4275/60], 'color': 'darkorange'}
        #y4 = {'label': 'F: Export xls',       'values': [57.36/60, 297/60, 4278/60], 'color': 'black'}
        y5 = {'label': 'Framework', 'values': [57.72/3600, 301/3600, 4297/3600], 'color': 'green'}
        y = [y1, y5]


    plot(x, y)