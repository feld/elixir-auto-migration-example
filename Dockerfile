FROM elixir:1.12-alpine as build

COPY . .

ENV MIX_ENV=prod

RUN echo "http://nl.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories &&\
	apk update &&\
	apk add git &&\
	mix local.hex --force &&\
	mix local.rebar --force &&\
	mix deps.get --only prod &&\
        mix phx.digest &&\
	mkdir release &&\
	mix release --path release

FROM alpine:3.14

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="ops@your.domain" \
    org.opencontainers.image.title="Example project" \
    org.opencontainers.image.description="Example description" \
    org.opencontainers.image.authors="ops@your.domain" \
    org.opencontainers.image.vendor="your.domain" \
    org.opencontainers.image.documentation="https://your.gitlab/groupname/example" \
    org.opencontainers.image.url="https://your.gitlab/groupname/example" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE

ARG HOME=/opt/example

RUN echo "http://nl.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories &&\
        apk update &&\
        apk add libgcc libstdc++ ncurses-libs postgresql-client &&\
	adduser --system --shell /bin/false --home ${HOME} example

USER example

COPY --from=build --chown=example:0 /release ${HOME}

COPY ./docker-entrypoint.sh ${HOME}

EXPOSE 4000

ENTRYPOINT ["/opt/example/docker-entrypoint.sh"]
