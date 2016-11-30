#!/bin/bash

source ../message-print.sh


#VARS
FULL_AUTHOR_INFO_FILE=/home/facundo/autores_CIC.csv
TMP_DIR=/tmp/get_authors_script_tmp_files

#autores=("ABÁSOLO, María José")
autores=("ABÁSOLO, María José" "ABEDINI, Walter Ismael" "ACCIARESI, Horacio Abel" "AGAMENNONI, Osvaldo Enrique" "AGUIRRE, Manuel Antonio" "ALIPPI, Adriana Mónica" "ALMASSIO, Marcela Fabiana" "AMALVY, Javier Ignacio" "ANDREASEN, Gustavo Alfredo" "APHALO, Paula" "ARCE, Valeria Beatriz" "ARELOVICH, Hugo Mario" "ARTOPOULOS, Alejandro Martin" "BAKAS, Laura Susana" "BALATTI, Pedro Alberto" "BARGO, María Susana" "BASALDELLA, Elena Isabel" "BELTRANO, José" "BENGOA, José Fernando" "BENVENUTO, Omar Gustavo" "BIDART, Susana Mabel" "BIDEGAIN, Juan Carlos" "BILMES, Gabriel Mario" "BLASI, Adriana Mónica" "BOLZAN, Agustín Eduardo" "BOSCH, María Alejandra Nieves" "BREDICE, Fausto Osvaldo" "BRENTASSI, María Eugenia" "BRESSA, Sergio Patricio" "BUSCAGLIA, Celina" "CABELLO, Marta Noemí" "CABELLO, Carmen Inés" "CACERES, Eduardo Jorge" "CAMINO, Nora Beatriz" "CASANOVA, Federico Martín" "CASCIOTTA, Jorge Rafael" "CASTRO LUNA BERENGUER, Ana María Del Carmen" "CAZZANIGA, Néstor Jorge" "CESAR, Inés Irma" "CHOPA, Alicia Beatriz" "COLLAZOS, Guillermo" "COLOMBO, Juan Carlos" "CONCELLÓN, Analía" "CONTI, Alfredo Luis" "CORDO, Cristina Alicia" "CORREA, María Verónica" "CORTIZO, Ana María" "CROCE, María Virginia" "D ANGELO, Cristian Adrián" "DAL BELLO, Gustavo Mariano" "DALEO, Gustavo Raúl" "DAVID GARA, Pedro Maximiliano" "DE ANTONI, Graciela Liliana" "DE GIUSTI, Marisa Raquel" "DEL FRESNO, Mirta Mariana" "DI ROCCO, Florencia" "DI SARLI, Alejandro Ramón" "DIAZ, Ana Cristina" "DONNAMARIA, María Cristina" "DREON, Marcos Sebastián" "ECHENIQUE, Ricardo Omar" "EGLI, Walter Alfredo" "ESTRELLA, María Julia" "FARAONI, María Belén" "FAVRE, Liliana María" "FERNANDEZ, Raúl Roberto" "FERNANDEZ, Alejandro" "FERRARI, Lucrecia" "FILLOTTRANI, Pablo Ruben" "FRASSA, María Victoria" "FUSELLI, Sandra Rosa" "GALANTINI, Juan Alberto" "GALLARDO, Fabiana Edith" "GALOSI, Cecilia Mónica" "GARAVENTTA, Guillermo Norberto" "GARCIA, Juan José" "GERVASI, Claudio Alfredo" "GIACCIO, Graciela Marta" "GINER, Sergio Adrián" "GOMEZ DE SARAVIA, Sandra Gabriela" "GORDILLO, Silvia Ethel" "GREGORUTTI, Ricardo Walter" "GUIAMET, Juan José" "HERNANDEZ, Luis Francisco" "HOPP, Horacio Esteban" "HOUGH, Guillermo Ernesto" "HOZBOR, Daniela Flavia" "ISLA LARRAIN, Marina Teresita" "IXTAINA, Pablo Ruben" "JAUREGUIZAR, Andrés Javier" "KESSLER, Teresita" "KOWALSKI, Andrés Mauricio" "LANFRANCHINI, Mabel Elena" "LANGE, Carlos Ernesto" "LLORENTE, Carlos Luis" "LOMBARDI, María Barbara" "LORI, Gladys Albina" "LUNA, María Flavia" "LUNASCHI, Lía Inés" "MALLO, Juan Carlos" "MANDOLESI, Pablo Sergio" "MANTZ, Ricardo Julián" "MARCOS, Claudia Andrea" "MARCOZZI, Rosana Gisela" "MARDER, Sandra Esther" "MARFIL, Silvina Andrea" "MARIÑELARENA, Alejandro Jorge" "MARTIN, Stella Maris" "MARTINO, Pablo Eduardo" "MÁRTIRE, Daniel Osvaldo" "MATE, Sabina María" "MAYOSKY, Miguel Angel" "MCCARTHY, Andrés Norman" "MENDIETA, Julieta Renée" "MERINO, Mariano Lisandro" "MILESSI, Andres Conrado" "MISTCHENKO, Alicia Susana" "MONTANI, Rubén Alfredo" "MOREL, Eduardo Manuel" "MORELLI, Irma Susana" "MURAVCHIK, Carlos Horacio" "MURIALDO, Silvia Elena" "NATALUCCI, Claudia Luisa" "ORTALE, María Susana" "ORZI, Daniel Jesús Omar" "PADOLA, Nora Lía" "PALACIO, Hugo Anibal" "PAOLINI, Eduardo Emilio" "PARADELL, Susana Liria" "PAREDI, María Elida" "PASQUEVICH, Alberto Felipe" "PELAEZ, Daniel Valerio" "PELUSO, Fabio Oscar" "PICASSO, Alberto Carlos" "PISTONESI, Marcelo Fabián" "PONS, Claudia Fabiana" "PORTA, Atilio Andrés" "QUARANTA, Nancy Esther" "QUEREJETA, Maira Gisela" "RABASSA, Martín Enrique" "RAINERI, María Mónica" "RESNIK, Silvia Liliana" "RESSIA, Jorge Aníbal" "REYNA ALMANDOS, Jorge Guillermo" "RICCILLO, Pablo Miguel" "RIGOTTI, Graciela Ester" "RINALDI, Pablo Rafael" "RIVAS, Raúl Eduardo" "RODRIGUEZ NIETO, Felipe Jorge" "ROMERO, José Ricardo" "ROSSIGNOLI, Raúl Dante" "RULE, Roberto" "RUSSO, Nélida Araceli" "SALGUEIRO, Walter Alberto" "SALLOVITZ, Juan Manuel" "SARANDON, Santiago Javier" "SCHAPOSNIK, Fidel Arturo" "SCHINCA, Daniel Carlos" "SCHNACK, Enrique Jorge" "SEMORILE, Liliana Carmen" "SERAFINI, María Cristina" "SISTERNA, Marina Noemí" "SOMOZA, Alberto Horacio" "TAVANI, Eduardo Luis" "TINETTI, Fernando Gustavo" "TOGNANA, Sebastián Alberto" "TOGNETTI, Jorge Alberto" "TRAVERSA, Luis Pascual" "TRIVI, Marcelo Ricardo" "UNGARO, Pablo Miguel" "VELA, María Elena" "VICENTE, José Luis" "VIGIER, Hernán Pedro" "VILLATA, Laura Sofía" "VOLPONI, Carola Regina" "WEBER, Christian" "WEINZETTEL, Pablo Ariel" "WILLIAMS, Patricia Ana María" "WOLCAN, Silvia María" "ZALBA, Patricia Eugenia" "ZARRAGOICOECHEA, Guillermo Jorge" "ZERBINO, Jorge Omar" "ZUGARRAMURDI, Aurora")

