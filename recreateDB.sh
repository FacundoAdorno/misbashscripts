#!/bin/sh
#Path to database dump file
dbfile=
dbname="dspace_cic"
pguser="dspace_user"
password="dspace"

mensaje(){
 echo "================================================================"
 echo "================$1================"
 echo "================================================================"
}


test_finalization(){
  if [ "$?" -ne 0 ];then
    mensaje "Se ha generado un error..."
    exit 1
  fi
}

while getopts 'f:' OPTION; do
	case $OPTION in
		f)
		  dbfile=$OPTARG
		  if [ ! -f "$dbfile" ];then
                    echo "El dump file no existe en la ruta especificada: $dbfile"
		    exit 1
		  fi
		  ;;
		?)
		  echo "Parámetro inválido."
		  exit 1
		  ;;
	esac
done

echo "¿Queres eliminar la BBDD actual y restaurarla por el contenido en $dbfile? ('y' para eliminarla. 'n' caso contrario)."
read confirm_delete

if [ "$confirm_delete" != "y" ] && [ "$confirm_delete" != "s" ]; then
	echo "Suspendiendo la restauración"
	exit 0
fi
mensaje "Eliminando la base de datos...(password: 'dspace')"
dropdb $dbname --host=localhost  --username=$pguser
test_finalization
mensaje "Creando una nueva base de datos...(password: 'dspace')"
createdb  $dbname --host=localhost --username=$pguser --encoding=UTF8
test_finalization
mensaje "Poblando la base de datos con el contenido de $dbfile..."
psql --host=localhost --username=$pguser --dbname=$dbname --file=$dbfile
test_finalization

mensaje "Base de datos recreada."
