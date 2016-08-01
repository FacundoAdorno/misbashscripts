#!/bin/bash
#Éste script busca las líneas duplicadas en un archivo.
#El esquema de invocación es el siguiente:
#	./duplicados.sh <nombre_archivo_buscar_duplicados> [<reemplazo_a_los_duplicados>]
#
#NOTA: actualmente, la opción del <reemplazo_a_los_duplicados> no está implementada.

#------------------------------ERROR_MSG----------------------------------------------
Error_msg(){
	echo "<<<-------------------------------------------------------------------->>>" 	
	echo "Se ha producido un ERROR. $1"
	echo "<<<-------------------------------------------------------------------->>>"	
	#Se termina con el código de ERROR 1.	
	exit 1
}

#Variable global
enable_debug_msg=0
#------------------------------DEBUG_MSG----------------------------------------------
Debug_msg(){	
	if [ $enable_debug_msg -eq 1 ]; then	
		echo "[[DEBUG:]] $1 [[:DEBUG]]";
	fi
}
#------------------------------ARCHIVO_DE_ACENTOS--------------------------------------
Archivo_de_acentos(){
	#Se crea un archivo de acentos
	acentos_file=/tmp/acentos
	#######Expresiones para reemplazar acentos
	echo -e 's/\xc3\xa1/a/g\ns/\xc3\xa9/e/g\ns/\xc3\xad/i/g\ns/\xc3\xb3/o/g\ns/\xc3\xba/u/g\ns/\xc3\x81/A/g\ns/\xc3\x89/E/g\ns/\xc3\x8d/I/g\ns/\xc3\x93/O/g\ns/\xc3\x9a/U/g' > $acentos_file
}

#------------------------------RESETEAR_POSICION_PARAMETROS----------------------------
resetear_posicion_parametros(){
	#Si sale del bucle sin encontrar el "-h", entonces actualizo el indice del arreglo de parametro a la PRIMERA POSICIÓN	
	export OPTIND=1
}
#------------------------------PROCESAR_TEXTO----------------------------------------------
Procesar_texto(){
	#Se parsean los parámetros del procedimiento.
	resetear_posicion_parametros	
	local original_receptor
	local derived_receptor
	#flags
	local procesarLinea=0
	local process_files=0
	#this function will process options?
	local enable_options=1	
	local enable_file_original=0
	local enable_file_derived=0
	local enable_debug=0
	local sed_filter="\"|-|:|\/|:|\.| |'|\(|\)|,|;|\¿|\?|\*|“|”|«|<|>|<([a-z]|[0-9])*>|\[|\]|’|º|\x60|\x5C\|_|\{|\}"	
	#Buscar_flag_de_archivo
	while getopts ':Nfo:d:debug' OPCION; do		
		case $OPCION in
			N)
				enable_options=0
				#Se espera que el segundo parámetro sea la línea a procesar.
				Debug_msg "NO Se habilitan el paso de OPCIONES a la función \"Procesar texto\""
			;;
			f)
				#Entonces los objetos a procesar son archivos.
				process_files=1
				;;
		esac
	done
	resetear_posicion_parametros
	if [ $enable_options -eq 1 ]; then	
		if [ $process_files -eq 1 ]; then
			#getopts es una función que itera y busca ciertos parámetros pasados al script
			while getopts ':Nfo:d:debug' OPCION; do
				case $OPCION in
					#original-file
					f)
						;;				
					o)
						#Este es el archivo original a procesar, pasado como parametro.
						original_receptor=$OPTARG
						enable_file_original=1			
						;;			
					#derived-file			
					d)
						#Este es el archivo donde se guardará el resultado final luego de procesar.
						derived_receptor=$OPTARG
						enable_file_derived=1
						;;
					debug)
						enable_debug=1				
						;;			
					?)
						Error_msg "El parámetro \"-$OPTARG\" no es un parámetro válido. (PARAMETROS: $* \n $OPTIND)"
						#salimos del programa con un código de error 1
						exit 1
						;;
				esac
			done
			resetear_posicion_parametros
		fi
	fi
	if [ $enable_file_original -eq 1 ] && [ $enable_file_derived -eq 1 ] && [ $process_files -eq 1 ]
	then
		#Temporal file receptors
		if [ $enable_debug -eq 1 ]; then
			Debug_msg "Se procesarán archivos"
		fi
		local temp_receptor=/tmp/tmp_file
		local temp_receptor_2=/tmp/tmp_file_2
	else
		if [ $enable_debug -eq 1 ]; then	
			Debug_msg "Se procesará la línea $1"
		fi
		original_receptor=$2
		#flag que indica si lo que se está procesando actualmente es una línea o un archivo
		procesarLinea=1
		local temp_receptor=
		local temp_receptor_2=		
	fi			
		if [ "$procesarLinea" -eq 1 ]; then
			if [ $enable_debug -eq 1 ]; then
				Debug_msg "Empieza procesamiento de línea $original_receptor"
			fi
			#se quitan algunos símbolos especiales
			temp_receptor=$(echo $original_receptor | sed -r "s/($sed_filter)//g")
			#se reemplazan los acentos
			temp_receptor_2=$(echo $temp_receptor | sed -f $acentos_file)
			#Cambia mayusculas por minusculas
			derived_receptor=$(echo  $temp_receptor_2 | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')			
			Asignar_valor_linea_procesada $derived_receptor		
		else #se procesan archivos
			if [ $enable_debug -eq 1 ]; then
				Debug_msg "Empieza procesamiento de archivo $original_receptor"
			fi			
			sed -r "s/($sed_filter)//g" $original_receptor > $temp_receptor
			sed -f $acentos_file  $temp_receptor > $temp_receptor_2
			#Cambia mayusculas por minusculas
			sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' $temp_receptor_2 > $derived_receptor
		fi
}
#------------------------------ES_CAMINO_RELATIVO------------------------------------------
#Es_camino_relativo(){
#Este método FUNCIONA pero no es usado
#	local camino=$1
#	local esRelativo=`grep '\.\.\/' $1`
#	if [ -z $esRelativo ]
#	then
#		Error_msg "El camino '$1' pasado es relativo"
#	fi
#}

