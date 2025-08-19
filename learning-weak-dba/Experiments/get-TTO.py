import os
import re
import argparse

def compute_average_tto(folder_path, prefix):
    total_tto = 0
    tto_count = 0
    tto_pattern = re.compile(r"#TTO = ([\d.]+)")

    for root, _, files in os.walk(folder_path):
        for file_name in files:
            if file_name.startswith(prefix):
                file_path = os.path.join(root, file_name)
                try:
                    with open(file_path, 'r') as file:
                        for line in file:
                            match = tto_pattern.search(line)
                            if match:
                                try:
                                    tto_value = float(match.group(1))
                                    total_tto += tto_value
                                    tto_count += 1
                                except ValueError:
                                    print(f"Invalid #TTO value in file: {file_path}")
                except Exception as e:
                    print(f"Error reading file {file_path}: {e}")

    if tto_count > 0:
        avg_ms = total_tto / tto_count
        avg_sec = avg_ms / 1000
        print(f"{prefix} Average #TTO = {avg_sec:.2f} s")
        return avg_sec
    else:
        print(f"No valid {prefix} #TTO values found.")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate the average #TTO values for DBA, MP, Table, and Tree files in a folder.")
    parser.add_argument("folder_path", type=str, help="Path to the folder containing the files.")
    args = parser.parse_args()

    avg_dba = compute_average_tto(args.folder_path, "DBA")
    avg_mp = compute_average_tto(args.folder_path, "MP")
    avg_table = compute_average_tto(args.folder_path, "Table")
    avg_tree = compute_average_tto(args.folder_path, "Tree")

    # Print all on one line in seconds if all are available
    if None not in (avg_dba, avg_mp, avg_table, avg_tree):
        print(f"{avg_dba:.2f} {avg_mp:.2f} {avg_table:.2f} {avg_tree:.2f}")
