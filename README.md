# writing-shift

## Setting
1. Clone this repository
```
git clone https://github.com/a1da4/writing-shift.git
```

2. Create data directory

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
ls .

## writing-shift/
##  ├── example/
##  ├── scripts/
##  ├── src/
##  └── data/
##       ├── file\_0.txt
##       └── file\_1.txt 
```

3. Install Packages

 - Docker (recommended) 

```
docker build -t writing-shift .
docker run -it writing-shift
```

 - PIP (use `requirements.txt`)  

```
pip install -r requirements.txt
```
