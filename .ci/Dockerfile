# ZenWeather CI 构建镜像
# 基于 Flutter stable 官方镜像，预装 Linux 桌面构建所需依赖，
# 避免 tag_push 每次构建重复 apt-get install。
FROM ghcr.io/cirruslabs/flutter:stable

# 安装 Linux 桌面构建依赖（clang/cmake/ninja/pkg-config/GTK3 等）
RUN apt-get update && apt-get install -y --no-install-recommends \
      clang \
      cmake \
      ninja-build \
      pkg-config \
      libgtk-3-dev \
      liblzma-dev \
      libstdc++-12-dev \
    && rm -rf /var/lib/apt/lists/*
