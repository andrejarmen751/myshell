#!/bin/bash
source "$mod_colors"
clear
cyan
echo "Dig"
nocolor
yellow
echo "Consultar que IP tiene registrada un nombre DNS usando un servidor dns en concreto"
nocolor
echo "dig @172.30.112.118 masdatos-pre.masmovil.com +short"
yellow
echo "Consultar a servidores DNS para un dominio"
nocolor
echo "dig NS areacinco.es +short @1.1.1.1"
yellow
echo "Para obtener entradas segun tipo registro"
nocolor
yellow
echo "dig -t MX example.com +short"
nocolor
yellow
echo "DNS lookup"
nocolor
yellow
echo "dig -x 1.1.1.1 +short"
nocolor
yellow
echo "Tipos entradas"
nocolor
yellow
echo "A, AAAA, CNAME, TXT, MX, NS, SOA, PTR"
nocolor
