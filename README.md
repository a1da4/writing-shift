# writing-shift

## Setting
1. Clone this repository
```
% git clone https://github.com/a1da4/writing-shift.git

```

2. Create data directory

```
% cd writing-shift/

% mkdir data

# copy your corpora (e.g. file_0.txt, file_1.txt) into data/
% cp /path/to/your/corpora data/

## writing-shift/
##  ├── example/
##  ├── scripts/
##  ├── src/
##  └── data/
##       ├── file_0.txt
##       └── file_1.txt 
```

3. Install Packages

 - Docker (recommended) 

```
% docker build -t writing-shift .

% docker run -it writing-shift
```

 - PIP (use `requirements.txt`)  

```
% pip install -r requirements.txt
```
