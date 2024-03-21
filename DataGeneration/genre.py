import csv

def get_unique_genres(csv_file):
    unique_genres = set()

    with open(csv_file, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Split genres using commas and add to the set
            genres = row['Genres'].split(', ')
            unique_genres.update(genres)

    return list(unique_genres)

# Replace 'your_csv_file.csv' with the actual path to your CSV file
csv_file_path = "C:/Users/jmhha/Downloads/Movie Data (REAL) - MASTER.csv"

unique_genres = get_unique_genres(csv_file_path)

print("Unique Genres:")
for genre in unique_genres:
    print(genre)
