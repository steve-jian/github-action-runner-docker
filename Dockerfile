FROM ubuntu

WORKDIR /app


RUN apt update && apt install -y curl build-essential dotnet-sdk-6.0

ENV RUNNER_ALLOW_RUNASROOT=true

ARG GHA_RUNNER_TOKEN
ARG GHA_RUNNER_JWT_TOKEN
ARG GHA_RUNNER_DOWNLAOD_URL
ARG GH_REPO_URL

COPY ./StartRunner.sh /app/StartRunner.sh

RUN curl -o actions-runner.tar.gz -L -H "Authorization: Bearer ${GHA_RUNNER_JWT_TOKEN}" ${GHA_RUNNER_DOWNLAOD_URL} \
    && tar xzf ./actions-runner.tar.gz \
    && curl -sSL https://get.docker.com/ | sh \
    && chmod +x /app/StartRunner.sh

CMD ["bash","-c","/app/StartRunner.sh"]

