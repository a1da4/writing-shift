# writing-shift
```
 writing-shift/
 ├── example/: example of executables
 ├── scripts/: executables (shell scripts .sh) to run at once
 ├── src/: source code
 ├── Dockerfile: docker file
 └── requirements.txt: list of python packages
```

## Setting
### 1. Clone this repository
```
git clone https://github.com/a1da4/writing-shift.git
git submodule update --init --recursive
```

### 2. Create data directory

```
cd writing-shift/
```
```
mkdir data
```

Copy your corpora (e.g. file\_0.txt, file\_1.txt) into `data/`  

```
cp /path/to/your/corpora data/
```

After that, the directory structure should look like below:
```
## writing-shift/
## ├── example/
## ├── scripts/
## ├── src/
## └── data/
##     ├── file_0.txt
##     └── file_1.txt 
```

### 3. Install Packages

 - Docker (recommended) 

```
docker build -t writing-shift .
docker run -it writing-shift
```

 - PIP (use `requirements.txt`)  

```
pip install -r requirements.txt
```

## Run (Preprocess / Training / Analysis)
### 1. Run source code (.py)
```
src/: source code
├── add_targetwords_into_vocab.py: add targetword into vocaburary
├── calculate_distance_targets.py: calculate distance between target words in the same group
├── calculate_neighbors.py: calculate neighborhoods of each target word
├── check_target_frequency.py: check target word frequency in the target corpora
├── joint_decompose.py: obtain word vector matrix
├── obtain_sharedvocab.py: obtain vocaburary
└── visualize.py: plot target words and its neighborhoods
```

#### 1.0 Prepare target word list (.txt)
Create a list of target words (example: `example/target.txt`).  

If the target word set can be divided into several groups (example: `wakaru-group: 分かる(wakaru), 解る(wakaru), 別る(wakaru)`), it is even better to have files for each group (example: `example/targets_for_distance/target-wakaru.txt`).  
This is used for visualisation (`visualize.py`) and for calculating the distances between words in a group (`calculate_distance_targets.py`).

#### 1.1 Check frequency of target words
```
python3 check_targeet_frequency.py \
    --file_pathes path/to/corpus_1 path/to/corpus_2 ... path/to/corpus_n \
    --target_words path/to/target.txt
```

To train word vectors, the frequency of target words **must be** more than 0.

#### 1.2 Obtain shared vocaburary for target corpora
```
python3 obtain_sharedvocab.py \
    --file_pathes path/to/corpus_1 path/to/corpus_2 ... path/to/corpus_n \
    --threshold 20 (frequency threshold)
```
If target words do not appear in the shared vocaburary (`id2word.txt`):
```
python3 add_targetwords_into_vocab.py \
    --pickle_id2word path/to/id2word.pkl \
    --target_words path/to/target.txt
```

#### 1.3 Train word vectors
Obtain PPMI matrix for each corpus
- `--window_size`: consider before/after window_size words
- `--dim`: vector dimension
- `--shift`, `--has_cds`: recommended parameters. more information are in https://github.com/a1da4/sppmi-svd 
```
cd sppmisvd

python3 main.py \
    --file_path path/to/corpus_1 \
    --pickle path/to/id2word.pkl \
    --window_size 5 \
    --dim 50 \
    --shift 1 --has_cds

# trained vectors are in model/ directory
mv model/WV_d-50_w-5_s-1.npy model/WV_corpus_1.npy
mv model/M_w-5_s-1.npy model/M_corpus_1.npy
```
Joint decomposition to obtain word vectors
```
cd ../
python3 joint_decomposition.py \
    --pickle_id2word path/to/id2word.pkl \
    --mat_pathes path/to/M_corpus_1.npy path/to.M_corpus_2.npy ... path/to/M_corpus_n.npy \
    --dim 50

# output
WV_d-50.npy
```

#### 1.4 Analyze: calculate neighbor words of each target word
```
python3 calculate_neighbors.py \
    --pickle_id2word path/to/id2word.pkl \
    --joint_vector path/to/WV_d-50.npy \
    --target_words path/to/target.txt \
    --topk 20

# output
result_targetword_neighbors.tsv
```

#### 1.5 (Advanced) Analyze: calculate distance between target words in the same group
```
python3 calculate_distance_targets.py \
    --pickle_id2word path/to/id2word.pkl \
    --joint_vector path/to/WV_d-50.npy \
    --target_word_pathes path/to/target-group_1.txt path/to/target-group_2.txt ... path/to/target-group_m.txt \
    --output_names "group_1 group_2 ... group_m"

# output
group_1.tsv, group_2.tsv, ..., group_m.tsv
```

#### 1.6 (Advanced) Visualize: group of target words and its neighbors
```
python3 visualize.py \
    --pickle_id2word path/to/id2word.pkl \
    --joint_vector path/to/WV_d-50.npy \
    --target_word_pathes path/to/target-group_1.txt path/to/target-group_2.txt ... path/to/target-group_m.txt \
    --num_neighbors 3 \
    --output_names "group_1 group_2 ... group_m"

# output
group-single-{time span, 1 to n}_{output name}.png
group-all_{output name}.png
group-neighbor-single-{time span, 1 to n}_{output name}.png
group-neighbor-all_{output name}.png
```

### 2. Use executables (.sh)
You can run the Python scripts (.py) in `src/` yourself, but we have put executables (shell scripts, .sh) in `scripts/` that you can run at once.  
In each .sh file, you have to define directories.

<details>
<summary>Example: writing-shift/scripts/run_preprocess_train_analyze.sh</summary>
	
```
################################################################################################
# FIX HERE

## path to src/
main_dir="/work/src"

cd ${main_dir}

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

## OPTIONAL: for visualize, calculate distance within target words
## target word file names (TARGET_NAME.txt)
target_names="target_word_0 target_word_1 target_word_2"
## number of neighborhood for each target word in visualization
num_neighbors=3
## target word file pathes
analyze_target_path="${data_dir}"
analyze_target_pathes=""
for target_name in ${target_names};
do
	analyze_target_pathes="${analyze_target_pathes} ${analyze_target_path}/${target_name}.txt"
done
################################################################################################
```
</details>

After that, you can run preprocessing / training / analysis at once.
```
bash scripts/run_preprocess_train_analyze.sh
```
