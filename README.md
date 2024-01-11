# writing-shift
```
 writing-shift/
 ├── example/: example of executables
 ├── scripts/: executables (shell scripts .sh) to run at once
 ├── src/
 │   ├── add_targetwords_into_vocab.py: add targetword into vocaburary
 │   ├── calculate_distance_targets.py: calculate distance between target words in the same group
 │   ├── calculate_neighbors.py: calculate neighborhoods of each target word
 │   ├── check_target_frequency.py: check target word frequency in the target corpora
 │   ├── joint_decompose.py: obtain word vector matrix
 │   ├── obtain_sharedvocab.py: obtain vocaburary
 │   └── visualize.py: plot target words and its neighborhoods
 ├── Dockerfile: docker file
 └── requirements.txt: list of python packages
```

## Setting
### 1. Clone this repository
```
git clone https://github.com/a1da4/writing-shift.git
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
