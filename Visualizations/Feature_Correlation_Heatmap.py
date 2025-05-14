import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
file_path = 'dataset.xlsx'
data = pd.read_excel(file_path)
# Selecting numerical columns from the 4th column to the end
numerical_data = data.iloc[:, 3:]
# Checking for correlation in the dataset for the heatmap
correlation_matrix = numerical_data.corr()

# Plotting the heatmap
plt.figure(figsize=(12, 8))
sns.heatmap(correlation_matrix, annot=False, cmap='coolwarm', linewidths=.5,vmin=-1, vmax=1)

# save the plot jpg 600 dpi
plt.savefig('heatmap.jpg', dpi=600)
plt.show()
