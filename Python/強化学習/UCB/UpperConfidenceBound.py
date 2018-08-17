# Upper Confidence Bound

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Importing the dataset
dataset = pd.read_csv('data.csv')

# Implementing UCB
import math
N = 10000
d = 8
ads_selected = []
NumbersOfSelections = [0] * d
SumsOfRewards = [0] * d
total_reward = 0
for n in range(0, N):
    ad = 0
    max_upper_bound = 0
    for i in range(0, d):
        if (NumbersOfSelections[i] > 0):
            average_reward = SumsOfRewards[i] / NumbersOfSelections[i]
            delta_i = math.sqrt(3/2 * math.log(n + 1) / NumbersOfSelections[i])
            upper_bound = average_reward + delta_i
        else:
            upper_bound = 1e400
        if upper_bound > max_upper_bound:
            max_upper_bound = upper_bound
            ad = i
    ads_selected.append(ad)
    NumbersOfSelections[ad] = NumbersOfSelections[ad] + 1
    reward = dataset.values[n, ad]
    SumsOfRewards[ad] = SumsOfRewards[ad] + reward
    total_reward = total_reward + reward

# Visualising the results
plt.hist(ads_selected)
plt.title('Histogram of ads selections')
plt.xlabel('Ads')
plt.ylabel('Number of times each ad was selected')
plt.show()