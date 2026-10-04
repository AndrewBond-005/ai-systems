import pandas as pd
import numpy as np


def encode_categorical(df, column):
    df = df.copy()
    if column not in df.columns:
        return df
    unique_vals = set(df[column].dropna().unique())
    if unique_vals.issubset({0, 1}):
        return df
    df[column] = df[column].map({'Yes': 1, 'No': 0})
    if df[column].isnull().any():
        raise ValueError(f"В столбце {column} есть значения, отличные от Yes/No")
    return df


def standardize_train_test(train_df: pd.DataFrame, test_df: pd.DataFrame,
                           feature_cols: list):

    train_norm = train_df.copy()
    test_norm = test_df.copy()

    for col in feature_cols:
        vals = train_df[col].values
        n = len(vals)

        mean = vals.sum() / n
        var = ((vals - mean) ** 2).sum() / (n - 1)
        std = np.sqrt(var)

        if std == 0:
            train_norm[col] = 0.0
            test_norm[col] = 0.0
        else:
            train_norm[col] = (train_df[col] - mean) / std
            test_norm[col] = (test_df[col] - mean) / std

    return train_norm, test_norm


def train_test_split_manual(df: pd.DataFrame, test_size: float = 0.2,
                            random_state: int = 42):
    np.random.seed(random_state)
    n = len(df)
    indices = np.random.permutation(n)
    n_test = int(n * test_size)

    test_idx = indices[:n_test]
    train_idx = indices[n_test:]

    train_df = df.iloc[train_idx].reset_index(drop=True)
    test_df = df.iloc[test_idx].reset_index(drop=True)

    return train_df, test_df


def prepare_data(df: pd.DataFrame, target: str = 'Performance Index',
                 test_size: float = 0.2, random_state: int = 42):

    df = encode_categorical(df, 'Extracurricular Activities')

    train_df, test_df = train_test_split_manual(df, test_size, random_state)

    feature_cols = [c for c in df.columns if c != target]
    train_norm, test_norm = standardize_train_test(train_df, test_df, feature_cols)

    X_train = train_norm[feature_cols].values
    y_train = train_norm[target].values
    X_test = test_norm[feature_cols].values
    y_test = test_norm[target].values

    return X_train, y_train, X_test, y_test, feature_cols