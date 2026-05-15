from flask import Flask, request, jsonify
import pandas as pd
import pickle

app = Flask(__name__)

# Load model and encoders
model = pickle.load(open("career_model.pkl", "rb"))
encoders = pickle.load(open("encoders.pkl", "rb"))
target_encoders = pickle.load(open("target_encoders.pkl", "rb"))

# Feature order (MUST match training)
FEATURE_COLUMNS = [
    "ol_mathamatics",
    "ol_science",
    "ol_english",
    "al_stream",
    "interest_type",
    "personal_skill_score",
    "aptitude_test_score",
    "personality_type"
]

# Target order (MUST match training)
TARGET_COLUMNS = [
    "career_category",
    "recommended_career_1",
    "recommended_career_2",
    "recommended_career_3"
]


@app.route("/")
def home():
    return "API is working"


@app.route("/predict", methods=["POST"])
def predict():
    try:
        user_input = request.json
        print("\n==============================")
        print("RAW INPUT:", user_input)

        # Create dataframe in correct order
        df = pd.DataFrame([[user_input.get(col, None) for col in FEATURE_COLUMNS]],
                          columns=FEATURE_COLUMNS)

        print("BEFORE ENCODING:\n", df)

        # Encode safely
        for col in FEATURE_COLUMNS:
            if col in encoders:
                value = df[col].values[0]

                print(f"\nProcessing {col}")
                print("Received:", value)
                print("Expected:", list(encoders[col].classes_))

                if value not in encoders[col].classes_:
                    return jsonify({
                        "error": f"Invalid value for {col}: {value}",
                        "expected_values": list(encoders[col].classes_)
                    }), 400

                df[col] = encoders[col].transform(df[col])

        print("\nAFTER ENCODING:\n", df)

        # Predict
        y_pred = model.predict(df)[0]
        print("\nRAW PREDICTION:", y_pred)

        response = {}

        used_indices = set()   # ✅ FIX: prevent duplicate careers
        used_values = set()

        # Decode outputs safely
        for i, col in enumerate(TARGET_COLUMNS):
            encoder = target_encoders[col]

            # round prediction safely
            index = int(round(y_pred[i]))

            # keep index in valid range
            index = max(0, min(index, len(encoder.classes_) - 1))

            decoded_value = encoder.inverse_transform([index])[0]

            # 🔴 FIX: ensure uniqueness
            attempts = 0
            while decoded_value in used_values and attempts < len(encoder.classes_):
                index = (index + 1) % len(encoder.classes_)
                decoded_value = encoder.inverse_transform([index])[0]
                attempts += 1

            used_values.add(decoded_value)
            used_indices.add(index)

            response[col] = decoded_value

        print("\nFINAL RESPONSE (DEDUPED):", response)
        print("==============================\n")

        return jsonify(response)

    except Exception as e:
        print("ERROR:", e)
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)