import os
import re
import argparse

def compute_average_eq(folder_path, prefix):
    total_eq = 0
    eq_count = 0
    eq_pattern = re.compile(r"#EQ = ([\d.]+)")

    for root, _, files in os.walk(folder_path):
        for file_name in files:
            if file_name.startswith(prefix):
                file_path = os.path.join(root, file_name)
                try:
                    with open(file_path, 'r') as file:
                        for line in file:
                            match = eq_pattern.search(line)
                            if match:
                                try:
                                    eq_value = float(match.group(1))
                                    total_eq += eq_value
                                    eq_count += 1
                                except ValueError:
                                    print(f"Invalid #EQ value in file: {file_path}")
                except Exception as e:
                    print(f"Error reading file {file_path}: {e}")
    
    if eq_count > 0:
        avg = total_eq / eq_count
        print(f"{prefix} Average #EQ = {avg:.2f}")
        return avg
    else:
        print(f"No valid {prefix} #EQ values found.")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate average #EQ values.")
    parser.add_argument("folder_path", type=str, help="Path to the folder containing the files.")
    args = parser.parse_args()

    avg_dba = compute_average_eq(args.folder_path, "DBA")
    avg_mp = compute_average_eq(args.folder_path, "MP")
    avg_table = compute_average_eq(args.folder_path, "Table")
    avg_tree = compute_average_eq(args.folder_path, "Tree")

    # Print all on one line if all are available
    if None not in (avg_dba, avg_mp, avg_table, avg_tree):
        print(f"{avg_dba:.2f} {avg_mp:.2f} {avg_table:.2f} {avg_tree:.2f}")
