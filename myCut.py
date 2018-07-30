# -*- coding: utf-8 -*-
"""
Created on Thu Jul 26 10:44:54 2018

@author: Wei Yuxuan

Original MATLAB version: myCut.m

Digitization of Flow Measurement Device by CV method
"""

import numpy as np
from PIL import Image
from skimage import filters
#import matplotlib.pyplot as plt

img = Image.open("11.jpg")
f = np.array(img)
h = abs(.5*f[:,:,0] + .5*f[:,:,1] - f[:,:,2])
#img = Image.fromarray(h)
#img.show()
thr = filters.threshold_otsu(h)
hh = (h>=thr)*255                   # 255 for visualization
#img = Image.fromarray(hh)
#img.show()                          # show the binarized
max1 = hh.sum(0).max()
max2 = hh.sum(1).max()
if max1 > max2:
    hh = hh[::-1]
    hh = hh.T
sumH = hh.sum(0)
H1 = sumH[sumH>0]
len_gap = int(len(H1)*65/1755)
left_gap = H1[0:len_gap].sum()
right_gap = H1[(len(H1)-len_gap):len(H1)].sum()
if left_gap < right_gap:
    H1 = H1[::-1]               # 一维数组左右翻转，二维矩阵上下翻转
H1 = H1[0:(len(H1)-len_gap)]
#plt.plot(H1)
const_mark_ratio = 1690
const_mark = np.array([151,196,239,283,326,369,413,456,499,541,583,624,662,701,740,
    779,818,857,896,935,973,1061,1150,1238,1326,1414,1503,1591])
const_mark = const_mark/const_mark_ratio
const_ball_ratio = 54.5161
ball_len = int(len(H1)/const_ball_ratio)
mymin = H1.max()*ball_len
ball_ind = -1
#Lmyball = np.zeros(len(H1)-ball_len)
for i in range(len(H1)-ball_len):
    myball = H1[i:(i+ball_len)].sum()
#    Lmyball[i] = myball
    if myball < mymin:
        ball_ind = i
        mymin = myball
#plt.plot(Lmyball)
ball_ind = ball_ind/len(H1)
cnt = 28
res = -1
for i in const_mark:
    if ball_ind < i:
        res = cnt
        break
    cnt = cnt - 1
print('between mark '+str(res)+' and mark '+str(res+1))