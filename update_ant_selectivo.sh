@Version Number
VERSION=0.1
ejecutar_maven=0
do_fresh_install=0
update_config_no_overwrite=0
root_dir="/home/facundo/Documentos/Trabajos/SeDiCi/Entornos/Workspaces/CIC_Digital/DSpace"
install_dir="/home/facundo/Documentos/Trabajos/SeDiCi/Entornos/Workspaces/CIC_Digital/DSpace/install"
escape_install_dir="\/home\/facundo\/Documentos\/Trabajos\/SeDiCi\/Entornos\/Workspaces\/CIC_Digital\/DSpace\/install"
MAVEN_PHASES="clean package"
JAVA_OPTS="JAVA_OPTS=-Xms512m -Xmx2048m"

while getopts ':mifch' OPTION; do
                case $OPTION in
                        m)
				#Se ejecuta el comando MVN
				
				ejecutar_maven=1
				;;
			i)
				#Perform the 'install' maven phase instead the 'package'
				echo "Ejecutando las fases 'clean install' en maven........................................................"
				MAVEN_PHASES="clean install"
				ejecutar_maven=1
				;;
			f)
				#Se ejecuta el fresh_install? Sino, se ejecuta otros comando ANT
				do_fresh_install=1
				;;
                        c)
				update_config_no_overwrite=1
				;;

			h)
				printf "======================================================\n[[[ AYUDA (VERSION $VERSION)]]] update_ant_selectivo [-mifch]\n\n'update_ant_selectivo' es una script que actualiza la instalación actual de DSpace. Presente distintos parámetros:\n\t\tSi no tiene parámetros se ejecuta un ant update con configuraciones particulares [desde ahora <ant_selectivo>], de tal forma de que no la configuración de la aplicación no se cambia, y otras cosas mas (se borran los directorio de backup, etc.).\n\t\t-m Se ejecuta un 'mvn package' y luego ejecuta el <ant_selectivo>.\n\t\t-i Se ejecuta un 'mvn install' y luego un <ant_selectivo>. Utilizado cuando se necesita actualizar el repositorio local debido a cambios de clases locales.\n\t\t-f Se realiza un 'ant fresh_install'.\n\t\t-c Se realiza un <ant_selectivo> pero pisando las configuraciones.\n\t\t-h Muestra este mensaje de ayuda.\n======================================================\n"
				exit 0
				;;
			?)
				echo "Parámetro inválido."
				exit 1
                                ;;
                esac
        done

#Ejecuto MVN si no se indica lo contrario, haciendo un install de aquellos proyectos que me interesan
if [ "$ejecutar_maven" -gt 0 ]; then
#	mvn clean install -P \!dspace-jspui,\!dspace-rdf,\!dspace-sword,\!dspace-swordv2,\!dspace-rest
	env "$JAVA_OPTS"  mvn $MAVEN_PHASES -P \!dspace-jspui,\!dspace-rdf,\!dspace-sword,\!dspace-swordv2,\!dspace-services,\!dspace-swordv2,\!dspace-xmlui-mirage2,\!dspace-lni
fi

#Creo el directorio de instalación si es que no existe
if [ ! -d "$install_dir" ]; then 
    mkdir $install_dir
 fi

#Ejecutarse en el directorio donde se encuentra el archivo 'build.xml'
#utilizado por Apache Ant para ejecutar sus tareas.
cd ./dspace/target/dspace-installer/
sed -i -r "s/^dspace\.dir.=.\/dspace/dspace.dir = $escape_install_dir/g" config/dspace.cfg

#Se verifica si se solicitó ejecutar la tarea 'fresh_install'
if [ "$do_fresh_install" -gt 0 ]; then
  ant fresh_install
else
  ant update_code
  ant clean_backups
  if [ "$update_config_no_overwrite" -gt 0 ];then
    ant update_configs -Doverwrite=false
  fi
  ant update_webapps
  ant clean_backups
fi

cd "$root_dir"
#Limpiando todos los directorios compilados
#mvn clean

#Comparamos los cambios en los directorios de configuracion de install con la version compilada
#meld "$root_dir/dspace/config" "$install_dir"/config&
