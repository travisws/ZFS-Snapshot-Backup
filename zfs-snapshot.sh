#!/bin/bash
new=7
old=8

#TODO Auto add new datesets by scaning for new datasets by possibly using (zfs list) and adding it to a array
#Add path to zfs dataset to backup
declare -a datasets=("ssd/minecraft")

#Runs through the array and zfs destoroys all zfs dataset ending with 9th day

#Run a Zfs rename command to rename a dataset form the array starting with @8 moving it to @9 and working it way down from 8 to 9, 7 to 8, 6 to 7, 5 to 6, 4 to 5, 3 to 4, 2 to 3 and 1 to 2.
#it makes room for new snapshots to be added and removes any snapshots the end in @9 witch can be change by changing the 2 variables (new) and (old) as long as new is lower then old by 1 digit.
snapshot_rename(){
        for dataset in "${datasets[@]}"
        do
                #resets vars to use in the interation in the array
                echo $dataset
                new=8
                old=9

                #checks to see if any snapshots for the Zfs dataset exist by looking for any snapshots end with @1
                #TODO add a more determining/robust way of checking for snapshots
                if [ $(zfs list -t snapshot -o name | grep 1) ]; then

                        #Test to see if any dataset has a snapshot ending in @9 and then removes that dataset ending in @9. I.E ssd/minecraft@9 would be remmoved and so on for each dataset in then array
                        while [ $old -ge 1 ]
                        do
                                if [ $(zfs list -t snapshot -o name | grep 9) ]; then

                                        #uncommet when all testing is done. Just in case of data loss
                                        zfs destroy $dataset@9
                                        echo "hello"

                                fi
                                #Run a Zfs command to rename a dataset form the array starting with @8 moving it to @9 and working it way down from 8, 7, 6, 5, 4, 3, 2 and 1.  it makes room for new snapshots to be added
                                zfs rename $dataset@$new $dataset@$old
                                new=$(( $new - 1 ))
                                old=$(( $old - 1 ))

                        done

                        for dataset in "${datasets[@]}"
                        do
                                zfs snapshot -r $dataset@1
                        done;

                else

                        for dataset in "${datasets[@]}"
                        do
                                zfs snapshot -r $dataset@1
                        done;

                fi

        done
}

snapshot_rename
