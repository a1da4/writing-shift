cd ../src

data_dir="/work/data"
model_dir="/work/models/thresh-20"
result_dir="/work/results/thresh-20"

python3 calculate_neighbors.py \
	--pickle_id2word "${model_dir}"/id2word.pkl \
	--joint_vector "${model_dir}"/WV_w-10_d-100.npy \
	--target_words "${data_dir}"/target.txt 

mkdir "${result_dir}"
mv result_targetword_neighbors.tsv "${result_dir}"/
