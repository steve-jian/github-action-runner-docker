FROM debian

WORKDIR /app

ENV RUNNER_ALLOW_RUNASROOT=true

ARG GHA_RUNNER_TOKEN
ARG GH_JWT_TOKEN
ARG GHA_RUNNER_DOWNLAOD_URL
ARG GH_REPO_URL

COPY ./StartRunner.sh ./

RUN apt update && apt install -y curl ca-certificates gnupg lsb-release \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && curl -o actions-runner.tar.gz -L -H "Authorization: Bearer ${GH_JWT_TOKEN}" ${GHA_RUNNER_DOWNLAOD_URL} \
    && echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && tar xzf ./actions-runner.tar.gz && rm ./actions-runner.tar.gz \
    && bash -c ./bin/installdependencies.sh 2> /dev/null \
    && apt install -y docker-ce-cli && apt clean --dry-run \
    && chmod +x ./StartRunner.sh

CMD ["bash","-c","./StartRunner.sh"]
