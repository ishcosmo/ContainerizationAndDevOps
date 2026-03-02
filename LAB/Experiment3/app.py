from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>NAME: Ishita</h1><p>SAP ID: 500119435</p><p>Lab: Containerization & DevOps</p>"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)