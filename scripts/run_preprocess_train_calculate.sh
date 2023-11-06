cd /work/src

# Setting
## data directory
data_dir="/work/data"
## parameter of subsampling
t=1e-05
## frequency threshold
thresh=20

## model directory
model_dir="/work/models/thresh-${thresh}"
## result directory
result_dir="/work/results/thresh-${thresh}"

## window size
window=10
## dimension size
dim=100

## target file pathes (separated by space)
file_pathes="${data_dir}/file_0.txt ${data_dir}/file_1.txt ${data_dir}/file_2.txt"

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
        --target_words "${data_dir}"/target.txt

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


python3 calculate_neighbors.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-10_d-100.npy \
	--target_words "${data_dir}"/target.txt 

mkdir "${result_dir}"
mv result_targetword_neighbors.tsv "${result_dir}"/
