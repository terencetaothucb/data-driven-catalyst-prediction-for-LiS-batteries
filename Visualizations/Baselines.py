import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression, Lasso, Ridge, ElasticNet
from sklearn.svm import SVR
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.neural_network import MLPRegressor
from sklearn.metrics import mean_squared_error

# Load the data
file_path = 'Training_Testing_Data.xlsx'
data = pd.read_excel(file_path)

# Splitting the data into features and labels
features = data.drop('TM', axis=1)
labels = data['TM']

# Splitting the data into training and testing sets
num_train_samples = int(len(features) * 0.8)
X_train = features.iloc[:num_train_samples]
y_train = labels.iloc[:num_train_samples]
X_test = features.iloc[num_train_samples:]
y_test = labels.iloc[num_train_samples:]

# Initialize models
models = {
    "Linear Regression": LinearRegression(),
    "Lasso": Lasso(),
    "Ridge": Ridge(),
    "Elastic Net": ElasticNet(),
    "SVR": SVR(),
    "MLP": MLPRegressor(max_iter=1000)  # Increased iterations for convergence
}

# Training each model and calculating RMSE, max and min errors
results = []

for name, model in models.items():
    # Train the model
    model.fit(X_train, y_train)

    # Make predictions on training and testing sets
    y_train_pred = model.predict(X_train)
    y_test_pred = model.predict(X_test)

    # Calculate RMSE for training and testing sets
    rmse_train = np.sqrt(mean_squared_error(y_train, y_train_pred))
    rmse_test = np.sqrt(mean_squared_error(y_test, y_test_pred))

    # Calculate max and min errors for training and testing sets
    max_error_train = np.max(np.abs(y_train - y_train_pred))
    min_error_train = np.min(np.abs(y_train - y_train_pred))
    max_error_test = np.max(np.abs(y_test - y_test_pred))
    min_error_test = np.min(np.abs(y_test - y_test_pred))

    results.append({
        "Model": name,
        "RMSE (Training)": rmse_train,
        "RMSE (Testing)": rmse_test,
        "Max Error (Training)": max_error_train,
        "Min Error (Training)": min_error_train,
        "Max Error (Testing)": max_error_test,
        "Min Error (Testing)": min_error_test
    })

# Convert results to DataFrame
results_df = pd.DataFrame(results)
results_df.sort_values(by="RMSE (Testing)", inplace=True)  # Sorting by RMSE on Testing
results_df.reset_index(drop=True, inplace=True)

# Display final results
print(results_df)
