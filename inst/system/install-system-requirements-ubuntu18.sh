#!/bin/bash

# R packages system requirements detection: https://docs.rstudio.com/rspm/admin/appendix/system-dependency-detection/
# sudo /opt/rstudio-pm/bin/rspm list requirements --repo=cran --packages=testthat,knitr,haven,readr,readxl,ssh,sys,mongolite,dplyr,dbplyr,DBI,RMariaDB,RPostgres,sparklyr,RPresto,nodbi,rmarkdown --distribution=ubuntu --release=18.04

echo
echo curl requirements:
apt-get install libcurl4-openssl-dev libssl-dev

echo
echo xml2 requirements:
apt-get install libxml2-dev

echo
echo ssh requirements:
apt-get install libssh2-1-dev

echo
echo openssl requirements:
apt-get install libssl-dev

echo
echo mongolite requirements:
apt-get install libssl-dev libsasl2-dev

echo
echo stringi requirements:
apt-get install libicu-dev

echo
echo RMariaDB requirements:
apt-get install libmysqlclient-dev mysql-server

echo
echo data.table requirements:
apt-get install zlib1g-dev

echo
echo RPostgres requirements:
apt-get install libpq-dev
