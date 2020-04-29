# Dockerfile
FROM docker.repository.cloudera.com/cdsw/engine:8
# copy workdir
WORKDIR /app
COPY app /app
RUN apt-get update
RUN sh cdsw-build.sh
CMD ["python3","app.py"]
