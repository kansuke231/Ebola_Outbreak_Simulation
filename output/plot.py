import os
import csv
import matplotlib.pyplot as plt
import numpy as np

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
	    	bundle.append(data[:150])

	    # bundle should look like: [[0,4,6,7,7], [1,4,5,6,8], [0,0,3,4,9],..]
	    points = average(zip(*bundle))

	    plt.plot(points, linestyle = "-", label="compliance rate: "+postfix[0]+"."+postfix[1])

	plt.legend(loc=2)
	plt.axvline(x = 50, color = "r")
	plt.xlabel("time")
	plt.ylabel("Number of Infectious cells")
	plt.xlim([0,140])
	plt.ylim([0,500])
	plt.show()


if __name__ == '__main__':
    main()
