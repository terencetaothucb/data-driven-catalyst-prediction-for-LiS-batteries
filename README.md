# 📘 Universal Structure–Property Modeling of Catalysts in Lithium–Sulfur Batteries

This repository contains the datasets, machine learning code, and visualization tools used in the study:

**"Data-driven insight into the universal structure-property relationship of catalysts in lithium-sulfur batteries"**

Published in *Journal of the American Chemical Society* (2025).  
Corresponding authors: [Guangmin Zhou](mailto:guangminzhou@sz.tsinghua.edu.cn), [Xuan Zhang](mailto:xuanzhang@sz.tsinghua.edu.cn)

---

## 🧭 Motivation

The sulfur reduction reaction (SRR) is a critical step in lithium–sulfur batteries, yet its catalytic mechanisms remain poorly understood. Existing DFT methods are limited by cost and specificity. To address this, we develop a data-driven framework that extracts universal structure–property relationships (UQSPRs) from a large-scale, heterogeneous dataset and enables rapid prediction and discovery of effective catalysts using machine learning.

**Our dataset spans 20 years (2004–2024)** and is constructed from over **2,900 peer-reviewed studies**. It contains **481 data points**, covering diverse transition metal compounds and their interactions with five representative polysulfide species. This diversity enables robust and generalizable model learning.

---

## 🚀 Key Contributions

- Built the first high-quality adsorption energy dataset for SRR catalysts based on literature mining.
- Proposed a geometric descriptor (dispersion factor) that predicts catalytic activity better than traditional electronic descriptors.
- Trained a collaborative machine learning model using random forests and feature screening.
- Screened 374,833 materials and experimentally validated CrB₂ as a high-performance catalyst.

---

## 🔧 Code Structure and Usage Guide

This repository provides the complete codebase and data files to reproduce the machine learning framework for predicting the catalytic activity of Li–S battery catalysts.

### 📁 Code Structure Overview

```text
├── dataset.xlsx                     # Final dataset with 14 features and adsorption energy
├── candidates_from_expert.xlsx      # Expert-selected feature candidates
├── Training_Testing_Data.xlsx       # Pre-defined train/test split for model training
│
├── Main.m                           # Main script to run model training and prediction
├── Candidate_Features.m             # Feature construction from raw materials data
├── Rules_candidates.m               # Apply selection rules to reduce feature space
├── SplitData.m                      # Data splitting into training and validation sets
├── RF.m                             # Random Forest training with bootstrap strategy
├── SelectModels.m                   # Aggregates top expert models for final prediction
├── PredictValidation.m              # Predicts on validation data using trained ensemble
├── calculate_r2.m                   # R² score calculation
├── VisualPrediction.m               # MATLAB-based result visualization
│
├── Python scripts (optional)        # For plotting and result analysis
│   ├── Feature_Correlation_Heatmap.py
│   ├── Ead_Distributions.py
│   ├── Prediction_Errors.py
│   └── Prediction_Results.py
```

---

### ▶️ How to Use

1. **Prepare Data**  
   Ensure `dataset.xlsx` is formatted with 14 descriptors and adsorption energy as target. You may use your own dataset following the same format.

2. **Run the Main Pipeline**  
   Launch `Main.m` in MATLAB. This script:
   - Loads the dataset
   - Splits it using `SplitData.m`
   - Trains multiple random forest models via `RF.m`
   - Aggregates top models in `SelectModels.m`
   - Predicts adsorption energy using `PredictValidation.m`

3. **Evaluate Model Performance**  
   Use `calculate_r2.m` to compute accuracy metrics. Visualization is supported via:
   - `VisualPrediction.m` (MATLAB)
   - or Python scripts for advanced plotting (`Prediction_Results.py`, etc.)

4. **Screen New Materials**  
   Replace the input dataset with new candidate features and repeat the above steps. Predictions will guide high-throughput catalyst selection.

---

## 📊 Visualization and Analysis

Python scripts provide additional tools for performance analysis:

- `Feature_Correlation_Heatmap.py`: Correlation between structural and electronic features.
- `Prediction_Errors.py`: Parity and error plots.
- `Prediction_Results.py`: Visualizes top-performing catalyst predictions.
- `Ead_Distributions.py`: Adsorption energy distributions across LiPS species.

---

## 📌 Requirements

### MATLAB

- Version: R2023a or later
- Toolboxes: Statistics and Machine Learning Toolbox

### Python (Optional)

- Python ≥ 3.8  
- Required packages:
  - `pandas`
  - `matplotlib`
  - `seaborn`
  - `scikit-learn`
  - `numpy`

Install via pip:

```bash
pip install pandas matplotlib seaborn scikit-learn numpy
```

---

## 📜 Citation

If you use this repository, please cite:

```bibtex
@article{Han2025,
  title     = {Data-driven insight into the universal structure–property relationship of catalysts in lithium–sulfur batteries},
  author    = {Han, Zhiyuan and Tao, Shengyu and Jia, Yeyang and Zhang, Mengtian and Ma, Ruifei and Xiao, Xiao and Zhou, Jiaqi and Gao, Runhua and Cui, Kai and Wang, Tianshuai and Zhang, Xuan and Zhou, Guangmin},
  journal   = {Journal of the American Chemical Society},
  year      = {2025},
  note      = {Accepted, in press}
}
```

---

## 📬 Contact

For questions or collaborations, please contact:

- [**Shengyu Tao**](mailto:sytao@berkeley.edu) or the corresponding authors.

---

## 📄 License

MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     
copies of the Software, and to permit persons to whom the Software is         
furnished to do so, subject to the following conditions:                      

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.                               

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
SOFTWARE.

