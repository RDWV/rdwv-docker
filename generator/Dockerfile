FROM python:3.11-alpine
LABEL org.rdwv.image=docker-compose-generator
COPY . /app/generator
WORKDIR /app
RUN pip3 install -r generator/requirements.txt
ENTRYPOINT [ "python3", "-m", "generator"]
