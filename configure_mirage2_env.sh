#!/bin/bash
#Suponiendo que estamos parados en el raiz de DSpace...

#Login bash
LOGIN_CMD="/bin/bash --login"

RVM_START="source ~/.rvm/scripts/rvm"

RUBY_SET="rvm use ext-ruby-2.2.5-p319"

printf "\n***\n**\n*==================AYUDA=DE=CONFIGURACION==============================================\n|\n|\n"
printf "| Por favor, para instalar y configurar 'mirage2' ejecute los siguientes comandos:\n|\n"
printf "| 1.\n $LOGIN_CMD \n|\n"
printf "| 2.\n $RVM_START \n|\n"
printf "| 3.\n $RUBY_SET \n|\n"
printf "*======================================================================================\n**\n***\n"
