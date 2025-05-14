import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the Excel file
file_path = 'Model_result.xlsx'

# Read the contents of the sheets
training_data = pd.read_excel(file_path, sheet_name='Training')
testing_data = pd.read_excel(file_path, sheet_name='Testing')

# Adjusting the order of the boxes in the plot as per the specified order
category_order = ["'Li2S2'", "'Li2S4'", "'Li2S6'", "'Li2S8'", "'S8'"]

# Append y_train and y_test along with their respective category labels
combined_data = pd.concat([
    training_data[['y_train', 'Categoty']].rename(columns={'y_train': 'y'}),
    testing_data[['y_test', 'Categoty']].rename(columns={'y_test': 'y'})
], ignore_index=True)

# Setting a consistent color palette as specified
unique_categories = pd.concat([training_data['Categoty'], testing_data['Categoty']]).unique()
palette = sns.color_palette("tab10", len(unique_categories))
category_colors = {cat: palette[i] for i, cat in enumerate(unique_categories)}

# Create a combined violin and strip plot for the combined data

plt.figure(figsize=(12, 8))

# Create a violin plot
sns.violinplot(data=combined_data, x='Categoty', y='y', palette=category_colors, inner=None, linecolor='k', linewidth=6, order=category_order)

# Overlay a strip plot on the violin plot
sns.stripplot(data=combined_data, x='Categoty', y='y', color='k', alpha=0.75, jitter=True, size=15, order=category_order)

plt.title('Combined Violin and Strip Plot of y by Category')
plt.xlabel('Category')
plt.ylabel('y Value')
plt.savefig('violin_strip_plot.jpg', dpi=600)
plt.show()

