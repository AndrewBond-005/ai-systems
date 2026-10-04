import numpy as np


def add_intercept(X: np.ndarray) -> np.ndarray:
    n_samples = X.shape[0]
    ones = np.ones((n_samples, 1))
    return np.hstack([ones, X])


def fit_linear_regression(X: np.ndarray, y: np.ndarray) -> np.ndarray:
    X_with_ones = add_intercept(X)

    XTX = X_with_ones.T @ X_with_ones

    XTX_inv = np.linalg.inv(XTX)

    XTy = X_with_ones.T @ y

    B = XTX_inv @ XTy

    return B


def predict(X: np.ndarray, B: np.ndarray) -> np.ndarray:
    X_with_ones = add_intercept(X)
    return X_with_ones @ B


def print_coefficients(B: np.ndarray, feature_names: list):

    print("  Свободный член (intercept): {:.4f}".format(B[0]))
    for name, coef in zip(feature_names, B[1:]):
        print(f"  {name}: {coef:.4f}")