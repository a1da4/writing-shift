cd /work/src

version=2
data_dir="/work/data/v${version}"
target_path="${data_dir}/target_ignore-zero.txt"
t=1e-05
thresh=20
mkdir "/work/models/v${version}"
mkdir "/work/results/v${version}"
model_dir="/work/models/v${version}/thresh-${thresh}"
result_dir="/work/results/v${version}/thresh-${thresh}"

window=5
dim=50

output_names="arawareru arawasu hakaru itadaku kaeru kaesu kiku koeru kosu naku tazuneru tukuru ukagau wakaru"
analyze_target_path="${data_dir}/targets_for_distance/target-"
analyze_target_pathes=""
for output_name in ${output_names};
do
	analyze_target_pathes="${analyze_target_pathes} ${analyze_target_path}${output_name}.txt"
done

file_pathes="${data_dir}/magazine_1933-1957.txt ${data_dir}/magazine_1989-2013.txt"

file_pathes_preprocessed=""

# Subsampling
for file_path in $file_pathes; 
do
	python3 sppmisvd/subsample.py \
		--file_path "${file_path}" \
		-t "${t}"
	
	file_path_preprocessed="${file_path}_subsampled_t-${t}"
	mv corpus_subsampled_* "${file_path_preprocessed}"
	file_pathes_preprocessed="${file_pathes_preprocessed} ${file_path_preprocessed}"
done

python3 obtain_sharedvocab.py \
	--file_pathes ${file_pathes_preprocessed} \
	--threshold "${thresh}"

mkdir "${model_dir}"
mv word2freq_* id2word* "${model_dir}"

python3 add_targetwords_into_vocab.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--target_words "${target_path}"

mv id2word.pkl "${model_dir}"

# Training
cd /work/src/sppmisvd

count=0
mat_pathes=""
for file_path in $file_pathes_preprocessed;
do
	python3 main.py \
		--file_path "${file_path}" \
		--pickle_id2word "${model_dir}"/id2word.pkl \
		--has_cds \
		--window_size "${window}" \
		--shift 1 \
		--dim "${dim}"

	mv model/C_w-"${window}" "${model_dir}"/C_w-"${window}"_"${count}"
	mat_path="${model_dir}/M_w-${window}_${count}"
	mv model/SPPMI_w-"${window}"_s-1 "${mat_path}"
	mat_pathes="${mat_pathes} ${mat_path}"

	count=$(($count+1))
done

cd /work/src/
python3 joint_decompose.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--mat_pathes ${mat_pathes} \
	--dim "${dim}"

mv WV_d-"${dim}".npy "${model_dir}"/WV_w-"${window}"_d-"${dim}".npy


# analyze
python3 calculate_neighbors.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-"${window}"_d-"${dim}".npy \
	--target_words "${target_path}" 

mkdir "${result_dir}"
mv result_targetword_neighbors.tsv "${result_dir}"/
com

python3 calculate_distance_targets.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-"${window}"_d-"${dim}".npy \
	--target_word_pathes ${analyze_target_pathes} \
	--output_names ${output_names}

for output_name in ${output_names};
do
	mv ${output_name}.tsv ${result_dir}
done

python3 visualize.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-"${window}"_d-"${dim}".npy \
	--target_word_pathes ${analyze_target_pathes} \
	--output_names ${output_names} --num_neighbors 3

for output_name in ${output_names};
do
	mv *${output_name}.png ${result_dir}
done
