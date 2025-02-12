import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress
import pandas as pd

# Define cross-sectional areas of bellows
area_large = 0.125  # Cross-sectional area of larger bellows (m^2)
area_small = 0.08   # Cross-sectional area of smaller bellows (m^2)

# Define correction factors based on module position
def get_correction_factors(module_index):
    if module_index < 2:  # First two modules have larger bellows
        return area_large, area_large, area_large
    else:  # Remaining modules have smaller bellows
        return area_small, area_small, area_small

# Function to calculate k_i coefficients for each module
def calculate_ki(pressure_diff, angles):
    """
    Perform linear regression to determine the k_i coefficient for a given module.

    Parameters:
        pressure_diff (numpy array): Array of pressure differences between bellow series.
        angles (numpy array): Array of deflection values.

    Returns:
        float: k_i coefficient (slope of regression line).
        dict: Regression details.
    """
    slope, intercept, r_value, p_value, std_err = linregress(pressure_diff, angles)
    regression_details = {
        "slope (k_i)": slope,
        "intercept": intercept,
        "r_value": r_value,
        "p_value": p_value,
        "std_err": std_err,
    }
    return slope, regression_details

# Experimental dataset for theta_x
data_x = pd.DataFrame({
    "p1": [0.50, 0.75, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 1.5, 1, 1, 2, 2, 3, 3, 3],
    "p2": [0.00, 0.00, 0.50, 0.75, 0.00, 0.00, 0.00, 1.50, 3, 0, 2, 2, 0, 1, 0, 0, 2],
    "p3": [0.00, 0.00, 0.00, 0.00, 0.50, 0.75, 1.50, 0.00, 0, 0, 1, 2, 2, 0, 0, 1, 1],
})

deflection_x = {
    "q1x": [3.26, 5.08, -1.93, -1.93, -7.12, -8.68, -13.36, -1.93, 7.16, 9.49, 4.82, 2.22, 11.31, 17.29, 20.15, 16.77, 9.75],
    "q2x": [5.76, 7.84, 0.57, 1.09, -3.32, -6.69, -12.92, 1.35, 1.35, 14.07, 1.87, -6.43, 1.09, 17.97, 21.86, 12.52, 15.37],
    "q3x": [-3.05, -3.05, -1.75, -2.27, -1.23, -0.71, -0.71, -2.53, -2.01, -2.79, -2.27, -2.27, -2.01, -2.79, 1.62, 0.84, -0.97],
    "q4x": [0.30, 1.08, 0.04, 0.04, -0.21, -0.73, -2.55, 0.04, 0.56, 3.1, 0.56, -1.25, 0.3, 4.47, 8.89, 5.77, 5.25],
    "q5x": [2.62, 3.40, 0.29, 0.55, -1.52, -2.82, -6.19, 0.55, 0.55, 6.25, 0.55, -2.81, 0.55, 8.59, 13, 7.55, 7.55],
    "q6x": [3.92, 4.94, 1.11, 1.88, -0.66, -2.19, -7.03, 2.13, 1.88, 9.02, 1.37, -3.72, 1.88, 12.07, 15.64, 9.53, 11.05],
    "q7x": [7.63, 9.42, 1.50, 2.26, -3.09, -5.91, -11.78, 1.75, 1.5, 13.51, 1.5, -4.63, 1.75, 15.55, 20.15, 11.46, 13]
}
data_x = data_x.assign(**deflection_x)

# Experimental dataset for theta_y
data_y = data_x.copy()
deflection_y = {
    "q1y": [-1.75, 5.08, 2.41, 4.76, -2.54, -3.84, -6.45, 10.5, 18.85, -5.14, 5.02, 1.63, -18.19, 0.85, -8.8, -16.36, -0.19],
    "q2y": [-4.55, 7.84, 6.44, 8.49, -3.79, -4.55, -8.65, 14.12, 22.31, -8.65, 7.98, 4.39, -20.93, 3.11, -13, -18.63, 1.58],
    "q3y": [-0.21, -3.05, -3.12, -3.39, -0.21, -0.47, -0.74, -2.33, 2.7, -1, -1.53, -1.8, -0.74, -4.44, -3.12, -1.53, -2.59],
    "q4y": [-1.65, 1.08, 0.70, 0.70, -1.12, -1.12, -2.43, 2.53, 8.29, -3.22, 1.22, 0.44, -6.36, -1.38, -6.62, -6.62, -1.12],
    "q5y": [-0.90, 3.40, 2.67, 3.69, -0.65, -0.90, -2.70, 7.53, 15.21, -3.46, 4.72, 3.18, -9.35, 1.13, -6.79, -8.84, 0.62],
    "q6y": [-3.63, 4.94, 1.45, 3.48, -4.39, -4.64, -7.19, 8.82, 16.69, -7.69, 5, 2.21, -15.83, -0.32, -11.76, -15.06, -0.83],
    "q7y": [-4.49, 9.40, 4.35, 7.22, -5.54, -5.80, -8.92, 13.21, 20.24, -8.4, 6.96, 3.31, -17.52, 0.44, -10.75, -15.69, -0.59]
}
data_y = data_y.assign(**deflection_y)

# Compute k_ix coefficients
kix_results = {}
for idx, q in enumerate(["q1x", "q2x", "q3x", "q4x", "q5x", "q6x", "q7x"]):
    c_A, c_B, _ = get_correction_factors(idx)
    pressure_diff_x = c_A * data_x["p1"] - c_B * data_x["p2"]
    kix, details = calculate_ki(pressure_diff_x, data_x[q])
    kix_results[q] = details

# Compute k_iy coefficients
kiy_results = {}
for idx, q in enumerate(["q1y", "q2y", "q3y", "q4y", "q5y", "q6y", "q7y"]):
    c_A, _, c_C = get_correction_factors(idx)
    pressure_diff_y = c_A * data_y["p1"] - c_C * data_y["p3"]
    kiy, details = calculate_ki(pressure_diff_y, data_y[q])
    kiy_results[q] = details

# Display results
df_kix = pd.DataFrame.from_dict(kix_results, orient='index')
df_kiy = pd.DataFrame.from_dict(kiy_results, orient='index')

# Display results
print("kix Coefficients:")
print(pd.DataFrame.from_dict(kix_results, orient='index'))
print("\nkiy Coefficients:")
print(pd.DataFrame.from_dict(kiy_results, orient='index'))