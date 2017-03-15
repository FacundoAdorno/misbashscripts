#!/bin/bash

VERSION=0.1

declare -A PROFILE_LIST
PROFILE_LIST=([DAILY]=daily [WEEKLY]=weekly [MONTHLY]=monthly)
declare -A DEFAULT_ROTATE_COUNTS
DEFAULT_ROTATE_COUNTS=([DAILY]=15 [WEEKLY]=8 [MONTHLY]=6)
ROTATE_PROFILE=

#Configurar esta ruta indicando dónde se encuentran los backups...
ROTATE_BKP_DIR=/tmp/prueba

DAILY_ROTATE_BKP_DIR=$ROTATE_BKP_DIR1
WEEKLY_ROTATE_BKP_DIR=$ROTATE_BKP_DIR/backups.${PROFILE_LIST[WEEKLY]}
MONTHLY_ROTATE_BKP_DIR=$ROTATE_BKP_DIR/backups.${PROFILE_LIST[MONTHLY]}
ROTATE_COUNT=
SILENT_MODE=0


message(){
   if [ ! -z "$1" ] && [ $SILENT_MODE -eq 0 ]; then
      echo "$1"
   fi
}

is_positive_integer(){
   re='^[0-9]+$'
   if ! [[ $1 =~ $re ]] ; then
      message "[error] $1 no es un numero válido" 
      exit 3
   fi
}

usage(){
   echo "---------------------------------------------------------------------------------------------------------------"
   echo "[Ayuda] "
   echo "### USO --> $0 -(d|w|m) [-c cantidad_de_rotaciones]"
   echo "Este script realiza rotaciones de los ultimos backups generados, determinando ésto (por ahora) mediante el orden por nombre. Posee 3 \"modos de ejecución\" o \"perfiles\", debiéndose especificar 'sólo' uno de ellos:"
   echo
   echo "   * daily (-d): rota sólo entre los scripts de backups que se generan día a día. Por defecto, se realiza hasta ${DEFAULT_ROTATE_COUNTS[DAILY]} rotaciones."
   echo "   * weekly (-w): se copia el último backup diario generado y se lo copia en un directorio de rotaciones semanales (.weekly). Por defecto se realiza hasta ${DEFAULT_ROTATE_COUNTS[WEEKLY]} rotaciones en este directorio."
   echo "   * monthly (-m): se copia el último backup diario generado y se lo copia en un directorio de rotaciones mensuales (.monthly). Por defecto se realiza hasta ${DEFAULT_ROTATE_COUNTS[MONTHLY]} rotaciones en este directorio."
   echo
   echo "El parámetro \"-c\" se puede utilizar para pisar la cantidad de rotaciones de cada perfil (p.e. -d -c 50)."
   echo
   echo "### ACTIVACIÓN MEDIANTE CRONJOBS ###"
   echo "   Es recomendable activar los distintos perfiles de rotación mediante las cronjobs del sistema, ya que este simple script no detecta qué día es el actual, es decir, el primero del mes o la semana..."
   echo "   P.e.:"
   echo "	#cron de rotación diaria a las 00 hs"
   echo "	0 0 * * *  root  $0 -d"
   echo "	#cron de rotación semanal - todos los lunes a las 00:15hs"
   echo "	15 0 * * 1  root  $0 -w"
   echo "	#cron de rotación mensual - todos los primeros de mes  a las 00:30hs"
   echo "	30 0 1 * *  root  $0 -m"
   echo
   echo "Para un script de rotación mas completo ver https://github.com/todiadiyatmo/bash-backup-rotation-script."
   echo "---------------------------------------------------------------------------------------------------------------"
}

