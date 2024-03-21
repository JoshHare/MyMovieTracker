import csv

def create_genre_csv(input_file, output_file):
    # Create a set to store unique genres
    unique_genres = set()

    # Read the modified CSV file
    with open(input_file, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)

        # Iterate through each row in the modified CSV
        for row in reader:
            # Extract movie title and genres
            title = row.get('Title', 'N/A')
            genres = row.get('Genres', '').split(', ')

            # Add each genre to the set
            unique_genres.update(genres)

    # Write the new CSV file with each row containing movie name and one genre
    with open(output_file, 'w', newline='', encoding='utf-8') as genresfile:
        fieldnames = ['Title', 'Genre']
        writer = csv.DictWriter(genresfile, fieldnames=fieldnames)

        writer.writeheader()

        # Iterate through each row in the modified CSV again
        with open(input_file, 'r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)

            # Iterate through each row in the modified CSV
            for row in reader:
                # Extract movie title and genres
                title = row.get('Title', 'N/A')
                genres = row.get('Genres', '').split(', ')

                # Write a new row for each genre
                for genre in genres:
                    writer.writerow({
                        'Title': title,
                        'Genre': genre
                    })

    print(f'New CSV file "{output_file}" generated successfully.')

# Specify the input and output file names
input_csv = 'modified_file.csv'
output_csv = 'movie_genres.csv'

# Call the function to create the new CSV
create_genre_csv(input_csv, output_csv)
