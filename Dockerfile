FROM python:3-slim
RUN pip install pyshacl==0.18.1
COPY entrypoint.sh .
COPY test ./test

ENTRYPOINT ["./entrypoint.sh"]
