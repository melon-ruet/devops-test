FROM python:3.8

RUN pip install mysql-connector-python flask

WORKDIR /app
COPY app.py /app

ENTRYPOINT ["python"]
CMD ["app.py"]