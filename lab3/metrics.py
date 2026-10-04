import numpy as np


def r_squared(y_true: np.ndarray, y_pred: np.ndarray) -> float:

    ss_res = ((y_true - y_pred) ** 2).sum()
    mean_y = y_true.sum() / len(y_true)
    ss_tot = ((y_true - mean_y) ** 2).sum()

    if ss_tot == 0:
        return 0.0

    return 1 - ss_res / ss_tot


def mse(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    return ((y_true - y_pred) ** 2).sum() / len(y_true)


def mae(y_true: np.ndarray, y_pred: np.ndarray) -> float:
    return np.abs(y_true - y_pred).sum() / len(y_true)