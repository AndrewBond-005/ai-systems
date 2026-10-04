from data_loader import load_data, show_statistics, visualize_data
from preprocessing import prepare_data
from regression import fit_linear_regression, predict, print_coefficients
from metrics import r_squared, mse, mae


def build_model(X_train, y_train, X_test, y_test, feature_names, model_name):

    print(f"МОДЕЛЬ: {model_name}")
    print(f"Признаки: {feature_names}")

    B = fit_linear_regression(X_train, y_train)

    print("Коэффициенты:")
    print_coefficients(B, feature_names)

    y_pred_train = predict(X_train, B)
    y_pred_test = predict(X_test, B)

    r2_train = r_squared(y_train, y_pred_train)
    r2_test = r_squared(y_test, y_pred_test)
    mse_test = mse(y_test, y_pred_test)
    mae_test = mae(y_test, y_pred_test)

    print(f"\nR^2 на train: {r2_train:.4f}")
    print(f"R^2 на test:  {r2_test:.4f}")
    print(f"MSE на test:  {mse_test:.4f}")
    print(f"MAE на test:  {mae_test:.4f}")

    return B, y_pred_test, {
        'r2_train': r2_train,
        'r2_test': r2_test,
        'mse_test': mse_test,
        'mae_test': mae_test,
    }


def main():
    df = load_data("Student_Performance.csv")

    show_statistics(df)
    visualize_data(df, out_dir="plots")

    X_train, y_train, X_test, y_test, feature_cols = prepare_data(df)


    print(f"Размер train: {X_train.shape}")
    print(f"Размер test:  {X_test.shape}")
    print(f"Признаки: {feature_cols}")

    idx = {name: i for i, name in enumerate(feature_cols)}

    features_1 = ['Hours Studied', 'Previous Scores']
    idx_1 = [idx[f] for f in features_1]
    B1, pred1, metrics1 = build_model(
        X_train[:, idx_1], y_train,
        X_test[:, idx_1], y_test,
        features_1, "Модель 1: базовые признаки"
    )

    features_2 = ['Hours Studied', 'Previous Scores',
                  'Sleep Hours', 'Sample Question Papers Practiced']
    idx_2 = [idx[f] for f in features_2]
    B2, pred2, metrics2 = build_model(
        X_train[:, idx_2], y_train,
        X_test[:, idx_2], y_test,
        features_2, "Модель 2: + сон и пробные работы"
    )

    features_3 = feature_cols
    B3, pred3, metrics3 = build_model(
        X_train, y_train,
        X_test, y_test,
        features_3, "Модель 3: все признаки"
    )

    print("СРАВНЕНИЕ МОДЕЛЕЙ (R^2 на тестовой выборке)")
    print(f"Модель 1: {metrics1['r2_test']:.4f}")
    print(f"Модель 2: {metrics2['r2_test']:.4f}")
    print(f"Модель 3: {metrics3['r2_test']:.4f}")

    print("БОНУС: СИНТЕТИЧЕСКИЙ ПРИЗНАК")

    df_synth = df.copy()
    df_synth['Extracurricular Activities'] = df_synth['Extracurricular Activities'].map(
        {'Yes': 1, 'No': 0}
    )
    df_synth['Study_x_Prev'] = df_synth['Hours Studied'] * df_synth['Previous Scores']
    X_train_s, y_train_s, X_test_s, y_test_s, feature_cols_s = prepare_data(df_synth)
    B4, pred4, metrics4 = build_model(
        X_train_s, y_train_s,
        X_test_s, y_test_s,
        feature_cols_s, "Модель 4: все + синтетический"
    )
    print("ИТОГОВОЕ СРАВНЕНИЕ")
    print("=" * 60)
    print(f"Модель 1 (базовая):           R^2 = {metrics1['r2_test']:.4f}")
    print(f"Модель 2 (+сон, +пробные):    R^2 = {metrics2['r2_test']:.4f}")
    print(f"Модель 3 (все):               R^2 = {metrics3['r2_test']:.4f}")
    print(f"Модель 4 (+синтетический):    R^2 = {metrics4['r2_test']:.4f}")

if __name__ == "__main__":
    main()