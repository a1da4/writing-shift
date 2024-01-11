################################################################################################
# FIX HERE

## path to src/
### if you use docker, main_dir is /work/src
main_dir="/work/src"
### if you use your original environment, main_dir is {YOUR_WORK_DIR}/writing-shift/src
#main_dir="~/writing-shift/src"

cd ${main_dir}

# Setting
## data directory
data_dir="/work/data"

## target file pathes (separated by space)
file_pathes="${data_dir}/file_0.txt ${data_dir}/file_1.txt ${data_dir}/file_2.txt"
################################################################################################

python3 check_target_frequency.py \
	--file_pathes $file_pathes \
	--target_words "${data_dir}"/target.txt
