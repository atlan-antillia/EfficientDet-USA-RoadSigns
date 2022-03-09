# EfficientDet-USA-RoadSigns
Training and detection RoadSigns in US by EfficientDet

<h2>
EfficientDet USA RoadSigns (Updated: 2022/03/10)
</h2>

This is a simple python example to train and detect RoadSigns in US based on 
<a href="https://github.com/google/automl/tree/master/efficientdet">Google Brain AutoML efficientdet</a>.
<br>

<h3>
1. Installing tensorflow on Windows10
</h3>
We use Python 3.8.10 to run tensoflow 2.4.0 on Windows10.<br>
At first, please install <a href="https://visualstudio.microsoft.com/ja/vs/community/">Microsoft Visual Studio Community</a>, which can be used to compile source code of 
<a href="https://github.com/cocodataset/cocoapi">cocoapi</a> for PythonAPI.<br>
Subsequently, please create a working folder "c:\google" folder for your repository, and install the python packages.<br>

<pre>
>mkdir c:\google
>cd    c:\google
>pip install -r requirements.txt
>git clone https://github.com/cocodataset/cocoapi
>cd cocoapi/PythonAPI
</pre>
You have to modify extra_compiler_args in setup.py in the following way:<br>
   extra_compile_args=[],
<pre>
>python setup.py build_ext install
</pre>

<br>
<br>
<h3>
2. Installing EfficientDet-USA-RoadSigns
</h3>
Please clone EfficientDet-USA-RoadSigns in the working folder <b>c:\google</b>.<br>
<pre>
>git clone  https://github.com/atlan-antillia/EfficientDet-USA-RoadSigns.git<br>
</pre>
You can see the following folder <b>projects</b> in  EfficientDet-USA-RoadSigns folder of the working folder.<br>

<pre>
EfficientDet-USA-RoadSigns
└─projects
    └─USA_RoadSigns
        ├─outputs
        ├─saved_model
        │  └─variables
        ├─test
        ├─train
        ├─valid
        └─__pycache__
</pre>
<br>
<b>Note:</b><br>
 The USA_RoadSigns tfrecord dataset has been taken from  
 <a href="https://github.com/sarah-antillia/TFRecord_Roadsigns">TFRecord_RoadSigns</a>
<br>
USA RoadSigns <br>
<img src="./asset/roadsigns_list.png"> 
<br>

<h3>3. Inspect tfrecord</h3>
  If you would like to inspect tfrecord, you can use   
<a href="https://github.com/jschw/tfrecord-view">tfrecord_view_gui.py</a>, or 
<a href="https://github.com/EricThomson/tfrecord-view">view_tfrecord_tf2.py</a>.
<br>
  We have created <a href="./TFRecordInspector.py">TFRecordInspector.py</a> 
from the original <i>view_tfrecord_tf2.py</i> to be able 
to read a tfrecord file and label_map.pbtxt file on the command line.<br>
Run the following command to inspect train.tfreord.<br>
<pre>
>python TFRecordInspector.py ./projects/USA_RoadSigns/valid/valid.tfrecord ./projects/USA_RoadSigns/train/label_map.pbtxt ./inspector/valid
</pre>
<br><br>
This will generate annotated images with bboxes and labels from the tfrecord, and cout the number of annotated objects in it.<br>
<br>
<b>TFRecordInspecotr: annotated images in train.tfrecord</b><br>
<img src="./asset/tfrecord_inspector_train.png">
<br>
<br>
<b>TFRecordInspecotr: objects_count train.tfrecord</b><br>
<img src="./asset/tfrecord_inspector_train_objects_count.png">
<br>
This bar graph shows that the number of the objects are almost uniformly distributed.
<br>
<br>
<br>
<h3>4. Downloading the pretrained-model efficientdet-d0</h3>
Please download an EfficientDet model chekcpoint file <b>efficientdet-d0.tar.gz</b>, and expand it in <b>EfficientDet-USA-RoadSigns</b> folder.<br>
<br>
https://storage.googleapis.com/cloud-tpu-checkpoints/efficientdet/coco2/efficientdet-d0.tar.gz
<br>
See: https://github.com/google/automl/tree/master/efficientdet<br>


<h3>5. Training USA RoadSigns Model by using pretrained-model</h3>
We use the usa_roadsigns_train.bat file.
We created a main2.py from main.py to be able to write COCO metrics to a csv files.

