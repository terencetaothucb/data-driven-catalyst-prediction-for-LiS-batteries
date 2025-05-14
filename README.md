# data-driven-catalyst-prediction-for-LiS-batteries
Data-driven insight into the universal structure-property relationship of catalysts in lithium-sulfur batteries.

# Catalyst–LiPS Adsorption Energy Prediction

This repository provides the full implementation of the machine learning framework used in our study to predict adsorption energies between metal-based catalysts and lithium polysulfides (LiPS). The model is based on a multi-expert bootstrap-ensemble of Random Forest regressors and is built entirely in MATLAB.

The code enables end-to-end reproduction of the training, validation, prediction, and visualization procedures described in the manuscript.

---

## 🚀 Overview

- **Purpose**: To predict catalyst–LiPS adsorption energies using literature-derived descriptors and a collaborative ensemble machine learning model.
- **Key Components**:
  - Data preprocessing and splitting
  - Random Forest model training and hyperparameter selection
  - Validation and performance evaluation
  - Visualization of predicted vs. actual values

---

## 📁 File Summary

| File | Description |
|------|-------------|
| `SplitData.m` | Splits raw dataset into training and validation sets |
| `SelectModels.m` | Performs grid search to optimize Random Forest hyperparameters |
| `RF.m` | Trains the Random Forest models (bootstrap ensemble) |
| `PredictValidation.m` | Applies the trained model to the validation set |
| `calculate_r2.m` | Computes evaluation metrics (R², RMSE, etc.) |
| `VisualPrediction.m` | Generates visualizations for predicted vs. true energies |
| `ValidPred.xlsx` | Sample output of prediction results |

---

## ⚙️ Requirements

- MATLAB R2018a or newer
- Statistics and Machine Learning Toolbox
- (Optional) Excel I/O support for `.xlsx` data handling

---

## ▶️ How to Use

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/adsorption-energy-prediction.git
   cd adsorption-energy-prediction

% Step 1: Data preparation
SplitData;

% Step 2: Hyperparameter tuning
SelectModels;

% Step 3: Train the ensemble
RF;

% Step 4: Predict and evaluate
PredictValidation;
calculate_r2;

% Step 5: Visualize results
VisualPrediction;
