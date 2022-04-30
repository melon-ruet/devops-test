import os

import mysql.connector
from flask import Flask

app = Flask(__name__)


def check_db_connection():
    try:
        db = mysql.connector.connect(
            host=os.environ.get("DB_ENDPOINT"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            database=os.environ.get("DB_NAME")
        )
        db.close()
        return "DB connection successful"
    except mysql.connector.Error as error:
        return str(error)


@app.route("/")
def test_db_connection():
    return check_db_connection()


if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=5000)
