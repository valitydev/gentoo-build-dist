#!/bin/sh

sed -i 's@^USE="@USE="-python_targets_python2_7 libressl curl_ssl_libressl -curl_ssl_openssl -openssl @g' /etc/portage/make.conf

mkdir -p /etc/portage/repos.conf
eselect repository enable libressl && \
emaint sync -a

emerge -uNDkbv --with-bdeps=y @world > /dev/null && \
emerge -C dev-libs/openssl dev-lang/python:2.7 dev-python/subprocess32 && \
emerge @preserved-rebuild  && revdep-rebuild -i && emerge -c
