cd /work/src

version=2
data_dir="/work/data/v${version}"
output_names="arawareru arawasu hakaru itadaku kaeru kaesu kiku koeru kosu naku tazuneru tukuru ukagau wakaru"
target_path="${data_dir}/targets_for_distance/target-"
target_pathes=""
for output_name in ${output_names};
do
	target_pathes="${target_pathes} ${target_path}${output_name}.txt"
done
t=1e-05
thresh=20
model_dir="/work/models/v${version}/thresh-${thresh}_ignore-zero"
result_dir="/work/results/v${version}/thresh-${thresh}_ignore-zero"

window=5
dim=50

python3 calculate_distance_targets.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-"${window}"_d-"${dim}".npy \
	--target_word_pathes ${target_pathes} \
	--output_names ${output_names}

python3 calculate_neighbors.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-"${window}"_d-"${dim}".npy \
	--target_words /work/data/v2/target_ignore-zero.txt

mkdir "${result_dir}"
mv *.tsv "${result_dir}"
