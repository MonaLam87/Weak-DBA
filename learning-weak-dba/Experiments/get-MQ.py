import os
import re
import argparse

def compute_average_mq(folder_path, prefix):
    total_mq = 0
    mq_count = 0
    mq_pattern = re.compile(r"#MQ = ([\d.]+)")

    for root, _, files in os.walk(folder_path):
        for file_name in files:
            if file_name.startswith(prefix):
                file_path = os.path.join(root, file_name)
                try:
                    with open(file_path, 'r') as file:
                        for line in file:
                            match = mq_pattern.search(line)
                            if match:
                                try:
                                    mq_value = float(match.group(1))
                                    total_mq += mq_value
                                    mq_count += 1
                                except ValueError:
                                    print(f"Invalid #MQ value in file: {file_path}")
                except Exception as e:
                    print(f"Error reading file {file_path}: {e}")

    if mq_count > 0:
        avg = total_mq / mq_count
        print(f"{prefix} Average #MQ = {avg:.2f}")
        return avg
    else:
        print(f"No valid {prefix} #MQ values found.")
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calculate the average #MQ values for DBA, MP, Table, and Tree files in a folder.")
    parser.add_argument("folder_path", type=str, help="Path to the folder containing the files.")
    args = parser.parse_args()

    avg_dba = compute_average_mq(args.folder_path, "DBA")
    avg_mp = compute_average_mq(args.folder_path, "MP")
    avg_table = compute_average_mq(args.folder_path, "Table")
    avg_tree = compute_average_mq(args.folder_path, "Tree")

    # Print all on one line if all are available
    if None not in (avg_dba, avg_mp, avg_table, avg_tree):
        print(f"{avg_dba:.2f} {avg_mp:.2f} {avg_table:.2f} {avg_tree:.2f}")
