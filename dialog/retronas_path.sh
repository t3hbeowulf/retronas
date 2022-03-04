#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
cd ${DIDIR}

rn_retronas_path() {
  DLG_DSELECT "Please type in the RetroNAS top level directory" "${OLDRNPATH}"

  # Show the ugly path chooser
  if [ ! -z "${CHOICE}" ]
  then
    if [ "${CHOICE}" != "${OLDRNPATH}" ]
    then

      # if the path the user has entered, dont save it and give them a continue
      if [ ! -d ${CHOICE} ]
      then
        echo "The path ${CHOICE} does not exist"
        PAUSE
        rn_retronas_path
      else 
        echo "Everything is OK bloke"
      fi

      NEWRNPATH=$CHOICE
      # Confirm the input because the path chooser sucks
      rn_retronas_path_confirm "${NEWRNPATH}"

    else
      source $_CONFIG
      echo "Nothing to change"
      exit
    fi
      echo "User cancelled dialog"
      exit
  fi
}

rn_retronas_path_confirm() {
  local NEWRNPATH="${1}"

  local MENU_NAME=set-top-level-dir-confirm
  READ_MENU_TDESC "${MENU_NAME}"
  DLG_YN "${MENU_TNAME}" "${MENU_BLURB}"

  case ${CHOICE} in
    0)
      source $_CONFIG
      # Yes, change the value
      # Delete the old value
      sed -i '/retronas_path:/d' "${ANCFG}"
      # Add the new value and re-source
      echo "retronas_path: \"${NEWRNPATH}\"" >> "${ANCFG}"
      source $_CONFIG
      export OLDRNPATH="${NEWRNPATH}"
      EXIT_OK
      ;;
    *)
      # No, the path chooser sucks probably, so just bail
      exit ${CHOICE}
      ;;
  esac

}

rn_retronas_path