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
## Step 4 Add feature in web image
**overwrite app.py**
```
from flask import Flask,render_template
app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/new')
def new():
    return render_template('newfeature.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```
**Create newfeature.html in templates folder and copy this in it.**
```
cd templates
touch newfeature.html
```
**copy this in newfeature.html**
```
<!DOCTYPE html>
<html>
  <head>
    <title>new feature!</title>
  </head>
  <body>
    <h1>New feature page.</h1>
    <a href="/">go back to home page!</a>
  </body>
</html>
```
**Rebuild and redeploy docker-compose.**
```
docker-compose up --build
```
**Output**<br />
![Screenshot (80)](https://user-images.githubusercontent.com/65711565/228295303-5da16a21-cd94-4ade-96fb-36e7f2fadb10.png)
![Screenshot (81)](https://user-images.githubusercontent.com/65711565/228295343-44518da4-78fa-447a-9b47-acdf96e66daf.png)
## step 5 add docker backup strategy
**update db service in docker-compose.yml file**
```
db:
    build: ./db
    ports:
      - "5432:5432"
    networks:
      - my_network
    volumes:
      - db_data:/var/lib/postgresql/data
```
**add this step in db dockerfile for backup strategy.**
```
#Create a backup of db_data
Run --rm -v db_data:/volume -v $(pwd):/backup alpine tar -czvf /backup/db-backup.tar.gz /volume
```
**Output**<br />
![Screenshot (82)](https://user-images.githubusercontent.com/65711565/228297138-30492bcc-0d74-42aa-88d3-b6f79dca663a.png)
## step 6 add scaling strategy for application
**update web service in docker-compose.yml**
```
services:
  web:
    build: .
    #8080-9090 this will alocate different port to every instance of web.
    ports:
      - "8080-8090:8080"
    depends_on:
      - db
    networks:
      - my_network
    environment:
      DATABASE_URL: postgres://myuser:mysecretpassword@db:5432/mydb
    #this will create multiple instance of web service
    deploy:
      replicas: 3
```
**now use up command to build containers.**
```
docker-compose up
```
**Or you scale dynamically in docker-compose command.**
```
docker-compose up --scale web=4
```
**logs**<br /><br />
![Screenshot (86)](https://user-images.githubusercontent.com/65711565/228299695-d4f93695-af26-4705-8f9b-ab1bdd00bdf2.png)
**output**<br /><br />
![Screenshot (87)](https://user-images.githubusercontent.com/65711565/228299844-3e5dd6cb-3b77-43dd-ba63-4f70129a438e.png)
## step 7 Add monitoring strategy for the application
**add grafana service in docker-compose.yml**
```
version: "3.9"
networks:
  my_network:
    driver: bridge

services:
  web:
    build: .
    #8080-9090 this will alocate different port to every instance of web.
    ports:
      - "8080-8090:8080"
    depends_on:
      - db
    networks:
      - my_network
    environment:
      DATABASE_URL: postgres://myuser:mysecretpassword@db:5432/mydb
    #this will create multiple instance of web service
    deploy:
      replicas: 3
  
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana


  db:
    build: ./db
    ports:
      - "5432:5432"
    networks:
      - my_network
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
  grafana-data:
```
**use up command to rebuild.**
```
docker-compose up --build --scale web=4
```
**logs**<br /><br />
![Screenshot (88)](https://user-images.githubusercontent.com/65711565/228301431-2f2d81fc-a296-4639-8f33-39e6b7c3c940.png)
**output**<br />
![Screenshot (90)](https://user-images.githubusercontent.com/65711565/228301521-405f761f-f07c-42a9-ae4b-357928d6a435.png)
 
 ## Step 8 push the codebase to github
 **use these command to push codebase.**
 ```
 git init
 git remote set-url origin https://github.com/abdulmoiz14/Part5.git
 git remote -v
 git add --all
 git commit -m "update codebase"
 git push -f -u origin main
 ```
