FROM rust:1.79 AS build
WORKDIR /app

RUN rustup target add x86_64-unknown-linux-musl

COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs \
    && cargo build --release --target x86_64-unknown-linux-musl \
    && rm -rf src

COPY src ./src
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=build /app/target/x86_64-unknown-linux-musl/release/vtfk-sid /vtfk-sid
ENTRYPOINT ["/vtfk-sid"]