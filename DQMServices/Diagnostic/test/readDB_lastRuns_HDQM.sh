baseDir=/home/cmstacuser/historicDQM/CMSSW_Releases/CMSSW_3_1_X_2009-03-31-0100/src
lockFile=$baseDir/lockFile



if [ ! $1 ] ;
    then echo "please provide the number of runs you would like to consider..."
         echo "./readDB_lastRuns_HDQM.sh 10 "
    exit 1
fi	



cd $baseDir
eval `scramv1 runtime -sh`



[ -e $lockFile ] && echo -e "lockFile " $lockFile "already exists. Process probably already running. If not remove the lockfile." && exit
touch $lockFile
echo -e "=============================================================="
echo " Creating lockFile :"
ls $lockFile
trap "rm -f $lockFile" exit



echo "=========================================================================="
echo " Extract the infos from the DB & do the trend plots for the last $1 runs  "  
echo "=========================================================================="

cat $baseDir/DQMServices/Diagnostic/test/template_HDQMInspectorSelection_lastRuns.cc | sed -e "s@nRuns@$1@g" > $baseDir/testHDQMInspectorSelection_lastRuns.cc
cp  $baseDir/DQMServices/Diagnostic/test/rootlogon.C $baseDir/.
root -l -b -q $baseDir/rootlogon.C
root -l -b -q $baseDir/testHDQMInspectorSelection_lastRuns.cc

if [ `ls historicDQM.root` ]; then
root -l -b -q DQMServices/Diagnostic/test/testGraphAnalysis.cc
fi

#cp $baseDir/DQMServices/Diagnostic/test/diow.pl .
#./diow.pl

rm -rf CRAFT_last_$1_runs
mkdir CRAFT_last_$1_runs
mkdir CRAFT_last_$1_runs/details
mkdir CRAFT_last_$1_runs/trends_by_layer_TIB
mkdir CRAFT_last_$1_runs/trends_by_layer_TOB
mkdir CRAFT_last_$1_runs/trends_by_layer_TID_Side1
mkdir CRAFT_last_$1_runs/trends_by_layer_TID_Side2
mkdir CRAFT_last_$1_runs/trends_by_layer_TEC

mv *TIB* CRAFT_last_$1_runs/trends_by_layer_TIB
mv *TOB* CRAFT_last_$1_runs/trends_by_layer_TOB
mv *TID_Side1* CRAFT_last_$1_runs/trends_by_layer_TID_Side1
mv *TID_Side2* CRAFT_last_$1_runs/trends_by_layer_TID_Side2
mv *TIDLayers* CRAFT_last_$1_runs/trends_by_layer_TID_Side1
mv *TEC* CRAFT_last_$1_runs/trends_by_layer_TEC
mv *gif CRAFT_last_$1_runs/details/
mv CRAFT_last_$1_runs/details/*superimposed* CRAFT_last_$1_runs/
mv CRAFT_last_$1_runs/details/number_of*gif CRAFT_last_$1_runs/
mv CRAFT_last_$1_runs/details/mean_number_of_tracks_per_event*.gif CRAFT_last_$1_runs/
mv CRAFT_last_$1_runs/details/*integrated*gif CRAFT_last_$1_runs/
mv *.C CRAFT_last_$1_runs/details/.
mv historicDQM.root CRAFT_last_$1_runs/details/.

#cp $baseDir/DQMServices/Diagnostic/test/index.html CRAFT_last_$1_runs/.


rm -f testHDQMInspectorSelection_lastRuns.cc
rm -f $lockFile
