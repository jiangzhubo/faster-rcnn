#!/bin/bash
#./StartTrain.sh --datasetname --num_classes+background 
#this file is used for preparing training data and modify the prototxt files

set -x

# Input two arguments,which include one name of folder-training data, another \
# is the number of classes of training data
dataset=$1
num_classes=$2		     #this number of classes includes "__background__"
net=$3                       #choose which net you want to use zf--ZF vgg--VGG16
num_bbox_pred=`expr $num_classes \* 4`;

#Judge if both arguments are give
if [ -z "$dataset" ];then
	echo "The dataset argument should be given!"
	echo "Please enter the dataset name: ";
	read dataset
	echo " the dataset is given: $dataset "
else
	echo "the dataset parameter is already given: $dataset"
fi

if [ -z "$num_classes" ];then
        echo "The num_classes argument should be given!"
        echo "Please enter the number of classes,which should be a No.: ";
        read num_classes
        echo " the num_classes is given: $num_classes "
else
        echo "the num_classes parameter is already given: $num_classes"
fi


#setup the paths of dataset
input_datapath="/home/graymatics/py-faster-rcnn/prepared_data"
output_datapath="/home/graymatics/py-faster-rcnn/data/VOCdevkit2007"
prototxt="/home/graymatics/py-faster-rcnn/models/pascal_voc/$net/faster_rcnn_alt_opt"

#check if the folder exists.If not, exit and give some prompt to the user
if [ ! -d "$input_datapath/$dataset" ]; then
	echo "The $dataset folder doesn't exist! please check the training dataset
		firstly!";exit;
fi

#change the xmin and ymin coordinates to 3 if they are 0s or 1s
cd $input_datapath/$dataset/Annotations
grep -rl '<ymin>0</ymin>' ./ |xargs sed -i 's#<ymin>0</ymin>#<ymin>2</ymin>#g'
grep -rl '<ymin>1</ymin>' ./ |xargs sed -i 's#<ymin>1</ymin>#<ymin>2</ymin>#g'
grep -rl '<xmin>0</xmin>' ./ |xargs sed -i 's#<xmin>0</xmin>#<xmin>2</xmin>#g'
grep -rl '<xmin>1</xmin>' ./ |xargs sed -i 's#<xmin>1</xmin>#<xmin>2</xmin>#g'

#return to py-faster-rcnn
cd ~/py-faster-rcnn

#clear the data in VOCdevkit2007
rm -r $output_datapath/VOC2007
if [ ! -d "$output_datapath/VOC2007" ]; then
	mkdir $output_datapath/VOC2007
fi

#copy the training dataset to VOCdeckit2007/VOC2007
cp -r $input_datapath/$dataset/* $output_datapath/VOC2007


#modify the parameters in prototxt files
rm -r $prototxt
if [ ! -d "$prototxt" ]; then
	mkdir $prototxt
fi
cp -r $input_datapath/faster_rcnn_alt_opt/$net/* $prototxt/
cd $prototxt

grep -rl "'num_classes': num_classes" stage1_fast_rcnn_train.pt | xargs sed -i "s#'num_classes': num_classes#'num_classes': $num_classes#g"
grep -rl "'num_classes': num_classes" stage2_fast_rcnn_train.pt | xargs sed -i "s#'num_classes': num_classes#'num_classes': $num_classes#g"
grep -rl "num_output: num_classes" stage1_fast_rcnn_train.pt | xargs sed -i "s#num_output: num_classes#num_output: $num_classes#g"
grep -rl "num_output: num_classes" stage2_fast_rcnn_train.pt | xargs sed -i "s#num_output: num_classes#num_output: $num_classes#g"
grep -rl "num_output: num_bbox_pred" stage1_fast_rcnn_train.pt | xargs sed -i "s#num_output: num_bbox_pred#num_output: $num_bbox_pred#g"
grep -rl "num_output: num_bbox_pred" stage2_fast_rcnn_train.pt | xargs sed -i "s#num_output: num_bbox_pred#num_output: $num_bbox_pred#g"
  
grep -rl "'num_classes': num_classes" stage1_rpn_train.pt | xargs sed -i "s#'num_classes': num_classes#'num_classes': $num_classes#g"
grep -rl "'num_classes': num_classes" stage2_rpn_train.pt | xargs sed -i "s#'num_classes': num_classes#'num_classes': $num_classes#g" 
  
grep -rl "num_output: num_classes" faster_rcnn_test.pt | xargs sed -i "s#num_output: num_classes#num_output: $num_classes#g"
grep -rl "num_output: num_bbox_pred" faster_rcnn_test.pt | xargs sed -i "s#num_output: num_bbox_pred#num_output: $num_bbox_pred#g"

#copy the default file to pascal_voc.py
cd ~/py-faster-rcnn/lib/datasets/
cp pascal_voc_default.py pascal_voc.py 
