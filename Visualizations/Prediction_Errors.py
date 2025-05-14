import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load the Excel file
file_path = 'Model_result.xlsx'

# Read the contents of the sheets
training_data = pd.read_excel(file_path, sheet_name='Training')
testing_data = pd.read_excel(file_path, sheet_name='Testing')

# Calculate errors (residuals) for both training and testing data
training_data['Error'] = training_data['y_train'] - training_data['y_train_predicted']
testing_data['Error'] = testing_data['y_test'] - testing_data['y_test_predicted']

# Setting a consistent color palette
unique_categories = pd.concat([training_data['Categoty'], testing_data['Categoty']]).unique()
palette = sns.color_palette("tab10", len(unique_categories))
category_colors = {cat: palette[i] for i, cat in enumerate(unique_categories)}

# Adjusting the order of the boxes in the plot as per the specified order
category_order = ["'Li2S2'", "'Li2S4'", "'Li2S6'", "'Li2S8'", "'S8'"]

# Plotting the box plots for error distributions without outliers and grid lines
plt.figure(figsize=(12, 6))

# Training data plot without outliers and grid lines
plt.subplot(1, 2, 1)
sns.boxplot(x='Categoty', y='Error', data=training_data, palette=category_colors, order=category_order, showfliers=False, linewidth=8)
plt.title('Training Data Error Distribution (No Outliers)')
plt.xticks(rotation=45)
plt.grid(False)

# Testing data plot without outliers and grid lines
plt.subplot(1, 2, 2)
sns.boxplot(x='Categoty', y='Error', data=testing_data, palette=category_colors, order=category_order, showfliers=False, linewidth=8)
plt.title('Testing Data Error Distribution (No Outliers)')
plt.xticks(rotation=45)
plt.grid(False)

plt.tight_layout()
plt.savefig('prediction_errors.jpg', dpi=600)
plt.show()
