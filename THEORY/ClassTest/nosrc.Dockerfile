FROM python:3.11.14-alpine3.23
WORKDIR /home/app
RUN pip install numpy
CMD ["python","app.py"]