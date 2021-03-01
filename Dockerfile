From rust:1.50

RUN rustup default nightly

WORKDIR /usr/app
COPY Cargo.toml Cargo.lock . 
RUN cargo build 

COPY . . 
EXPOSE 8001
CMD ["cargo", "run"]

