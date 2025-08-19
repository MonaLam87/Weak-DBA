# Random wDBA Generation Scripts

This folder contains scripts to generate and validate random weak deterministic Büchi automata (wDBA) samples. These scripts were used to generate the set of random wDBAs used in our experiments.

## Scripts

### `wdba-gen.sh`
- Generates wDBA samples of different sizes.
- Creates output directories under:
  - `wdba/SizeXX` for the generated automata.
  - `info/SizeXX` for logs of generation and validation.
- Calls `wdba-gen.py` to generate each sample.
- Validates samples using the ROLL library via `ROLL.jar`.
- Moves valid samples to the appropriate folder based on size.
- Logs generation and validation details in the corresponding `info` folder.


## How to Run

1. Make sure `ROLL.jar` is accessible in the parent directory.  
2. Ensure Python 3 is installed for `wdba-gen.py`.  
3. Run the generator script for new samples:

## Generating Random wDBAs

1. Make the script executable:

```bash
chmod +x wdba-gen.sh

2. Run the script:

```bash
bash wdba-gen.sh


