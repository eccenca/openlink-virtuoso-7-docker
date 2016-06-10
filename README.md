# Virtuoso docker
This repo contains a Dockerimage for Openlink-Virtuoso.

## Current Version 

v7.2.0.1 - https://github.com/openlink/virtuoso-opensource/tree/v7.2.0.1

## Running your Virtuoso

```bash
## Running your Virtuoso
    docker run --name my-virtuoso \
        -p 8890:8890 -p 1111:1111 \
        -v /my/path/to/the/virtuoso/db:/var/lib/virtuoso/db \
        -d eccenca/virtuoso7
```

## Usage of virtuoso_helper script

```bash
to get running the helper script 
/$VIRT_HOME/virtuoso_helper.sh
or 
/opt/virtuoso-opensource/virtuoso_helper.sh


appHelp () {
  echo "Available options:"
  echo " app:importData [DBA-PASSWD, FILENAME, GRAPH]               - import given FILENAME to requested GRAPH "
  echo " app:deleteData [DBA-PASSWD, GRAPH]                         - delete requested GRAPH"
  echo " app:backupData [DBA-PASSWD]                                - create a backup with todays timestamp in $VIRT_DB/backup"
  echo " app:restoreData [BACKUP-PREFIX]                            - restore a backup with given backup-prefix (e.g. virt_backup_yymmdd-hhmm#)"
  echo " app:changeAdminPassword [OLD-DBA-PASSWD, NEW-DBA-PASSWD]   - change the admin password"
  echo " app:help                                                   - Displays the help"
  echo " [command]                                                  - Execute the specified linux command eg. bash."
}
```