<pre>
usa_roadsigns_train.bat
python main2.py ^
  --mode=train_and_eval ^
  --train_file_pattern=./projects/USA_RoadSigns/train/train.tfrecord  ^
  --val_file_pattern=./projects/USA_RoadSigns/valid/valid.tfrecord ^
  --model_name=efficientdet-d0 ^
  --hparams="input_rand_hflip=False,image_size=512,label_map=./projects/USA_RoadSigns/label_map.yaml" ^
  --model_dir=./projects/USA_RoadSigns/models ^
  --label_map_pbtxt=./projects/USA_RoadSigns/label_map.pbtxt ^
  --eval_dir=./projects/USA_RoadSigns/eval ^
  --ckpt=efficientdet-d0  ^
  --train_batch_size=4 ^
  --early_stopping=map ^
  --patience=10 ^
  --eval_batch_size=4 ^
  --eval_samples=800  ^
  --num_examples_per_epoch=1600 ^
  --num_epochs=300   

</pre>

<table style="border: 1px solid #000;">
<tr>
<td>
--mode</td><td>train_and_eval</td>
</tr>
<tr>
<td>
--train_file_pattern</td><td>./projects/USA_RoadSigns/train/train.tfrecord</td>
</tr>
<tr>
<td>
--val_file_pattern</td><td>./projects/USA_RoadSigns/valid/valid.tfrecord</td>
</tr>
<tr>
<td>
--model_name</td><td>efficientdet-d0</td>
</tr>
<tr><td>
--hparams</td><td>"input_rand_hflip=False,image_size=512,label_map=./projects/USA_RoadSigns/label_map.yaml"
</td></tr>
<tr>
<td>
--model_dir</td><td>./projects/USA_RoadSigns/models</td>
</tr>
<tr><td>
--label_map_pbtxt</td><td>./projects/USA_RoadSigns/label_map.pbtxt
</td></tr>

<tr><td>
--eval_dir</td><td>./projects/USA_RoadSigns/eval
</td></tr>

<tr>
<td>
--ckpt</td><td>efficientdet-d0</td>
</tr>
<tr>
<td>
--train_batch_size</td><td>4</td>
</tr>
<tr>
<td>
--early_stopping</td><td>map</td>
</tr>
<tr>
<td>
--patience</td><td>10</td>
</tr>

<tr>
<td>
--eval_batch_size</td><td>4</td>
</tr>
<tr>
<td>
--eval_samples</td><td>800</td>
</tr>
<tr>
<td>
--num_examples_per_epoch</td><td>1600</td>
</tr>
<tr>
<td>
--num_epochs</td><td>300</td>
</tr>
</table>
<br>
<br>
<b>label_map.yaml</b>
<pre>
1: 'Added_lane'
2: 'Added_lane_from_entering_roadway'
3: 'Bicycles'
4: 'Bicycles_and_pedestrians'
5: 'Bike_lane'
6: 'Bike_lane_slippery_when_wet'
7: 'Bump'
8: 'Chevron_alignment'
9: 'Circular_intersection_warning'
10: 'Cross_roads'
11: 'Curve'
12: 'Deer_crossing'
13: 'Detour'
14: 'Dip'
15: 'Do_not_enter'
16: 'Do_not_rive_on_tracks'
17: 'End_detour'
18: 'Go_on_slow'
19: 'Hairpin_curve'
20: 'Hazardous_material_prohibited'
21: 'Hazardous_material_route'
22: 'Hill_bicycle'
23: 'Keep_left'
24: 'Keep_right'
25: 'Lane_ends'
26: 'Left_turn_only'
27: 'Left_turn_or_straight'
28: 'Low_clearance'
29: 'Merge'
30: 'Merging_traffic'
31: 'Metric_low_clearance'
32: 'Minimum_speed_limit_40'
33: 'Minimum_speed_limit_60km'
34: 'Narrow_bridge'
35: 'Night_speed_limit_45'
36: 'Night_speed_limit_70km'
37: 'No_bicycles'
38: 'No_large_trucks'
39: 'No_left_or_u_turn'
40: 'No_left_turn'
41: 'No_parking'
42: 'No_pedestrian_crossing'
43: 'No_right_turn'
44: 'No_straight_through'
45: 'No_turns'
46: 'No_u_turn'
47: 'One_direction'
48: 'Parking_with_time_restrictions'
49: 'Pass_on_either_side'
50: 'Pass_road'
51: 'Path_narrows'
52: 'Pedestrian_crossing'
53: 'Railroad_crossing'
54: 'Railroad_crossing_ahead'
55: 'Reserved_parking_wheelchair'
56: 'Reverse_curve'
57: 'Reverse_turn'
58: 'Right_turn_only'
59: 'Right_turn_or_straight'
60: 'Road_closed'
61: 'Road_closed_ahead'
62: 'Road_narrows'
63: 'Road_slippery_when_wet'
64: 'Rough_road'
65: 'School_advance'
66: 'School_bus_stop_ahead'
67: 'Sharp_turn'
68: 'Side_road_at_an_acute_angle'
69: 'Side_road_at_a_perpendicular_angle'
70: 'Speed_limit_50'
71: 'Speed_limit_80km'
72: 'Steep_grade'
73: 'Steep_grade_percentage'
74: 'Stop'
75: 'Straight_ahead_only'
76: 'Tractor_farm_vehicle_crossing'
77: 'Truck_crossing'
78: 'Truck_crossing_2'
79: 'Truck_rollover_warning'
80: 'Truck_speed_Limit_40'
81: 'Two_direction'
82: 'Two_way_traffic'
83: 'T_roads'
84: 'Winding_road'
85: 'Yield'
86: 'Y_roads'
</pre>
<br>
<br>
<br>
<b>COCO meticss f and map</b><br>
<img src="./asset/coco_metrics.png" width="1024" height="auto">
<br>
<br>
<b>Train losses at epoch</b><br>
<img src="./asset/train_losses_epoch.png" width="1024" height="auto">
<br>
<br>
<b>COCO ap per class at epoch</b><br>
<img src="./asset/coco_ap_per_class_epoch.png" width="1024" height="auto">
<br>
<br>
<br>
<h3>
6. Create a saved_model from the checkpoint
</h3>
 We use the following usa_roadsigns_create_saved_model.bat file.
