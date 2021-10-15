#!/bin/bash -e

echo 'Install tx-pi BASE'
sed -i -E 's;^#\s(de_DE.UTF-8.*);\1;g' /etc/locale.gen
sed -i -E 's;^#\s(en_US.UTF-8.*);\1;g' /etc/locale.gen
sed -i -E 's;^#\s(nl_NL.UTF-8.*);\1;g' /etc/locale.gen
sed -i -E 's;^#\s(fr_FR.UTF-8.*);\1;g' /etc/locale.gen

locale-gen
