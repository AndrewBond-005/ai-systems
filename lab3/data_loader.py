
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


def load_data(path: str) -> pd.DataFrame:
    return pd.read_csv(path)


def describe_manual(df: pd.DataFrame) -> pd.DataFrame:
    numeric_df = df.select_dtypes(include=[np.number])
    rows = []
    for col in numeric_df.columns:
        values = numeric_df[col].values
        n = len(values)
        mean = values.sum() / n
        var = ((values - mean) ** 2).sum() / (n - 1)
        std = np.sqrt(var)
        rows.append({
            'column': col,
            'count': n,
            'mean': mean,
            'std': std,
            'min': values.min(),
            '25%': np.percentile(values, 25),
            '50%': np.percentile(values, 50),
            '75%': np.percentile(values, 75),
            'max': values.max(),
        })
    return pd.DataFrame(rows)


def correlation_manual(df: pd.DataFrame) -> pd.DataFrame:

    numeric_df = df.select_dtypes(include=[np.number])
    cols = list(numeric_df.columns)
    k = len(cols)
    corr = np.zeros((k, k))

    for i in range(k):
        x = numeric_df[cols[i]].values
        x_centered = x - x.sum() / len(x)
        for j in range(k):
            y = numeric_df[cols[j]].values
            y_centered = y - y.sum() / len(y)
            numerator = (x_centered * y_centered).sum()
            denominator = np.sqrt((x_centered ** 2).sum() * (y_centered ** 2).sum())
            corr[i, j] = numerator / denominator if denominator != 0 else 0.0

    return pd.DataFrame(corr, index=cols, columns=cols)


def print_dataframe(df: pd.DataFrame, title: str = ""):

    if title:
        print(title)
    header = "  ".join(f"{str(c):>12}" for c in df.columns)
    print(header)
    print("-" * len(header))
    for _, row in df.iterrows():
        line = "  ".join(f"{v:>12.2f}" if isinstance(v, (int, float, np.floating)) else f"{str(v):>12}"
                         for v in row.values)
        print(line)


def show_statistics(df: pd.DataFrame):
    total_missing = int(df.isnull().sum().sum())
    if total_missing == 0:
        print("\nПропусков нет.")
    else:
        print(f"\nВсего пропусков: {total_missing}")
        print(df.isnull().sum())

    if 'Extracurricular Activities' in df.columns:
        print("\nРаспределение Extracurricular Activities:")
        vc = df['Extracurricular Activities'].value_counts()
        for val, cnt in vc.items():
            print(f"  {val}: {cnt}")

    print("\nОписательная статистика:")
    desc = describe_manual(df)
    desc_display = desc.set_index('column')
    print_dataframe(desc_display)

    print("\nМатрица корреляции:")
    corr = correlation_manual(df)
    print_dataframe(corr)


def visualize_data(df: pd.DataFrame, out_dir: str = "plots"):
    os.makedirs(out_dir, exist_ok=True)

    numeric_cols = df.select_dtypes(include=[np.number]).columns

    fig = df[numeric_cols].hist(figsize=(12, 10), bins=20, edgecolor='black')
    plt.suptitle("Распределение числовых признаков", fontsize=16)
    plt.tight_layout()
    path = os.path.join(out_dir, "histograms.png")
    plt.savefig(path, dpi=100)
    plt.close()

    corr = correlation_manual(df)
    fig, ax = plt.subplots(figsize=(8, 6))
    im = ax.imshow(corr.values, cmap='coolwarm', vmin=-1, vmax=1)
    ax.set_xticks(range(len(corr.columns)))
    ax.set_yticks(range(len(corr.columns)))
    ax.set_xticklabels(corr.columns, rotation=45, ha='right')
    ax.set_yticklabels(corr.columns)
    plt.colorbar(im)
    plt.title("Матрица корреляции")
    plt.tight_layout()
    path = os.path.join(out_dir, "correlation.png")
    plt.savefig(path, dpi=100)
    plt.close()

    target = 'Performance Index'
    if target in df.columns:
        features = [c for c in numeric_cols if c != target]
        fig, axes = plt.subplots(1, len(features), figsize=(4 * len(features), 4))
        if len(features) == 1:
            axes = [axes]
        for ax, col in zip(axes, features):
            ax.scatter(df[col], df[target], alpha=0.3, s=10)
            ax.set_xlabel(col)
            ax.set_ylabel(target)
            ax.set_title(f"{target} vs {col}")
        plt.tight_layout()
        path = os.path.join(out_dir, "scatter_target_vs_features.png")
        plt.savefig(path, dpi=100)
        plt.close()

if __name__ == "__main__":
    df = load_data("Student_Performance.csv")
    show_statistics(df)
    visualize_data(df)