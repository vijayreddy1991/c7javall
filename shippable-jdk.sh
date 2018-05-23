#!/bin/bash -e
service_action=$1
JDK_VERSION=$2

export_java_path() {
  directory=$1;
  if [ -d "$directory" ]; then
    export JAVA_HOME="$directory";
    export PATH="$PATH:$directory/bin";
  else
    echo "$JDK_VERSION is not supported on this image"
    exit 99
  fi
}

set_java_path() {
  java_path=$1
  if [ -f $java_path ]; then
    sudo update-alternatives --set java $java_path
  else
    echo "$JDK_VERSION is not supported on this image"
    exit 99
  fi
}

set_javac_path() {
  javac_path=$1
  if [ -f $javac_path ]; then
    sudo update-alternatives --set javac $javac_path
  else
    echo "$JDK_VERSION is not supported on this image"
    exit 99
  fi
}

shippable_jdk() {
  if [ "$JDK_VERSION" == "openjdk7" ]; then
    export_java_path "/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.181-2.6.14.8.el7_5.x86_64";
    set_java_path "/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.181-2.6.14.8.el7_5.x86_64/jre/bin/java";
    set_javac_path "/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.181-2.6.14.8.el7_5.x86_64/bin/javac";
  elif [ "$JDK_VERSION" == "openjdk8" ]; then
    export_java_path "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-8.b10.el7_5.x86_64";
    set_java_path "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-8.b10.el7_5.x86_64/jre/bin/java";
    set_javac_path "/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-8.b10.el7_5.x86_64/bin/javac";
  elif [ "$JDK_VERSION" == "openjdk9" ]; then
    export_java_path "/usr/lib/jvm/java-9-openjdk-9.0.0.163-1.el7.centos.x86_64";
    set_java_path "/usr/lib/jvm/java-9-openjdk-9.0.0.163-1.el7.centos.x86_64/bin/java";
    set_javac_path "/usr/lib/jvm/java-9-openjdk-9.0.0.163-1.el7.centos.x86_64/bin/javac";
  elif [ "$JDK_VERSION" == "oraclejdk8" ]; then
    export_java_path "/usr/java/jre1.8.0_172-amd64";
    set_java_path "/usr/java/jre1.8.0_172-amd64/bin/java";
    set_javac_path "/usr/java/jdk1.8.0_172-amd64/bin/javac";
  elif [ "$JDK_VERSION" == "oraclejdk10" ]; then
    export_java_path "/usr/java/jdk-10.0.1";
    set_java_path "/usr/java/jdk-10.0.1/bin/java";
    set_javac_path "/usr/java/jdk-10.0.1/bin/javac";
  else
    echo "The version of the jdk you are trying to use is not supported. The supported versions include openjdk7, openjdk8, openjdk9, oraclejdk8, oraclejdk10"
    exit 99
  fi

  java -version
}

if [ "$JDK_VERSION" == "" ] || [ "$service_action" == "" ]; then
  echo "Usage: shippable_jdk set openjdk9"
  exit 1
fi

if  [ "$service_action" != "set" ]; then
  echo "Unknown command: $service_action"
  echo "Usage: shippable_jdk set openjdk9"
  exit 1
fi

shippable_jdk