<pre>
python model_inspect.py ^
  --runmode=saved_model ^
  --model_name=efficientdet-d0 ^
  --ckpt_path=./projects/USA_RoadSigns/models  ^
  --hparams="image_size=512x512" ^
  --saved_model_dir=./projects/USA_RoadSigns/saved_model

</pre>

<table style="border: 1px solid #000;">
<tr>
<td>--runmode</td><td>saved_model</td>
</tr>

<tr>
<td>--model_name </td><td>efficientdet-d0 </td>
</tr>

<tr>
<td>--ckpt_path</td><td>./projects/USA_RoadSigns/models</td>
</tr>

<tr>
<td>--hparams</td><td>"image_size=512x512" </td>
</tr>

<tr>
<td>--saved_model_dir</td><td>./projects/USA_RoadSigns/saved_model</td>
</tr>
</table>

<br>
<br>
<h3>
7. Detect USA_road_signs by using a saved_model
</h3>
 We use the following usa_roadsigns_detect.bat file.
<pre>
python model_inspect.py ^
  --runmode=saved_model_infer ^
  --model_name=efficientdet-d0 ^
  --saved_model_dir=./projects/USA_RoadSigns/saved_model ^
  --min_score_thresh=0.3 ^
  --hparams=./projects/USA_RoadSigns/configs/detect.yaml ^
  --input_image=./projects/USA_RoadSigns/test/*.jpg ^
  --output_image_dir=./projects/USA_RoadSigns/outputs
</pre>

<table style="border: 1px solid #000;">
<tr>
<td>--runmode</td><td>saved_model_infer </td>
</tr>

<tr>
<td>--model_name</td><td>efficientdet-d0 </td>
</tr>

<tr>
<td>--saved_model_dir</td><td>./projects/USA_RoadSigns/saved_model </td>
</tr>

<tr>
<td>--min_score_thresh</td><td>0.3 </td>
</tr>

<tr>
<td>--hparams</td><td>./projects/USA_RoadSigns/configs/detect.yaml </td>
</tr>

<tr>
<td>--input_image</td><td>./projects/USA_RoadSigns/test/*.jpg </td>
</tr>

<tr>
<td>--output_image_dir</td><td>./projects/USA_RoadSigns/outputs</td>
</tr>
</table>
<br>
<h3>
8. Some detection results of USA RoadSigns
</h3>

<img src="./projects/USA_RoadSigns/outputs/1.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/2.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/3.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/4.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/5.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/6.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/7.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/8.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/9.jpg" width="512" height="auto"><br>
<img src="./projects/USA_RoadSigns/outputs/10.jpg" width="512" height="auto"><br>