message_important "Procesando ${#autores[@]} autores... Presione una tecla para continuar..."
read tecla

mkdir $TMP_DIR *> /dev/null
if [ -f $TMP_DIR/result.csv ]; then
   rm $TMP_DIR/result.csv
else
   touch $TMP_DIR/result.csv
fi

if [ -f $TMP_DIR/result_docs.csv ]; then
   rm $TMP_DIR/result_docs.csv
else
   touch $TMP_DIR/result_docs.csv
fi

for (( index=0; index<${#autores[@]}; index++ ))
do
   message_simple "<$index / ${#autores[@]}> Obteniendo publicaciones de ${autores[$index]}..."
   
   SOLR_QUERY="http://digital.cic.gba.gob.ar/solr/search/select/?wt=xml&rows=0&facet=true&fl=dcterms.creator.author&q=dcterms.creator.editor:(\"${autores[$index]}\") OR dcterms.creator.compilator:(\"${autores[$index]}\") OR dcterms.creator.author:(\"${autores[$index]}\")&facet.query=dcterms.creator.editor:(\"${autores[$index]}\") OR dcterms.creator.compilator:(\"${autores[$index]}\") OR dcterms.creator.author:(\"${autores[$index]}\")"
   
   SOLR_QUERY_TO_DOCS="http://digital.cic.gba.gob.ar/solr/search/select/?wt=csv&csv.separator=|&rows=10000&facet=true&fl=dc.title,dcterms.issued,dc.identifier.uri,dcterms.isPartOf.series,dcterms.isPartOf.issue,dc.type&q=dcterms.creator.editor:(\"${autores[$index]}\") OR dcterms.creator.compilator:(\"${autores[$index]}\") OR dcterms.creator.author:(\"${autores[$index]}\")&facet.query=dcterms.creator.editor:(\"${autores[$index]}\") OR dcterms.creator.compilator:(\"${autores[$index]}\") OR dcterms.creator.author:(\"${autores[$index]}\")"
   
   wget "$SOLR_QUERY" --quiet -O $TMP_DIR/results.xml *> /dev/null
   wget "$SOLR_QUERY_TO_DOCS" --quiet -O $TMP_DIR/result_docs.csv

   documentsFounded=`xmllint --format $TMP_DIR/results.xml | egrep "<result.*/>" | sed 's/<result name=\"response\" numFound=\"//g' | sed 's/\".*\/>//g'`
   
   authorWithoutComma=`echo ${autores[$index]} | sed 's/\,\s/|/g'`
   echo "`grep "$authorWithoutComma" $FULL_AUTHOR_INFO_FILE | sed "s/$/|$documentsFounded/"`" >> $TMP_DIR/result.csv
#    printf "|$SOLR_QUERY_TO_DOCS\n" >> $TMP_DIR/result.csv
   
   while read line; do
      if [ ! "$line" = "dc.title|dcterms.issued|dc.identifier.uri|dcterms.isPartOf.series|dcterms.isPartOf.issue|dc.type" ]; then
         echo "|||||$line" >> $TMP_DIR/result.csv
      fi
   done <$TMP_DIR/result_docs.csv
   
done
