import csv

def get_unique_actors(csv_file):
    unique_actors = set()

    with open(csv_file, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Split actors using commas and add to the set
            actors = row['Cast'].split(', ')
            unique_actors.update(actors)

    return list(unique_actors)

def write_unique_actors_to_csv(unique_actors, output_csv):
    with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['ID', 'Actor']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()

        for idx, actor in enumerate(unique_actors, start=1):
            writer.writerow({'ID': idx, 'Actor': actor})

    print(f'Unique actors with IDs written to "{output_csv}" successfully.')

# Replace 'your_csv_file.csv' with the actual path to your CSV file
csv_file_path = 'C:/Users/jmhha/Downloads/Movie Data (REAL) - MASTER.csv'

unique_actors = get_unique_actors(csv_file_path)

# Specify the output CSV file
output_csv = 'unique_actors_with_ids.csv'

# Call the function to write unique actors with IDs to CSV
write_unique_actors_to_csv(unique_actors, output_csv)
