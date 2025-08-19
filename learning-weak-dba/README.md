
# Artifact for Paper 4797

This artifact accompanies the paper **“Efficient Learning of Weak Deterministic Büchi Automata”** (Paper ID: 4797).  
It contains all components necessary to reproduce the experimental results reported in the paper.

The artifact includes:

- **ROLL.jar** (from the ROLL Library), which implements the learning algorithms.  
- **Benchmark samples** used in the experiments.  
- **Scripts** for smoke tests and full experiments.  

---

## License

The included `ROLL.jar` originates from the [ROLL library](https://github.com/iscas-tis/roll-library), licensed under **GPL-3.0**.  
Our additional scripts and experiment setup are provided under the same license unless stated otherwise.

---

## Load Docker Image

Ensure [Docker](https://www.docker.com) is installed.  
**Note:** Docker commands typically require root access.

Load the artifact Docker image:

```bash
sudo docker load < learning-weak-dba.tar.gz
# or
sudo docker load -i learning-weak-dba.tar.gz
```

Check the image has been loaded:

```bash
sudo docker images
```

You should see `learning-weak-dba` in the image list.

Run the container:

```bash
sudo docker run -it learning-weak-dba
```

After the container starts, you should be placed in the default working directory:

```
/workspace
```

---

## Directory Structure

Inside this directory, you will find the following key files and folders related to our weak deterministic Büchi automata(wDBA) learning experiments:

- **Experiments/**  
  Contains all scripts and benchmark samples needed to replicate the experimental results reported in our paper.  
  Key files include:  

  - `ROLL.jar` – main Java tool implementing the learning algorithms.  
  - `run.sh`, `bench_run.sh`, `bench_print.sh`, `print.sh` – scripts to run experiments on benchmark samples and process results.  
  - `BenchmarkSamples/` – sample automata used as inputs for learning.  
  - `BenchmarkResults/` – folder where experimental output logs and results are saved.  
  - `get-MQ.py`, `get-EQ.py`, `get-TTO.py` – scripts to extract query and timing data from logs.  
  - `SmokeTest/` – contains smoke test scripts to verify basic functionality of the learning algorithms.

---

## Benchmarks

The experiments use two main sets wDBAs:

- `wdba/` – Randomly generated weak DBA samples created for our experiments.  
- `BenchmarkSamples/` – weak DBA obtained by converting DFA benchmarks from the [Automata Wiki](https://automata.cs.ru.nl/Downloads).

---

## File Input Format

All automata are written in the `.ba` format.  
Below is an example of a small automaton with 3 states and 2 letters:

```
[0]
a,[0]->[0]
b,[0]->[1]
c,[0]->[2]
a,[1]->[0]
b,[1]->[1]
c,[1]->[2]
a,[2]->[0]
b,[2]->[1]
c,[2]->[2]
[0]
[1]
```

---

## Installation

ROLL v1.0 is publicly available on GitHub at:  
https://github.com/iscas-tis/roll-library  
In this artifact, we include the compiled `ROLL.jar` file, so no additional installation is required.

---

## Smoke Tests

The artifact includes implementations of the **MP** algorithm (from the classic paper *On the Learnability of Infinitary Regular Sets*, JCSS 1995) as well as our **wDBA** algorithm using **TABLE** and **TREE** data structures. These smoke tests allow you to quickly verify that the artifact runs correctly without reproducing the full experiments.

The smoke test uses a **small weak deterministic Büchi automaton (wDBA)** with:  

- **States:** 10 (`[0]` through `[9]`)  
- **Alphabet:** `{a, b, c, d}`  
- **Structure:**  
  - One **accepting SCC** containing states `[2, 3, 4, 5, 6, 7, 8, 9]`.  
  - One **rejecting SCC** containing state `[1]` (a sink rejecting state).  
  - State `[0]` serves as the initial state, branching toward either the accepting or rejecting component.  
- This automaton is non-trivial yet small, making it ideal for quickly validating that the learning algorithms execute and produce reasonable results.

Navigate to the `SmokeTest` directory:

```bash
cd Experiments/SmokeTest
```

Test the MP algorithm:

```bash
./TestMP.sh
```

Expected output:

```
Running MP algorithm on ./sample.ba...
--------------------------------------------
Summary for MP Algorithm:
Total Queries: 618
TTO: 65 (ms)
Full log saved to: ./TestResults/MP-sample.txt
--------------------------------------------
```

Test the TABLE algorithm:

```bash
./TestTABLE.sh
```

Expected output:

```
Running TABLE algorithm on ./sample.ba...
--------------------------------------------
Summary for TABLE Algorithm:
Total Queries: 324
TTO: 58 (ms)
Full log saved to: ./TestResults/TABLE-sample.txt
--------------------------------------------
```

Test the TREE algorithm:

```bash
./TestTREE.sh
```

Expected output:

```
--------------------------------------------
Summary for TREE Algorithm:
Total Queries: 197
TTO: 42 (ms)
Full log saved to: ./TestResults/TREE-sample.txt
--------------------------------------------
```

**Log File Structure**  
Each smoke test saves its full output log into the `TestResults` directory (e.g., `TestResults/MP-sample.txt`).  

A typical log contains:

1. **Target wDBA description** – the original automaton definition in `.ba` format.  
2. **Learned wDBA description** – the final automaton produced by the algorithm.  
3. **Query statistics** – including:  
   - `#MQ` – Number of membership queries.  
   - `#EQ` – Number of equivalence queries.  
   - `#TTO` – Total learning time in milliseconds.  
4. **Detailed timing breakdown** – time spent in membership queries, equivalence queries, and learner processing.  

These files allow users to verify both correctness (by comparing learned automata to the target) and performance (by checking query counts and times).


---

## Full Experiments

Assuming you are inside the `Experiments` directory:

To reproduce the full benchmark results:

```bash
./run.sh
```
All output (both standard output and errors) are saved into a log file (run.log).

**Note:** Running `run.sh` may take about **1.5 hours**.

This runs all algorithms (DBA, MP, TABLE, TREE) on samples in `wdba/` and stores logs in `results/`.

To print the results:

```bash
./print.sh
```

This processes logs in `results/` and prints summary tables.

For benchmark DFA samples converted to wDBA:

**Note:** Running the full benchmark (3600 samples per size) may take around **2.5 hours**. However, since all these samples consist of only one SCC running the script on a smaller number of samples already gives the same number of queries.

```bash
./bench_run.sh
```

This runs the algorithms on samples in BenchmarkSamples/ and saves logs in BenchmarkResults/.

To print benchmark results:

```bash
./bench_print.sh
```
All output (both standard output and errors) are saved into a log file (bench_run.log). 

**Note:** In bench_run.sh, we also include the DBA algorithm with a **30-second timeout** per task. All logs (including timeouts or failures) are stored in BenchmarkResults/.

The results can be compared with the tables presented in the Experiments section of the paper’s appendix. The number of queries should match exactly, while execution times may vary by machine. Overall trends show our algorithm outperforms state-of-the-art methods.


---

## Exiting Docker

To exit Docker:

```bash
exit
```

---

## Remove Docker Image

To remove the Docker image:

```bash
sudo docker rmi -f learning-weak-dba
```

---
