#!/usr/bin/bash

while read -ep "Path for root CA [${PWD}/rootca]:" rootcadir </dev/tty; do
    rootcadir=${rootcadir:-${PWD}/rootca}
    if [ -d "${rootcadir}" ]; then
         echo "${file_dir} already exists - please enter a valid directory path."
    else
	echo "Creating... $rootcadir"
        mkdir -p "${rootcadir}"
	mkdir -p "${rootcadir}/certs"
	mkdir -p "${rootcadir}/crl"
	mkdir -p "${rootcadir}/newcerts"
	mkdir -p "${rootcadir}/private"
	chmod 700 "${rootcadir}/private"
	touch "${rootcadir}/index.txt"
	echo 1000 > "${rootcadir}/serial"
	# substitute the $rootcadir value into the template file
	envsubst < root_openssl.cnf > ${rootcadir}/openssl.cnf
	echo "Generating a 4096 bit RSA key for CA"
	openssl genrsa -aes256 -out "${rootcadir}/private/ca.key.pem" 4096

	# self-sign a cert with the new key
	openssl req -config ${rootcadir}/openssl.cnf \
		-key ${rootcadir}/private/ca.key.pem \
		-new -x509 -days 7300 -sha256 -extensions v3_ca \
		-out ${rootcadir}/certs/ca.cert.pem
        break
    fi 
done

while read -ep "Path for INTERMEDIATE CA [${PWD}/interca]:" intercadir </dev/tty; do
    intercadir=${intercadir:-${PWD}/interca}
    if [ -d "${intercadir}" ]; then
         echo "${file_dir} already exists - please enter a valid directory path."
    else
	echo "Creating... $intercadir"
        mkdir -p "${intercadir}"
	mkdir -p "${intercadir}/certs"
	mkdir -p "${intercadir}/crl"
	mkdir -p "${intercadir}/newcerts"
	mkdir -p "${intercadir}/private"
	chmod 700 "${intercadir}/private"
	touch "${intercadir}/index.txt"
	echo 1000 > "${intercadir}/serial"
	# substitute the $intercadir value into the template file
	envsubst < inter_openssl.cnf > ${intercadir}/openssl.cnf
	echo "Generating a 4096 bit RSA key for CA"
	openssl genrsa -aes256 -out "${intercadir}/private/ca.key.pem" 4096

	# sign a cert with the ROOT key
	openssl req -config ${rootcadir}/openssl.cnf \
		-key ${intercadir}/private/ca.key.pem \
		-new -x509 -days 7300 -sha256 -extensions v3_ca \
		-out ${intercadir}/certs/ca.cert.pem
        break
    fi 
done
