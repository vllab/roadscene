import numpy as np
import matplotlib.pyplot as plt
import os.path
import json
import scipy
import argparse
import math
import pylab
import scipy.io as sio
from numpy import loadtxt
from sklearn.preprocessing import normalize
caffe_root = '/mnt/data/amy_data/SegNet/caffe-segnet_/' 			# Change this to the absolute directoy to SegNet Caffe
import sys
sys.path.insert(0, caffe_root + 'python')

import caffe

list_path = "/mnt/data/amy_data/SegNet/final_model/list/"			# set the path of your data list 
p = '/mnt/data/amy_data/SegNet/final_model/0703/joint_train/result'		# set the path of results

# Import arguments
parser = argparse.ArgumentParser()
parser.add_argument('--folder', type=str, required=True) #
parser.add_argument('--model', type=str, required=True)
parser.add_argument('--weights', type=str, required=True)
parser.add_argument('--iter', type=int, required=True)
args = parser.parse_args()

line = loadtxt("/mnt/data/amy_data/SegNet/final_model/list/" args.folder ".txt", dtype='str')

caffe.set_mode_gpu()

net = caffe.Net(args.model,
                args.weights,
                caffe.TEST)


for i in range(0, len(line)):
	net.forward()

	image = net.blobs['data'].data
	label = net.blobs['label'].data
        label_attr = net.blobs['label_attr'].data
	predicted = net.blobs['prob'].data
        predicted_attr = net.blobs['prob_attr'].data
	image = np.squeeze(image[0,:,:,:])
	output = np.squeeze(predicted[0,:,:,:])
        output_attr = np.squeeze(predicted_attr[0,:,:,:])
        label = np.squeeze(label[0,:,:,:])
        label_attr = np.squeeze(label_attr[0,:,:,:])
	ind = np.argmax(output, axis=0)
        
        image = np.transpose(image, (1,2,0))
	output = np.transpose(output, (1,2,0))
        label_attr = np.transpose(label_attr, (1,2,0))
        output_attr = np.transpose(output_attr, (1,2,0))

	folder = args.folder+'/'
        
	print i
	if not os.path.isdir(p+folder):
	    os.makedirs(p+folder)

	sio.savemat(p+folder+line[i]+'.mat',mdict={'label_attr':label_attr, 'label':label, 'output': output, 'output_attr': output_attr, 'ind': ind})

print 'Success!'

