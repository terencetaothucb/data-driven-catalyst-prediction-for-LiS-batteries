import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
# Load the Excel file
file_path = 'Model_result.xlsx'

# Read the Excel file and get the names of the sheets
sheets = pd.ExcelFile(file_path)
sheet_names = sheets.sheet_names
# Read the contents of the sheets
training_data = pd.read_excel(file_path, sheet_name='Training')
testing_data = pd.read_excel(file_path, sheet_name='Testing')


# Setting a consistent color palette
unique_categories = pd.concat([training_data['Categoty'], testing_data['Categoty']]).unique()
palette = sns.color_palette("tab10", len(unique_categories))
category_colors = {cat: palette[i] for i, cat in enumerate(unique_categories)}

# Updated function to create a fancy parity plot with categories
def create_fancy_parity_plot(actual, predicted, categories, title):
    plt.figure(figsize=(10, 8))
    for category in unique_categories:
        subset = categories == category
        sns.scatterplot(x=actual[subset], y=predicted[subset], label=category, color=category_colors[category], alpha=0.8, s=800, edgecolor='w')
    plt.plot([actual.min(), actual.max()], [actual.min(), actual.max()], 'k--', linewidth=4)  # y = x line
    plt.xlabel('Actual Values', fontsize=14, color='blue')
    plt.ylabel('Predicted Values', fontsize=14, color='blue')
    plt.title(title, fontsize=16, fontweight='bold')
    plt.legend(title='Category', bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
    plt.xticks(rotation=0)
    plt.yticks(fontsize=12)
    plt.grid(False)
    plt.tight_layout()

# Applying enhanced functions to create the plots
create_fancy_parity_plot(training_data['y_train'], training_data['y_train_predicted'], training_data['Categoty'], 'Enhanced Training Data Parity Plot')
plt.savefig('parity_plot_training.jpg', dpi=600)
plt.show()
create_fancy_parity_plot(testing_data['y_test'], testing_data['y_test_predicted'], testing_data['Categoty'], 'Enhanced Testing Data Parity Plot')
plt.savefig('parity_plot_testing.jpg', dpi=600)
plt.show()



