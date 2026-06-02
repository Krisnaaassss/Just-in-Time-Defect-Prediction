@echo off
setlocal

set "CURRENT_DIR=%CD%"
set "GPU_ID=0"
set "PROJECT=gerrit"
set "MODEL_PATH=%CURRENT_DIR%\models\codet5_base\pytorch_model.bin"

echo Smoke fine-tuning CodeT5 for project: %PROJECT%
python src\fine_tuning\finetune_JIT_SF.py ^
  --do_train ^
  --do_test ^
  --train_filename "%CURRENT_DIR%\Dataset\fine-tuning\JITDefectPrediction\Unified\%PROJECT%\changes_train.jsonl" ^
  --dev_filename "%CURRENT_DIR%\Dataset\fine-tuning\JITDefectPrediction\Unified\%PROJECT%\changes_valid.jsonl" ^
  --test_filename "%CURRENT_DIR%\Dataset\fine-tuning\JITDefectPrediction\Unified\%PROJECT%\changes_test.jsonl" ^
  --model_type codet5_CC ^
  --warmup_steps 0 ^
  --learning_rate 2e-5 ^
  --model_name_or_path "%CURRENT_DIR%\models\codet5_base" ^
  --load_model_path "%MODEL_PATH%" ^
  --output_dir "%CURRENT_DIR%\outputs\models\fine-tuning\JITDefectPrediction\SF\codet5\Unified\%PROJECT%\smoke_bs2_gas8_50step" ^
  --train_batch_size 2 ^
  --gradient_accumulation_steps 1 ^
  --eval_batch_size 2 ^
  --max_source_length 512 ^
  --max_target_length 128 ^
  --gpu_id %GPU_ID% ^
  --save_steps 25 ^
  --log_steps 1 ^
  --train_steps 50 ^
  --evaluate_sample_size 200
