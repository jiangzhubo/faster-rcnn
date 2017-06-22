#!/bin/bash
# before starting training, please run beforetraining.sh firstly and then remove the cache
# folder and output folder to prevent confusing with previous training procedure

log=$1
NET=$2
logfile="/home/graymatics/py-faster-rcnn/prepared_data/logfiles/log_$log.txt"
#removing the cache and output folder 
cache_path="/home/graymatics/py-faster-rcnn/data/cache/"
output_path="/home/graymatics/py-faster-rcnn/output/faster_rcnn_alt_opt"

echo "cache_path is $cache_path !"
echo "output_path is $output_path !"
rm -r $cache_path
rm -r $output_path

#Please make sure the training data is already prepared before running starttraining.sh
while true; do
	read -p "is the training data prepared well? have you run the beforetraining.sh file?
		(y/n)" yn
	case $yn in 
		[Yy]* ) echo "start training!";break;;
		[Nn]* ) echo "Please make sure the training data is well prepared!";exit;;
		* ) 	echo "Please answer y or n!";;
	esac
done

cd ~/py-faster-rcnn   #return to the py-faster-rcnn folder
#using nohup and symbol "&" to make sure the training process is runing background
nohup ./experiments/scripts/faster_rcnn_alt_opt.sh 0 $NET pascal_voc > $logfile&
tail -f $logfile



