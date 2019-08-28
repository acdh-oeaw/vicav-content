# VICAV dictionary export script

# path to dictionary pattern list
list="vicav_dicts.txt"
# path to basex
localbasex="$HOME/bin/basex"
# the ssh key to use
key="~/.ssh/id_rsa"
#output path

sed -e 's/[[:space:]]*#.*// ; /^[[:space:]]*$/d' "$list" | while read line
do
  echo "===="
  echo "db pattern: $line"
	# get filename of last backup

  cmd="find ~/backup -regextype posix-extended -regex $line | sort -r | head -1"
  fpath=`ssh -n basex-curation@minerva $cmd`

  backupfn=`basename $fpath .zip`
  echo "last backup for $line: $fpath"

  #copy the backup into the local basex data directory
  scp -i $key basex-curation@minerva:"$fpath" $localbasex/data
  #restore the backup
  echo "restoring backup"
  $localbasex/bin/basex -c"RESTORE $backupfn" -v
  # database name
  dbname=`echo $backupfn | sed -e 's/-[[:digit:]]\{4,4\}\(-[[:digit:]]\{2,2\}\)\{5,5\}//g'`
  if [[ $dbname =~ "__skel" ]]
  then
    echo "merging split dictionary $dbname"
    mergedfn=`echo $backupfn | sed -e 's/__skel//g'`
    # if it is a skeleton dict, run the merge script
    $localbasex/bin/basex -bdict-skel="$dbname" merge_split_dicts.xquery > "../vicav_dicts/$mergedfn.xml"

  fi

done
