#!/bin/bash

author_pattern=
filename_find_regex=
simple_log_format=0
#Esta variable no se puede controlar por parámetro.
verbose=1
verbose_file=/tmp/git-changes-per-author.log
matching_files=
log_pretty_format_only_commit="%H"
log_pretty_format_complete="%C(yellow) Commit: %h - %Cgreen Author: %an (%ae) - %Cred Date: %aI - %Creset %s"

message(){
 echo "================================================================"
 echo "================$1================"
 echo "================================================================"
}

show_help(){
  defaultBehaviour="git-changes-per-author busca los commits cuyo autor sea el 'author' indicado.\n"
  
  aOption="\t -a <author_pattern>: busca los commits correspondientes a este usuario. Si se pasa sólo éste parámetro, sin el -f, entonces se buscan todos los commits de ese author. \n"
  
  fOption="\t -f <filename_pattern>: muestra la historia de cada uno de los archivos que concuerden con el expression regular indicada. Si se pasa sólo este parámetro, sin el -a, entonces se muesta la historia de todos los archivos que se correspondan con la expresión. Cómo pueden haber muchos archivos que procesar, siempre se mantiene un archivo de log sobre el procesamiento actual (ver opción -l para más información).\n"
  
  sOption="\t -s : Cuando este flag esta presenta, se muestran únicamente los commit hash. Esta opción es útil cuando se quiera procesar la salida por otro comando. \n"

  lOption="\t -l <new_log_file_path> : Normalmente, el procesamiento actual del programa se vuelca en el archivo temporal '/tmp/git-changes-per-author.log'. Si la opción -l es pasada, se cambiará la ruta del archivo de LOG al <new_log_file_path> especificado.\n"
  
  hOption="\t -h: Show this help menu.\n"
  
  
  printf "======================================================\n[[[ AYUDA ]]] $defaultBehaviour $aOption $fOption $sOption $lOption $hOption ======================================================\n"
}

parseParams(){
  while getopts ':hf:a:l:s' OPTION; do
	  case $OPTION in
		  f) 
		    filename_find_regex=$OPTARG
		    if [ -z "$filename_find_regex" ]; then
			message "No se ha pasado ningún patrón para búsqueda de archivos."
			exit 3
		    fi
		    ;;
		  a) 
		    author_pattern=$OPTARG
		    if [ -z "$author_pattern" ]; then
			message "No se ha pasado ningún patrón para búsqueda por autor."
			exit 2
		    fi
		    ;;
		  s)
		    simple_log_format=1
		    ;;
		  l)
		    verbose_file=$OPTARG
		    if [ -z "$filename_find_regex" ]; then
			message "No se ha pasado ninguna ruta como archivo de LOG."
			exit 6
		    fi
		    ;;
		  h)
		    show_help
		    exit 0
		    ;;
		  ?)
		    message "Parámetro inválido."
		    exit 1
		    ;;
	  esac
  done
  
  if [ -z "$author_pattern" ]; then
    message "Es requerido especificar un patrón de búsqueda por autor. Vea la ayuda del comando pasando -h."
    exit 4
  fi
}

check_if_on_git_repository(){
    git status &> /dev/null
    #If we aren't at a git repository, then exits the program...
    if [ `echo $?` -gt 0 ]; then
      message "Tiene que posicionarse sobre un repositorio git local."
      exit 5
    fi
}

log_message(){
    echo `date`" -- $1" >> $verbose_file
}

show_git_log(){
    prefix_format=""
    file=""
    if [ "$1" == "-f" -a "$2" != "" ]; then
      file="$2"
      prefix_format="($file) %n"
      if [ $verbose -gt 0 ]; then
	log_message "Procesando FILE: $file"
      fi
    fi
    if [ $simple_log_format -eq 0 ]; then
# 	 "FILE:$f"
# 	read
      git log --pretty=format:"$prefix_format $log_pretty_format_complete" --author="$author_pattern" -- "$file"
    else
      git log --pretty=format:"$log_pretty_format_only_commit" --author="$author_pattern" -- "$file"
    fi
}

view_log_of_matching_files() {
    matching_files=`find -name "$filename_find_regex"`
    if [ -z "$matching_files" ]; then
      message "No existe ningún archivo que se corresponda con la expresión regular."
    fi
    for f in $matching_files;
    do
      show_git_log -f "$f" 
#       if [ $verbose -gt 0 ]; then
# 	  log_message "Procesando FILE: $f"
#       fi
#       if [ $simple_log_format -eq 0 ]; then
# # 	 "FILE:$f"
# # 	read
#  	git log --pretty=format:"($f) %n $log_pretty_format_complete" --author="$author_pattern" "$f"
#       else
# 	git log --pretty=format:"$log_pretty_format_only_commit" --author="$author_pattern" "$f"
#       fi
    done
}


main(){
  parseParams $*
  log_message "[[[[[ INICIO ]]]]] de la ejecución del programa."
  check_if_on_git_repository
  if [ ! -z "$filename_find_regex" ]; then
    view_log_of_matching_files
  else
#     git log --author="$author_pattern"
     show_git_log
  fi
  log_message "[[[[[ FIN ]]]]] de la ejecución del programa."
}

main $*
