#!/bin/sh
############################
#
#  This programs open an ONLY-READ file using the 'pygmentize' library. The file is opened using colours.
#
############################

mensaje(){
 echo "================================================================"
 echo "================$1================"
 echo "================================================================"
}

mensaje_error(){
 echo "===========================[[ ERROR ]]==========================="
 echo "================$1================"
 echo "================================================================"
}

# Validations
if [[ ("$#" -eq 0 || "$1" = "") ]]; then
  mensaje_error "Must indicate a filename..."
  exit 1
else
  if [ ! -f "$1" ]; then
    mensaje_error "The filename passed cannot be opened because isn't a file."
    exit
  fi
fi

# Begin progam
case "$1" in
    *.awk|*.groff|*.java|*.js|*.m4|*.php|*.pl|*.pm|*.pod|*.sh|\
    *.ad[asb]|*.asm|*.inc|*.[ch]|*.[ch]pp|*.[ch]xx|*.cc|*.hh|\
    *.lsp|*.l|*.pas|*.p|*.xml|*.xps|*.xsl|*.axp|*.ppd|*.pov|\
    *.diff|*.patch|*.py|*.rb|*.sql|*.ebuild|*.eclass)
        pygmentize -f 256 "$1";;
    .bashrc|.bash_aliases|.bash_environment)
        pygmentize -f 256 -l sh "$1"
        ;;
    *)
        grep "#\!/bin/bash" "$1" > /dev/null
        if [ "$?" -eq "0" ]; then
            pygmentize -f 256 -l sh "$1"
        else
            exit 1
        fi
esac

exit 0
