#!/bin/sh
#
# A simplified metamaplite bash script using metamaplite standalone
# jar, should work on MINGW bash (and GIT bash) on Windows.
# 

PROJECTDIR=$(dirname $0)

MML_VERSION=3.6.2rc8

OPENNLP_MODELS=$PROJECTDIR/data/models
CONFIGDIR=$PROJECTDIR/config

MML_JVM_OPTS=-Xmx12g

# metamaplite properties
MMLPROPS="-Dopennlp.en-sent.bin.path=$OPENNLP_MODELS/en-sent.bin \
    -Dopennlp.en-token.bin.path=$OPENNLP_MODELS/en-token.bin \
    -Dopennlp.en-pos.bin.path=$OPENNLP_MODELS/en-pos-perceptron.bin \
    -Dopennlp.en-chunker.bin.path=$OPENNLP_MODELS/en-chunker.bin \
    -Dlog4j.configurationFile=$PROJECTDIR/config/log4j2.xml \
    -Dmetamaplite.entitylookup.resultlength=1500 \
    -Dmetamaplite.index.directory=$PROJECTDIR/data/ivf/2022AB/USAbase \
    -Dmetamaplite.excluded.termsfile=$PROJECTDIR/data/specialterms.txt"

MML_CLASSPATH=$PROJECTDIR/target/classes:$PROJECTDIR/build/classes:$PROJECTDIR/classes:$PROJECTDIR:$MML_JAR

MML_JAR=$PROJECTDIR/target/metamaplite-${MML_VERSION}-standalone.jar
MML_CLASSPATH=$PROJECTDIR/target/classes:$PROJECTDIR/build/classes:$PROJECTDIR/classes:$PROJECTDIR:$MML_JAR

java $MML_JVM_OPTS $MMLPROPS -cp $MML_CLASSPATH gov.nih.nlm.nls.ner.MetaMapLite $* 

