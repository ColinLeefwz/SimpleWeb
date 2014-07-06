
官网 http://www.apsis.ch/pound

openssl req -x509 -newkey rsa:1024 -keyout test.pem -out test.pem -days 365 -nodes
pound -f pound.test.cfg


