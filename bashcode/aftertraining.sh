#!/bin/bash

rcnndir=$1 #this argument is the folder name that you want to creat
NET=$2
save_path="/home/graymatics/py-faster-rcnn/RCNN_model" #path to put the new model and prototxt file
prototxt_path="/home/graymatics/py-faster-rcnn/models/pascal_voc/$NET/faster_rcnn_alt_opt"
caffemodel_path="/home/graymatics/py-faster-rcnn/output/faster_rcnn_alt_opt/voc_2007_trainval"


#check if the folder exists. If not, create it, and if it exists,just skip
if [ ! -d "$save_path/$rcnndir" ]; then
	mkdir $save_path/$rcnndir
elif [ -d "$save_path/$rcnndir" ]; then
	echo "this folder already exists!";
	echo "Please enter a new name: ";
	read rcnndir
	echo "new name for rcnndir is $rcnndir"
	mkdir $save_path/$rcnndir
fi

#copy all useful files to the folder we created
cp $prototxt_path/faster_rcnn_test.pt $save_path/$rcnndir/"$rcnndir".pt
cp $caffemodel_path/VGG16_faster_rcnn_final.caffemodel $save_path/$rcnndir/"$rcnndir".caffemodel
cp "/home/graymatics/py-faster-rcnn/bashcode/classesmap.py" $save_path/$rcnndir/"$rcnndir".py
cp -r "/home/graymatics/py-faster-rcnn/data/VOCdevkit2007/VOC2007" $save_path/$rcnndir/"$rcnndir"_data

#compress this folder and upload the zip file to s3 server to backup
cd $save_path
zip -r "$rcnndir"_rcnn.zip $rcnndir
echo "the compression is done!"
s3cmd put "$rcnndir"_rcnn.zip s3://user_backup_data/shuen/
echo "congratulations! everything is done!"





