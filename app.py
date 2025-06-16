from flask import Flask, request, jsonify
import cv2
import numpy as np
import base64
import dlib
from scipy.spatial import distance
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Load dlib face detector and landmark predictor
face_detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")

def eye_aspect_ratio(eye):
    A = distance.euclidean(eye[1], eye[5])
    B = distance.euclidean(eye[2], eye[4])
    C = distance.euclidean(eye[0], eye[3])
    return (A + B) / (2.0 * C)

def mouth_aspect_ratio(mouth):
    A = distance.euclidean(mouth[2], mouth[10])  # vertical
    B = distance.euclidean(mouth[4], mouth[8])   # vertical
    C = distance.euclidean(mouth[0], mouth[6])   # horizontal
    return (A + B) / (2.0 * C)

@app.route('/')
def index():
    return "✅ Flask server is running. Use POST /detect with base64 image."
def smile_ratio(mouth):
    # mouth horizontal length
    width = distance.euclidean(mouth[0], mouth[6])
    # mouth vertical length (average of two vertical distances)
    height = (distance.euclidean(mouth[3], mouth[9]) + distance.euclidean(mouth[2], mouth[10])) / 2.0
    return width / height

@app.route('/detect', methods=['POST'])
@app.route('/detect', methods=['POST'])
def detect():
    try:
        data = request.json
        if 'image' not in data:
            return jsonify({"status": "error", "message": "No image key in request."}), 400

        image_data = base64.b64decode(data['image'])
        np_arr = np.frombuffer(image_data, np.uint8)
        img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

        if img is None:
            return jsonify({"status": "error", "message": "Invalid base64 image"}), 400

        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        faces = face_detector(gray)

        if len(faces) == 0:
            return jsonify({
                "status": "success",
                "drowsy": False,
                "face_detected": False,
                "message": "No face detected"
            })

        for face in faces:
            shape = predictor(gray, face)

            left_eye = np.array([(shape.part(i).x, shape.part(i).y) for i in range(36, 42)])
            right_eye = np.array([(shape.part(i).x, shape.part(i).y) for i in range(42, 48)])
            mouth = np.array([(shape.part(i).x, shape.part(i).y) for i in range(48, 68)])

            ear = (eye_aspect_ratio(left_eye) + eye_aspect_ratio(right_eye)) / 2.0
            mar = mouth_aspect_ratio(mouth)
            smile = smile_ratio(mouth)

            # Thresholds
            EAR_THRESHOLD = 0.20
            MAR_THRESHOLD = 0.55
            SMILE_THRESHOLD = 3.0

            is_yawning = float(mar) > MAR_THRESHOLD
            is_smiling = smile > SMILE_THRESHOLD
            is_eyes_closed = (float(ear) < EAR_THRESHOLD) and (not is_smiling)
            is_drowsy = is_eyes_closed or is_yawning

            return jsonify({
                "status": "success",
                "face_detected": True,
                "drowsy": bool(is_drowsy),
                "ear": float(round(ear, 3)),
                "mar": float(round(mar, 3)),
                "smile_ratio": float(round(smile, 3)),
                "eyes_closed": bool(is_eyes_closed),
                "yawning": bool(is_yawning),
                "smiling": bool(is_smiling)
            })

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
