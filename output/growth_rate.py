import os
import csv
import numpy as np
import math
from sklearn.linear_model import LinearRegression

DELTA = 10
GAMMA = 7

def data_import(filename):
    
    with open(filename,"r") as f:
        reader = csv.reader(f,delimiter=' ')

        result = []

        for row in reader:
            result.append(int(row[3]))

    return  result

def average(points_list):
	return map(lambda x: round(x,2) ,map(np.average, points_list))

def main():
	pwd = os.getcwd()
	for postfix in ["00","02","04","06","08","10"]:
	    files = [ file for file in os.listdir(pwd+"/c_"+postfix) if (not file.startswith('.'))]

	    bundle = []

	    for f in files:
	    	data = data_import("c_"+postfix+"/"+f)
	    	last = data[-1]
	    	# for padding
	    	data = data + [last for i in range(100)]
	    	bundle.append(data[:150])

	    # bundle should look like: [[0,4,6,7,7], [1,4,5,6,8], [0,0,3,4,9],..]
	    points = average(zip(*bundle))
	    cumulative = np.cumsum(points)
	    log_cumulative = map(lambda x: 0 if x == 0 else math.log(x), cumulative)
	    LinearReg = LinearRegression()
	    x = np.array([i for i in range(len(log_cumulative))])
	    LinearReg.fit(x[:,np.newaxis], log_cumulative)
	    coef =  LinearReg.coef_[0]

	    r = pow(math.e,coef) - 1 #growth rate

	    R0 = 1 + (DELTA + GAMMA)*r + DELTA*GAMMA*pow(r,2)
	    print R0



	    
	   

if __name__ == '__main__':
    main()