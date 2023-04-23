FROM ubuntu

WORKDIR /app

ENV RUNNER_ALLOW_RUNASROOT=true

ARG GHA_RUNNER_TOKEN
ARG GH_JWT_TOKEN
ARG GHA_RUNNER_DOWNLAOD_URL
ARG GH_REPO_URL

COPY ./StartRunner.sh ./

RUN apt update && apt install -y curl ca-certificates gnupg lsb-release \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && curl -o actions-runner.tar.gz -L -H "Authorization: Bearer ${GH_JWT_TOKEN}" ${GHA_RUNNER_DOWNLAOD_URL} \
    && tar xzf ./actions-runner.tar.gz && rm ./actions-runner.tar.gz \
    && bash -c ./bin/installdependencies.sh 2> /dev/null \
    && apt install -y docker-ce-cli && apt clean --dry-run \
    && chmod +x ./StartRunner.sh

CMD ["bash","-c","./StartRunner.sh"]
