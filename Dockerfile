# Langflow
# Author: Gary A. Stafford
# Date: 2023-07-31
# docker build -t garystafford/langflow:0.3.3 .

FROM python:3.10-slim

LABEL name="langflow" \
    version="v0.3.3" \
    maintainer="Gary A. Stafford"

ENV PIP_DEFAULT_TIMEOUT=100 \
    # allow statements and log messages to immediately appear
    PYTHONUNBUFFERED=1 \
    # disable a pip version check to reduce run-time & log-spam
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    # cache is useless in docker image, so disable to reduce image size
    PIP_NO_CACHE_DIR=1 \
    # set home
    HOME=/home/appuser \
    PATH=/home/appuser/.local/bin:$PATH

COPY requirements.txt .

RUN set -ex \
    # create a non-root user to run langflow
    && groupadd --system --gid 1001 appgroup \
    && useradd --system --uid 1001 --gid 1001 --create-home appuser \
    # upgrade the package index and install security upgrades
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    gcc g++ git make \
    # install dependencies
    && langflow==0.3.3 -U --user \
    # clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $HOME/

EXPOSE 7860

CMD ["python", "-m", "langflow", "--host", "0.0.0.0", "--port", "7860"]

# set the user to run langflow
USER appuser
