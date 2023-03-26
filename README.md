# Part5
## step 1
**Create a flask python app which show Hello, World! massage.**
```
nano app.py
```
**Write this in app.py.**
```
from flask import Flask,render_template
app = Flask(__name__)
@app.route('/')
def hello_world():
    return render_template('index.html')


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```
**Create requirements.txt and write dependencies.**
```
Flask
```
**Create templates folder and create index.html in it, then write this text in it**
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Index page</title>
</head>
<body>
<h1>Hello, World!</h1>
</body>
</html>
```
**now create a dockerfile for web.**
```
nano dockerfile
```
**Write this text in dockerfile.**
```
FROM python:3.8-slim-buster
LABEL maintainer = "abdulmoiz1443@gmail.com"
WORKDIR /

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . /

EXPOSE 8080

CMD ["python", "app.py"]
```
## step 2
**now create db folder and create a dockerfile for database in it.**
```
FROM postgres:13-alpine

ENV POSTGRES_PASSWORD=mysecretpassword
ENV POSTGRES_USER=myuser
ENV POSTGRES_DB=mydb


EXPOSE 5432
```
## step 3
**Now create a docker compose file where the app.py exist and paste this text in it.**
```
version: "3.9"
networks:
  my_network:
    driver: bridge

services:
  web:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
    networks:
      - my_network
    environment:
      DATABASE_URL: postgres://myuser:mysecretpassword@db:5432/mydb

  db:
    build: ./db
    ports:
      - "5432:5432"
    networks:
      - my_network

```
**use docker compose command to build and run the application.**
```
docker-compose up
```
**Web application output**<br />
![Screenshot (78)](https://user-images.githubusercontent.com/65711565/227806885-1f2eb091-120a-419c-9640-d18f5455b65d.png)

**Database Output**<br />
![Screenshot (76)](https://user-images.githubusercontent.com/65711565/227806587-1d9fd91a-43d6-4898-8cce-7e7b117dcc37.png)

**use command to inspect network of part5_my_network**
```
docker network inspect part_my_network
```
**output**<br />
![Screenshot (79)](https://user-images.githubusercontent.com/65711565/227807084-19e672f5-9d53-47aa-8094-25bb8956c16e.png)
