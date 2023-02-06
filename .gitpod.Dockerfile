FROM gitpod/workspace-full

USER gitpod

RUN git clone https://github.com/flutter/flutter.git -b stable && \
  export PATH="$PATH:`pwd`/flutter/bin" && \
  flutter precache --web --no-android --no-ios