#------------------------------ASIGNAR_VALOR_LINEA_PROCESADA--------------------------------
Asignar_valor_linea_procesada(){
	export LINEA_PROCESADA=$1
}
#------------------------------RESETEAR_VALOR_LINEA_PROCESADA-------------------------------
Resetear_valor_linea_procesada(){
	export LINEA_PROCESADA=""
}

#------------------------------EXISTE_PETICION_AYUDA------------------------------------------
Existe_peticion_ayuda_en_pantalla(){

#Se pasó el parámetro "-h" al script (ANTES QUE EL NOMBRE DEL ARCHIVO A PROCESAR)?
while getopts ':h' OPCION; do
		case $OPCION in
			#original-file
			h)	printf '[---AYUDA---] INVOCACIÓN: %s\n\t-----------------------------------------------------------\n\t%s [-dh] <nombre_archivo> [<nombre_de_reemplazo>]\n\t-----------------------------------------------------------\n\tOpcion "-d": Habilita el modo debug.\n\tOpcion "-h":Muestra el texto de ayuda.\n\t-Donde <nombre_archivo> es el nombre del archivo a buscar duplicados.\n\t-<nombre_de_reemplazo>: OPCIONAL. Es el nombre del reemplazo elegido para duplicados.\n""' "$0" "$0"
				#salimos del programa con un código de éxito 0
				exit 0
				;;
#			d)
#				enable_debug=1				
#				;;
			?)
				Error_msg "El parámetro \"-$OPTARG\" no es un parámetro válido!"
				#salimos del programa con un código de error 1
				exit Resetear_valor_linea_procesada1
				;;
		esac
	done
	resetear_posicion_parametros
}

##------------------------------BUSCAR_DUPLICADO------------------------------------------------
Buscar_duplicado(){
	#flag
	local hayDuplicados=0	
	local lineaActual
	local parallel_file_name=/tmp/verificacion_paralela.txt	
	local list_splited_files=$(ls $name_splited_files*)	

	iniciar_archivo_de_reporte	
	
	local nroLineOriginal=0	
	while read line; do 
		nroLineOriginal=$(($nroLineOriginal+1));
		if ! [ -z "$line" ]; then			
			Procesar_texto -N "$line" --
		fi
		iniciar_archivo_de_verificacion $parallel_file_name
		for filePart in $list_splited_files
		do	
			echo "'grep -E \"[0-9]* $LINEA_PROCESADA\" $filePart'" >> $parallel_file_name
			printf "."		
		done
		#xargs es un comando que ejecuta otros comandos. Con la opción "--max-procs" ejecuta los comando como procesos concurrentes. Con el parámetro "--max-procs=0" se le dice que lance la mayor cantidad de procesos en concurrente. 
		lineas_duplicados=$(cat $parallel_file_name | xargs -I CMD --max-procs=0 bash -c CMD 1 | cut -d' ' -f1)
		Reportar $nroLineOriginal
		Resetear_valor_linea_procesada
	done < $path_f1
}