#main rotate function
rotate(){
   #Obtenemos los primeros $ROTATE_COUNT backups, ordenados del mas reciente al mas antiguo...
   backups_to_delete_count=`expr $(find $ROTATE_BKP_DIR -maxdepth 1 -type f | sort -r | wc -l) - $ROTATE_COUNT`
   if [ $backups_to_delete_count -gt 0 ]; then
      backups_to_delete=`find $ROTATE_BKP_DIR -maxdepth 1 -type f | sort -r | tail -$backups_to_delete_count`
      for b in $backups_to_delete
      do
         message "[BACKUPS_ELIMINADOS]: $b"
         #Eliminamos los backups fuera de la rotación
         rm -rf $b
      done
   fi
}

############################
#init
############################

#Se pasó al menos un parámetro
if [ -z "$*" ]; then
   usage
fi

#parse options
while getopts ":qdwvmhc:" opt; do
   case $opt in
      q)
         SILENT_MODE=1
         ;;
      c)
         ROTATE_COUNT=$OPTARG
         is_positive_integer $ROTATE_COUNT
         ;;
      d)
         ROTATE_PROFILE=${PROFILE_LIST[DAILY]}
         ;;
      w)
         ROTATE_PROFILE=${PROFILE_LIST[WEEKLY]}
         ;;   
      m)
         ROTATE_PROFILE=${PROFILE_LIST[MONTHLY]}
         ;;   
      :)
         message "Opción -$OPTARG requiere un argumento."
         exit 2
         ;;
      h) 
         usage
         exit 0
         ;;
      v)
         message "v$VERSION"
         exit 0
         ;;
      *) 
         message "Opción \"-$OPTARG\" inválida... Utiliza \"-h\" para obtener ayuda."
         exit 4
         ;;
   esac
done

#check for $ROTATE_COUNT
if [ -z $ROTATE_COUNT ]; then
   case $ROTATE_PROFILE in
      ${PROFILE_LIST[DAILY]})
         ROTATE_COUNT=${DEFAULT_ROTATE_COUNTS[DAILY]}
         ;;
      ${PROFILE_LIST[WEEKLY]})
         ROTATE_COUNT=${DEFAULT_ROTATE_COUNTS[WEEKLY]}
         ;;
      ${PROFILE_LIST[MONTHLY]})
         ROTATE_COUNT=${DEFAULT_ROTATE_COUNTS[MONTHLY]}
         ;;
   esac
fi

#El mas reciente backup generado en el directorio de backups...
#LAST_BACKUP_FILENAME=`ls -1r $ROTATE_BKP_DIR | head -1`
LAST_BACKUP_FILE=`find $ROTATE_BKP_DIR -maxdepth 1 -type f | sort -r | head -1`

case $ROTATE_PROFILE in
      ${PROFILE_LIST[DAILY]})
         #use the default ROTATE_BKP_DIR
         rotate
         ;;
      ${PROFILE_LIST[WEEKLY]})
         #create WEEKLY_ROTATE_BKP_DIR if not exists
         if [ ! -d "$WEEKLY_ROTATE_BKP_DIR" ]; then
            mkdir $WEEKLY_ROTATE_BKP_DIR
         fi
         #copy the weekly backup in WEEKLY_ROTATE_BKP_DIR
         cp $LAST_BACKUP_FILE  $WEEKLY_ROTATE_BKP_DIR/`basename $LAST_BACKUP_FILE`.weekly
         #use the WEEKLY_ROTATE_BKP_DIR for rotate
         ROTATE_BKP_DIR=$WEEKLY_ROTATE_BKP_DIR 
         rotate
         ;;
      ${PROFILE_LIST[MONTHLY]})
         #create MONTHLY_ROTATE_BKP_DIR if not exists
         if [ ! -d "$MONTHLY_ROTATE_BKP_DIR" ]; then
            mkdir $MONTHLY_ROTATE_BKP_DIR
         fi
         #copy the weekly backup in MONTHLY_ROTATE_BKP_DIR
         cp $LAST_BACKUP_FILE  $MONTHLY_ROTATE_BKP_DIR/`basename $LAST_BACKUP_FILE`.monthly
         #use the MONTHLY_ROTATE_BKP_DIR
         ROTATE_BKP_DIR=$MONTHLY_ROTATE_BKP_DIR
         rotate
         ;;
esac
