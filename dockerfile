FROM debian:latest

RUN apt update
RUN apt install -y nano
RUN touch hello.txt

CMD ["tail", "-f", "/dev/null"]
