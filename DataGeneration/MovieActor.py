import csv

def create_actor_csv(input_file, output_file):
    # Create a set to store unique actors
    unique_actors = set()

    # Read the modified CSV file
    with open(input_file, 'r', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)

        # Iterate through each row in the modified CSV
        for row in reader:
            # Extract movie title and cast
            title = row.get('Title', 'N/A')
            cast = row.get('Cast', '').split(', ')

            # Add each actor to the set
            unique_actors.update(cast)

    # Write the new CSV file with each row containing movie name and one actor
    with open(output_file, 'w', newline='', encoding='utf-8') as actorsfile:
        fieldnames = ['Title', 'Actor']
        writer = csv.DictWriter(actorsfile, fieldnames=fieldnames)

        writer.writeheader()

        # Iterate through each row in the modified CSV again
        with open(input_file, 'r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)

            # Iterate through each row in the modified CSV
            for row in reader:
                # Extract movie title and cast
                title = row.get('Title', 'N/A')
                cast = row.get('Cast', '').split(', ')

                # Write a new row for each actor
                for actor in cast:
                    writer.writerow({
                        'Title': title,
                        'Actor': actor
                    })

    print(f'New CSV file "{output_file}" generated successfully.')

# Specify the input and output file names
input_csv = 'modified_file.csv'
output_csv = 'movie_actors.csv'

# Call the function to create the new CSV
create_actor_csv(input_csv, output_csv)
