
#!/bin/bash
set -e

CONFIG="${VIRT_DB}/virtuoso.ini"

importData () {
  if [ -z ${oldpassword} ]; then
    echo "Please enter the current password (default pw is dba)"
    return 1
  fi

  if [ -z ${filename} ]; then
    echo "Please specify a filename"
    return 1
  fi

  if [ -z ${graph} ]; then
    echo "Please specify a graph for the data which should be imported"
    return 1
  fi

  /opt/virtuoso-opensource/bin/isql 1111 dba $oldPW exec="DB.DBA.TTLP_MT (file_to_string_output ('${filename}'), '', '${graph}');"

}

backupData () {

  if [ -z ${oldpassword} ]; then
    echo "Please enter the current password (default pw is dba)"
    return 1
  fi

  BACKUPDIR="$VIRT_DB/backup"
  mkdir -p $BACKUPDIR

  BACKUPDATE=`date +%y%m%d-%H%M`
    /opt/virtuoso-opensource/bin/isql 1111 dba $oldpassword <<ScriptDelimit
    backup_context_clear();
    checkpoint;
    backup_online('virt_backup_$BACKUPDATE#',150,0,vector('$BACKUPDIR'));
    exit;
ScriptDelimit

}

restoreData () {

  if [ -z ${backupprefix} ]; then
    echo "Please enter a dump/backup prefix (e.g. virt_backup_yymmdd-hhmm#)"
    return 1
  fi

  BACKUPDIR="$VIRT_DB/backup"
  cd $BACKUPDIR
  /opt/virtuoso-opensource/bin/virtuoso-t -c $CONFIG +foreground +restore-backup $backupprefix
  
}

changeAdminPassword () {
  if [ -z ${oldPW} ]; then
    echo "Please enter the current password (default pw is dba)"
    return 1
  fi

  if [ -z ${newPW} ]; then
    echo "Please enter the new password for user dba (virtuoso-admin)"
    return 1
  fi

  /opt/virtuoso-opensource/bin/isql 1111 dba $oldPW exec="set password ${oldPW} ${newPW};"

}


appHelp () {
  echo "Available options:"
  echo " app:importData		         - import given FILENAME to requested GRAPH"
  echo " app:backupData            - create a backup with todays timestamp in $VIRT_DB/backup"
  echo " app:restoreData           - restore a backup with given backup-prefix (e.g. virt_backup_yymmdd-hhmm#)"
  echo " app:changeAdminPassword   - change the admin password"
  echo " app:help                  - Displays the help"
  echo " [command]                 - Execute the specified linux command eg. bash."
}

case "$1" in
  app:importData)
    shift
    oldpassword=$1
    filename=$2
    graph=$3
    importData
    ;; 
  app:backupData)
    shift
    oldpassword=$1
    backupData
    ;;
  app:restoreData)
    shift
    backupprefix=$1
    restoreData
    ;;     
  app:changeAdminPassword)
    shift
    oldPW=$1
    newPW=$2
    changeAdminPassword
    ;;   
  app:help)
    appHelp
    ;;
  *)
    if [ -x $1 ]; then
      $1
    else
      prog=$(which $1)
      if [ -n "${prog}" ] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0