import pandas as pd
import numpy as np
import random
import matplotlib.pyplot as plt
import jsf

def bd_python(p_birth, p_death, pop, max_time, seed = None):
    if seed is not None:
        np.random.seed(int(seed))

    x0 = [pop] 
    p_birth = p_birth
    p_death = p_death
    max_time = max_time

    rates = lambda x, _: [p_birth * x[0], p_death * x[0]]

    reactant_matrix = [[1], [1]]

    product_matrix = [[2], [0]]
    stoich = {
        "nu": [[1], [-1]],
        "DoDisc": [1],
        "nuReactant": reactant_matrix,
        "nuProduct": product_matrix,
    }

    my_opts = {
        "EnforceDo": [0],
        "dt": 0.01,
        "SwitchingThreshold": [30]
    }


    sim = jsf.jsf(x0, rates, stoich, max_time, config=my_opts, method="operator-splitting")

    return {"time": sim[1], "count": sim[0][0]}
