#!/bin/bash
set -e

TARGET_PKG="docker-compose"
missing_dependencies=('dockercompose')

all_missing_dependencies=()

pending_missing_deps=()

already_processed_deps=()

#Packages dependencies lists..
dockercompose_deps=("cached-property" "docker" "dockerpty" "docopt" "jsonschema" "requests" "setuptools" "six" "texttable" "websocket-client" "yaml" "mock" "pytest-runner")

cached_property_deps=('setuptools' 'nose' 'mock' 'coverage' 'dateutil')

#dockerpty_deps=('setuptools' 'docker-py' 'six' 'git' 'pytest' 'expects')
dockerpty_deps=('setuptools' 'docker' 'six' 'git' 'pytest' 'expects')

docopt_deps=('setuptools')

texttable_deps=('cjkwrap' 'pytest')

websocket_client_deps=('setuptools' 'six')

LIGHT_RED='\033[1;31m'
BOLD_YELLOW='\033[01;33m'
NC='\033[0m' # No Color
message(){
	printf "${BOLD_YELLOW} $1  ${NC}\n"
}
question(){
	printf "${LIGHT_RED} $1  ${NC}\n"
}

function dep_is_processed(){
	local dep_to_check="$1"
	for miss_pkg in "${already_processed_deps[@]}"
    	do
		if [ "$miss_pkg" == "$dep_to_check" ]; then
			#La dependencia ya fue procesada...
			return 1
		fi	
    	done
	#Si no fue procesada...
	echo "${already_processed_deps[@]}"
	echo "Dep $1 not processed..."
	return 0
}

check_deps(){
#     missing_dependency=()
    eval DEPS_TO_CHECK=( \"\${${1}[@]}\" )
    for pkg in "${DEPS_TO_CHECK[@]}"
    do 
	    if dep_is_processed "$pkg" -eq 0; then
	    	message "Verificando dependencia [['$pkg']]"

		#Search the package with pacman. Temporally disable "exit" flag (-e) because pacman exit with 1 when the package doesnt exists...
		set +e
        	#pacman -Ss "$pkg"
		ccr -Ss "$pkg"
		set -e
        	

        	question "¿Existe la dependencia? [y/n]"
        	read exists_pkg
        	if [ "$exists_pkg" == "n" ]; then
            		pending_missing_deps+=("$pkg")	
       		fi
       		#Indicamos que la dependencia ya fue procesada, para no procesarla nuevamente en el futuro...
        	already_processed_deps+=("$pkg")
	else
		message "La dependencia [['$pkg']] ya fue procesada..."
	fi
    done

    message "Lista de paquetes no encontrados:"
    for miss_pkg in "${pending_missing_deps[@]}"
    do
        echo "$miss_pkg"
    done
    
}

check(){
	local var_key="`echo $1 | sed "s/-/_/g"`_deps"
    	message "Verificando dependencias del paquete $1..."
    	check_deps "$var_key"
}

continue="y"
while [ "$continue" == "y" ]
do

    	for missing_pkg in "${missing_dependencies[@]}"
    	do
        	check "$missing_pkg"
    	done

    	#Update the final dependencies missing in Chakra distribution repository
	all_missing_dependencies+=("${pending_missing_deps[@]}")

    	unset missing_dependencies
    	missing_dependencies=("${pending_missing_deps[@]}")
    	unset pending_missing_deps;
    	pending_missing_deps=()
    
    	question "¿Quiere revisar las dependencias de las dependencias faltantes? [y/n]"
    	read continue
done

#Informs about all missing dependencies, incluiding root dependencies and child dependencies of root missing dependencies
message "En total, estas son las dependencias faltantes para construir el paquete '$TARGET_PKG' correctamente"
all_missing_dependencies=( `echo "${all_missing_dependencies[@]}" | sort | uniq` )
for miss_pkg in "${all_missing_dependencies[@]}"
do
	echo "$miss_pkg"
done

question "¿Buscar paquetes en Arch/Linux package database?[y/n]"
read searchInArch
if [ "$searchInArch" == "y" ]; then
	for miss_pkg in "${all_missing_dependencies[@]}"
	do
		echo "https://www.archlinux.org/packages/?q=$miss_pkg"
	done
fi
