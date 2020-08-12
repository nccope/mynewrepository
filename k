#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 23 14:33:02 2020

@author: user1
modified from https://github.com/IntelRealSense/librealsense/blob/master/wrappers/python/examples/read_bag_example.py
official realsense git repository
"""


# using librealsense through pyrealsense2 to extract depth or infra video stream and save using opencv

import cv2
import numpy as np
import pyrealsense2 as rs
import PIL
import PIL.Image as Image

k = 1
try:
    # Create pipeline
    pipeline = rs.pipeline()

    # Create a config object
    config = rs.config()
    # Tell config that we will use a recorded device from filem to be used by the pipeline through playback.
    rs.config.enable_device_from_file(config, '/media/user1/Bustin 1/bag/c1_cwb23000000_d20190129_t040829_id819312071224.bag')
    # Configure the pipeline to stream the depth stream
    config.enable_stream(rs.stream.depth, 1280, 720, rs.format.z16, 30)
     # Start streaming from file
    pipeline.start(config)

    # Create opencv window to render image in
    #cv2.namedWindow("Depth Stream", cv2.WINDOW_AUTOSIZE)
    
    # Create colorizer object
    colorizer = rs.colorizer();

    # Streaming loop
    while k<3000:
        # Get frameset of depth
        frames = pipeline.wait_for_frames()
        
        # Get depth frame
        depth_frame = frames.get_depth_frame()
        
        # Colorize depth frame to jet colormap
        depth_color_frame = colorizer.colorize(depth_frame)

        # Convert depth_frame to numpy array to render image in opencv
        depth_color_image = np.asanyarray(depth_color_frame.get_data())
        
        # Render image in opencv window
        #cv2.imshow("Depth Stream", depth_color_image)
        if k % 30 == 0:          
            im_baby = Image.fromarray(depth_color_image)
            print('save')
        #Image.show(im_baby)
            im_baby = im_baby.save('newdepthex'+str(k/30)+'.png')
        k+=1
        key = cv2.waitKey(1)
        # if ESCAPE key pressed, exit program
        if key == 27:
            cv2.destroyAllWindows()
            break
    
finally:
    pass
