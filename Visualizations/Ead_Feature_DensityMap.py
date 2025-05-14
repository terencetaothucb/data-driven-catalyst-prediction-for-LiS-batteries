import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the Excel file
file_path = 'dataset.xlsx'
data = pd.read_excel(file_path)

# Create a density plot with color mapping to show the density
plt.figure(figsize=(10, 6))

# Plotting the density of Ead vs. Rm
# You can adjust the features as needed
sns.kdeplot(data=data, x="Rm", y="Ead", fill=True, thresh=0, levels=100, cmap="mako")


plt.grid(False)
# save jpg 600 dpi
plt.savefig('Ead vs Features.jpg', dpi=600)
plt.show()
