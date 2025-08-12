ARG DEBIAN_DIST=bookworm
FROM debian:bookworm

ARG DEBIAN_DIST
ARG uv_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/uv
RUN mkdir -p /output/DEBIAN

COPY uv-x86_64-unknown-linux-musl/* /output/usr/bin/
COPY output/DEBIAN/control /output/DEBIAN/
COPY output/copyright /output/usr/share/doc/uv/
COPY output/changelog.Debian /output/usr/share/doc/uv/
COPY output/README.md /output/usr/share/doc/uv/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/uv/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/uv/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/uv_VERSION/$uv_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control

RUN dpkg-deb --build /output /uv_${FULL_VERSION}.deb
