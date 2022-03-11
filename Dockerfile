FROM python:3-slim
RUN pip install pyshacl==0.18.1

WORKDIR /usr/src/app
COPY entrypoint.sh .
COPY test ./test

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
