# cachain
Create a CA chain with reasonable openssl configurations

I've spent many years either using the "Jamie Linux" instructions myself to create a reasonable CA structure for various different projects, or sending other people the link and suggesting they follow these instructions.

The `create-ca.sh` script uses those instructions to lead someone through creating a CA hierarchy that can be validated, and can produce reasonable X509 certificates.

The script is run simply with `./create-ca.sh`

Currently, it uses the RSA defaults from the original Jamie Linux instructions. Over time, I will probably make it prompt the user for other cryptosystems (e.g. ed25519) and give those reasonable defaults too. 
