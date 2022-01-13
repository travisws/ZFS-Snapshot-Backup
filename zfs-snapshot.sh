#!/bin/bash

declare -a datasets=("hdd/minecraft" "hdd/Deathpoolops")
_main(){
        for dataset in "${datasets[@]}"
	do
    	        new=8
                old=9

		while [ $new -ge 1 ]
		do			
		echo "Dataset:$dataset Num New:$new Num old:$old"

			if [ $old -eq 9 ]; then
				zfs destroy $dataset@9 2> /dev/null

			fi

			zfs rename $dataset@$new $dataset@$old 2> /dev/null
			
			if [ $new -eq 1 ]; then
				zfs snapshot -r $dataset@1 2> /dev/null
			fi

			new=$(( $new - 1 ))
			old=$(( $old - 1 ))
				
		done
	done
}

_main
