#!/bin/bash

JVM_PATH=/usr/lib/jvm

if [ $# -eq 2 ]
then
  JDK=$1
  PRIORITY=$2

  if [ -d $JVM_PATH/$JDK ]
  then
    echo '> update-alternatives java'
  else
    echo "$JVM_PATH/$JDK: No such file or directory"
    exit
  fi
else
  echo "Usage: update-alternatives.sh <jdk_name> <priority>"
  echo ""
  echo "jdk_name : java-6-oracle"
  echo "prority  : 1"

  exit
fi

JDK_BIN_PATH=$JVM_PATH/$JDK/bin
JRE_BIN_PATH=$JVM_PATH/$JDK/jre/bin
JAVA_MAN_PATH=$JVM_PATH/$JDK/man/man1

BIN_PATH=/usr/bin
MAN_PATH=/usr/share/man/man1

#echo update-alternatives --install $BIN_PATH/java java $JRE_BIN_PATH/java $PRIORITY


for FILENAME in $JDK_BIN_PATH/*
do
  NAME=$(basename $FILENAME)

  if [ "$NAME" == "apt" ]
  then
    continue
  fi

  if [ -e $JRE_BIN_PATH/$NAME ]
  then
    JAVA_BIN_PATH=$JRE_BIN_PATH
  else
    JAVA_BIN_PATH=$JDK_BIN_PATH
  fi

  update-alternatives --remove $NAME $JAVA_BIN_PATH/$NAME
  
  if [ -e $JAVA_MAN_PATH/$NAME.1.gz ]
  then
    update-alternatives --install $BIN_PATH/$NAME $NAME $JAVA_BIN_PATH/$NAME $PRIORITY \
       --slave $MAN_PATH/$NAME.1.gz $NAME.1.gz $JAVA_MAN_PATH/$NAME.1.gz
    update-alternatives --set $NAME $JAVA_BIN_PATH/$NAME
  else
    update-alternatives --install $BIN_PATH/$NAME $NAME $JAVA_BIN_PATH/$NAME $PRIORITY
    update-alternatives --set $NAME $JAVA_BIN_PATH/$NAME
  fi
done

for FILENAME in $JRE_BIN_PATH/*
do
  NAME=$(basename $FILENAME)

  if [ -e $JDK_BIN_PATH/$NAME ]
  then
    continue
  else
    JAVA_BIN_PATH=$JRE_BIN_PATH
  fi

  update-alternatives --remove $NAME $JAVA_BIN_PATH/$NAME
  
  if [ -e $JAVA_MAN_PATH/$NAME.1.gz ]
  then
    update-alternatives --install $BIN_PATH/$NAME $NAME $JAVA_BIN_PATH/$NAME $PRIORITY \
       --slave $MAN_PATH/$NAME.1.gz $NAME.1.gz $JAVA_MAN_PATH/$NAME.1.gz
    update-alternatives --set $NAME $JAVA_BIN_PATH/$NAME
  else
    update-alternatives --install $BIN_PATH/$NAME $NAME $JAVA_BIN_PATH/$NAME $PRIORITY
    update-alternatives --set $NAME $JAVA_BIN_PATH/$NAME
  fi
done