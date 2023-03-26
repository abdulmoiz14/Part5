
FROM python:3.8-slim-buster
LABEL maintainer = "abdulmoiz1443@gmail.com"
WORKDIR /

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /

EXPOSE 5000

CMD ["python", "app.py", "--host=0.0.0.0"]
