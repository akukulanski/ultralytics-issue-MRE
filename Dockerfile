FROM python:3.9

RUN pip install --upgrade pip && pip install ultralytics

RUN apt-get update && \
    apt-get install -y ffmpeg libsm6 libxext6 libgl1 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /workdir

CMD ["bash"]
