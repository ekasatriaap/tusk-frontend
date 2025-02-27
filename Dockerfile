FROM instrumentisto/flutter:3.27

RUN apt-get update && apt-get install -y \
    git unzip wget curl xz-utils libglu1-mesa \
    android-tools-adb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 8081 5353

CMD ["/bin/bash"]