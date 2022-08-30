FROM python:3.9-alpine
LABEL maintainer="moncif.toubouh@pwc.com,iacine.herbadji@pwc.com"

# Define default workdir for the application
WORKDIR /app
COPY . .

# Install dependencies
RUN pip3 install -r ./requirements.txt

EXPOSE 80

# Start app flask
ENTRYPOINT [ "python3" ]
CMD [ "app.py" ]
