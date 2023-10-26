cd /work/src

data_dir="/work/data"
file_pathes="${data_dir}/magazine_1933-1933.txt ${data_dir}/magazine_1941-1941.txt ${data_dir}/magazine_1949-1949.txt ${data_dir}/magazine_1957-1957.txt ${data_dir}/magazine_1965-1965.txt ${data_dir}/magazine_1973-1973.txt ${data_dir}/magazine_1981-1981.txt ${data_dir}/magazine_1989-1989.txt ${data_dir}/magazine_1997-1997.txt ${data_dir}/magazine_2005-2005.txt ${data_dir}/magazine_2013-2013.txt"

python3 check_target_frequency.py \
	--file_pathes $file_pathes \
	--target_words "${data_dir}"/target.txt