#------------------------------REPORTAR-----------------------------
Reportar(){
	#local lista_duplicados=$1
	local line_to_avoid=$1
	
	if [ "$lineas_duplicados" != ' ' ]; then
		printf "La linea %s tiene duplicados en las lineas:" "$line_to_avoid">> /tmp/informe	
		for nroLinea in $(echo $lineas_duplicados); do
			if [ $nroLinea -ne "$line_to_avoid" ]; then		
				printf "%s," "$nroLinea" >> /tmp/informe
			fi
		done
		printf "\n" >> /tmp/informe;
	fi	
}

#------------------------------INICIAR_ARCHIVO_DE_VERIFICACION-----------------------------
iniciar_archivo_de_verificacion(){
	local parameter_file_name=$1
	rm $parameter_file_name
	touch $parameter_file_name
}
#------------------------------INICIAR_ARCHIVO_DE_REPORTE-----------------------------
iniciar_archivo_de_reporte(){
	rm $name_report_file
	touch $name_report_file
}
#------------------------------DIVIDIR_ARCHIVO_ORIGINAL-----------------------------
Dividir_archivo_original(){
	local tamano=$(wc -l $temp_global_file | cut -d' ' -f1)
	#la division siempre devuelve un entero (redondeado hacia abajo), aunque el resultado verdadera sea numero partido. Debido a esto, sumamos 1 al resultado en caso de que la división no sea exacta.
	local cantidadParticiones=$((($tamano/10)+1))
	rm $name_splited_files*
	split -l $cantidadParticiones $temp_global_file $name_splited_files
}

#------------------------------NUMERAR_LINEAS_ARCHIVO-----------------------------
Numerar_lineas_archivo(){
	awk '{print NR, $0}' $temp_global_file > /tmp/duplicates_temp
	rm $temp_global_file
	mv /tmp/duplicates_temp $temp_global_file
}

#------------------------------INIT------------------------------------------------

init(){

total_lineas_archivo_original=0
name_splited_files=/tmp/splited_files_
name_report_file=/tmp/informe
#Se invoca el menú de ayuda si se lo invocó con -h
Existe_peticion_ayuda_en_pantalla $*

#Se imprimen los parámetros recibidos para Debug
printf "Se ejecutará el programa $0. Hay %i parámetro(s) recibido(s): \t%s\n" "$#" "$*"

#Existen los parámetros solicitados?
if [ -z $1 ]
then
	Error_msg "No se ha pasado el nombre del archivo a procesar."	
else
	path_f1=`pwd`/$1
	total_lineas_archivo_original=$(cat $path_f1 | wc -l)
	Debug_msg "Se procesará los archivo $path_f1, con un TOTAL de $total_lineas_archivo_original líneas a procesar..."	
fi
if [ ! -z $2 ]
then
	existeReemplazo=true
	reemplazo=$2
	Debug_msg "Reemplazo elegido es $reemplazo..."
fi
#Existe el archivo?
if [ ! -f $path_f1 ]
then
	Error_msg "No existe el archivo pasado como parametro."		
fi

#Temporal file. Global Variable
temp_global_file=/tmp/tmp_global
	local lineaNoProcesar=$2
#se crea el archivo de acentos
Archivo_de_acentos

#Se limpia el archivo de caracteres. El simbolo "--" indica que se terminó de pasar parametros.
Procesar_texto -f -o $path_f1 -d $temp_global_file

#<<LINEA_PROCESADA>> es una variable de entorno seteada por el procedimiento "Procesar_archivos" cada vez que se procesa una LINEA (y no un archivo).
#echo $LINEA_PROCESADA

Numerar_lineas_archivo
Dividir_archivo_original

Buscar_duplicado

#Comando para limpiar/eliminar las lineas sin duplicados
#cat informe | sed '/^La linea [0-9]* tiene .*:$/d' > resultado_metadata.dc.description.abstracts_duplicados.txt


echo "Ha finalizado el programa."
}

#Comienza la ejecución del script. Se le envían todos los parámetros que recibió el script desde consola, guardados en "$*"
init $*
