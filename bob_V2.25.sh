#! /bin/bash
# bob..... "El constructor" Hahahaha
# bob construye los "ejecutables" de a_et y a_nc concatenando todos los
# modulos en un solo archivo y cambiandole los permisos de modo que sea 
# r-xr-xr-x
# Previamente verifica que todos los archivos existan.
# 


linea_guiones ()
{
echo "#----------------------------------------------------------------"  
}

declare -A LISTA_FUNCIONES MAIN OUT_FILE

VERS_MODS="2.25"

LISTA_FUNCIONES[a_et]="crea_listado_repositorio_V${VERS_MODS}.sh \
                       listar_modulos_V${VERS_MODS}.sh \
						verif_dirs_y_files_V${VERS_MODS}.sh \
						carga_patrones_V${VERS_MODS}.sh \
						obtener_extension_y_tipo_V${VERS_MODS}.sh \
						buscar_en_repositorio_V${VERS_MODS}.sh \
						NC_en_mem_V${VERS_MODS}.sh \
						generar_reporte_V${VERS_MODS}.sh \
						inicializar_contadores_V${VERS_MODS}.sh"
												
LISTA_FUNCIONES[a_nc]="crea_listado_repositorio_V${VERS_MODS}.sh \
						listar_modulos_V${VERS_MODS}.sh \
						verif_dirs_y_files_V${VERS_MODS}.sh \
						carga_patrones_V${VERS_MODS}.sh \
						obtener_extension_y_tipo_V${VERS_MODS}.sh \
						buscar_en_repositorio_V${VERS_MODS}.sh \
						NC_en_mem_V${VERS_MODS}.sh \
						generar_reporte_V${VERS_MODS}.sh \
						reporte_t_parc_V${VERS_MODS}.sh \
						inicializar_contadores_V${VERS_MODS}.sh"
												
MAIN[a_et]=a_et_main_V${VERS_MODS}.sh
MAIN[a_nc]=a_nc_main_V${VERS_MODS}.sh

OUT_FILE[a_et]=${MAIN[a_et]/_main/} # Quitamos el "_main"
OUT_FILE[a_nc]=${MAIN[a_nc]/_main/}


RUN_DATE="$(date  +\#\ %Y\/%m\/%d\ %H:%M)"
RUN_DATE_FILE="$(date  +%Y-%m-%d_%H%M)"  

# En que branch estamos?

git status >/dev/null
if [ $? = "0" ]
then
	BRANCH=$( git branch --list --no-color | grep  "\* ")
	BRANCH="${BRANCH:2}"
else
    BRANCH="NO-git"
fi

DIR_REF=${HOME}"/Documents/Ordena_Fotos_Cel"

if [ $# = 0 ]
then
   echo "Entrar el nombre del script... Opciones:"
   echo  "a_at |  1"
   echo  "a_nc |  2 "
   exit
fi

case $1 in
a_et | 1 )
	
	CUAL_MAIN="a_et"

	;;
a_nc | 2 ) 
	
	CUAL_MAIN="a_nc"
	
	;;
*)
	echo "$1 Opcion no conocida"
	exit
	;;
esac 
	
for A_INCLUIR in ${LISTA_FUNCIONES[${CUAL_MAIN}]} ${MAIN[${CUAL_MAIN}]}
do
	if [ ! -f  "${A_INCLUIR}" ]
	then
		echo "El MODULO ${A_INCLUIR} NO existe"
		exit
	fi
done
#
# Aca viene el banner y la lista de funciones a incluir

if [  -d "${OUT_FILE[${CUAL_MAIN}]}" ]
then
  echo "${NOM_ABREV}: No se puede generar: ${OUT_FILE[${CUAL_MAIN}]} Es un directorio"
  exit
fi

if [  -f "${OUT_FILE[${CUAL_MAIN}]}" ]
then
	rm -f "${OUT_FILE[${CUAL_MAIN}]}"
fi

  echo "#! /bin/bash"									 >${OUT_FILE[${CUAL_MAIN}]}
  linea_guiones 										>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Nombre    :  ${OUT_FILE[${CUAL_MAIN}]}"		>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Creado por: $0     Run_date  : ${RUN_DATE}"	>>${OUT_FILE[${CUAL_MAIN}]}
  printf "\n"											>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Directorio Origen:  ${PWD}"  					>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Branch           :  ${BRANCH}"				>>${OUT_FILE[${CUAL_MAIN}]}
  linea_guiones 										>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Warning   : DO NOT EDIT THIS FILE !!!"		>>${OUT_FILE[${CUAL_MAIN}]}
  linea_guiones 										>>${OUT_FILE[${CUAL_MAIN}]}
  echo "# Modulos incluidos:"				  	        >>${OUT_FILE[${CUAL_MAIN}]}

  for A_INCLUIR in ${LISTA_FUNCIONES[${CUAL_MAIN}]} ${MAIN[${CUAL_MAIN}]}
  do
	printf "#                     %s\n" ${A_INCLUIR} 	>>${OUT_FILE[${CUAL_MAIN}]}
  done
  
  linea_guiones 										>>${OUT_FILE[${CUAL_MAIN}]}
  printf "\n\n"											>>${OUT_FILE[${CUAL_MAIN}]}


# Aca contruimos el main
cat ${LISTA_FUNCIONES[${CUAL_MAIN}]} ${MAIN[${CUAL_MAIN}]}  >>${OUT_FILE[${CUAL_MAIN}]}

# Le sacamos permiso de w para que nadie edite este file
chmod 555 ${OUT_FILE[${CUAL_MAIN}]}
