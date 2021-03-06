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
