ARG UBUNTU_VERSION=22.04
FROM --platform=$BUILDPLATFORM ubuntu:$UBUNTU_VERSION AS build

#original Dockerfile which is currently not working;
#https://github.com/ggml-org/llama.cpp/blob/master/.devops/cpu.Dockerfile

#https://www.jeffgeerling.com/blog/2024/llms-accelerated-egpu-on-raspberry-pi-5
# Install dependencies: Vulkan SDK, glslc, cmake, and curl dev library
RUN apt-get update && \
    apt-get install -y build-essential git cmake libcurl4-openssl-dev wget

RUN wget -qO- https://packages.lunarg.com/lunarg-signing-key-pub.asc | tee /etc/apt/trusted.gpg.d/lunarg.asc
RUN wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list http://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list
RUN apt-get update && \
    apt-get install -y vulkan-sdk

# Clone llama.cpp
RUN git clone https://github.com/ggml-org/llama.cpp /src
WORKDIR /src

# Build with Vulkan support (for Cuda, someday, `-DGGML_CUDA=1`
RUN cmake -B build -DGGML_VULKAN=1
RUN cmake --build build --config Release

FROM build AS final

COPY --from=build /src/build /app

#./build/bin/llama-cli -m "models/Llama-3.2-3B-Instruct-Q4_K_M.gguf" -p "Why is the blue sky blue?" -no-cnv -e -ngl 100 -t 4

ENTRYPOINT [ "/app/llama-cli" ]