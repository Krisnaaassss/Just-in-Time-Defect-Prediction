@echo off
setlocal enabledelayedexpansion

set "CURRENT_DIR=%CD%"
set "GPU_ID=0"
set "MODEL_PATH=%CURRENT_DIR%\models\codet5_base\pytorch_model.bin"
set "EVAL_FLAG=false"

:parse_args
if "%~1"=="" goto after_args
if "%~1"=="-g" (
  set "GPU_ID=%~2"
  shift
  shift
  goto parse_args
)
if "%~1"=="-e" (
  set "MODEL_PATH=%~2"
  set "EVAL_FLAG=true"
  shift
  shift
  goto parse_args
)
echo Invalid option: %~1
exit /b 1

:after_args
if not "%EVAL_FLAG%"=="false" (
  echo Eval mode is not configured in this Windows helper.
  exit /b 1
)

for %%P in (gerrit go jdt openstack platform qt) do (
  echo Fintuning CodeT5 for project: %%P
  python src\fine_tuning\finetune_JIT_SF.py ^
    --do_train ^
    --do_test ^
    --train_filename "%CURRENT_DIR%\Dataset\fine-tuning\JITDefectPrediction\Unified\%%P\changes_train.jsonl" ^
    --dev_filename "%CURRENT_DIR%\Dataset\fine-tuning\JITDefectPrediction\Unified\%%P\changes_valid.jsonl" ^
    --test_filename "%CURRENT_DIR%\Dataset\fine-tuning\JITDefectPrediction\Unified\%%P\changes_test.jsonl" ^
    --model_type codet5_CC ^
    --warmup_steps 0 ^
    --learning_rate 2e-5 ^
    --model_name_or_path "%CURRENT_DIR%\models\codet5_base" ^
    --load_model_path "%MODEL_PATH%" ^
    --output_dir "%CURRENT_DIR%\outputs\models\fine-tuning\JITDefectPrediction\SF\codet5\Unified\%%P\all_metrics\bs32_gas4_1500step" ^
    --train_batch_size 32 ^
    --gradient_accumulation_steps 4 ^
    --eval_batch_size 32 ^
    --max_source_length 512 ^
    --max_target_length 128 ^
    --gpu_id %GPU_ID% ^
    --save_steps 100 ^
    --log_steps 5 ^
    --train_steps 1500 ^
    --evaluate_sample_size -1
  if errorlevel 1 exit /b 1
)
