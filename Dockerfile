FROM python:3.9

WORKDIR /personal_website

EXPOSE 5000

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt


COPY . .

CMD [ "python3", "main.py", "-m" , "flask", "run", "--host", "0.0.0.0"]