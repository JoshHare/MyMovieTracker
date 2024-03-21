import requests
import csv

def get_movie_details(api_key, base_url, movie_id):
    # Set up the API endpoint for movie details
    endpoint = f'{base_url}/movie/{movie_id}'
    
    # Set up parameters, including your API key
    params = {
        'api_key': api_key,
        'language': 'en-US',
    }
    
    # Make the request to the API
    response = requests.get(endpoint, params=params)
    
    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Get the 'runtime' and 'tagline' information from the response
        movie_data = response.json()
        runtime = movie_data.get('runtime', 'N/A')
        tagline = movie_data.get('tagline', 'N/A')
        return runtime, tagline
    else:
        # Print an error message if the request was unsuccessful
        print(f"Error: {response.status_code}")
        return 'N/A', 'N/A'

def get_movie_genres(api_key, base_url, movie_id):
    # Set up the API endpoint for movie details
    endpoint = f'{base_url}/movie/{movie_id}'
    
    # Set up parameters, including your API key
    params = {
        'api_key': api_key,
        'language': 'en-US',
    }
    
    # Make the request to the API
    response = requests.get(endpoint, params=params)
    
    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Get the genre information from the response
        genres = response.json().get('genres', [])
        return [genre['name'] for genre in genres]
    else:
        # Print an error message if the request was unsuccessful
        print(f"Error: {response.status_code}")
        return None

def get_movies_in_range(api_key, base_url, start_rank, end_rank):
    endpoint = '/discover/movie'
    api_params = {
        'api_key': api_key,
        'language': 'en-US',
        'sort_by': 'popularity.desc',
        'page': 1
    }

    all_movies_data = []

    while len(all_movies_data) < end_rank:
        # Make a request to TMDb API for each page
        response = requests.get(f'{base_url}{endpoint}', params=api_params)

        if response.status_code == 200:
            # Parse JSON response
            movies_data = response.json()['results']

            # Add movies from this page to the list
            all_movies_data.extend(movies_data)

            # Check if there are more pages
            if response.json()['page'] < response.json()['total_pages']:
                # Move to the next page
                api_params['page'] += 1
            else:
                break
        else:
            print(f'Error: {response.status_code}, {response.text}')
            break

    return all_movies_data[start_rank - 1:end_rank]  # Adjust indices to start from 1

def fetch_and_write_movie_data(api_key, base_url, start_rank, end_rank):
    selected_movies_data = get_movies_in_range(api_key, base_url, start_rank, end_rank)

    # Create a CSV file and write header
    with open('selected_movies.csv', 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['Rank', 'Title', 'Director', 'Tagline', 'Overview', 'Runtime', 'Genres', 'Release Year', 'Cast', 'Rating']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        writer.writeheader()

        for index, movie_data in enumerate(selected_movies_data, start=start_rank):
            # Extracting required information
            title = movie_data.get('title', 'N/A')
            
            # Extracting runtime and tagline using the get_movie_details function
            runtime, tagline = get_movie_details(api_key, base_url, movie_data['id'])

            # Extracting genres using the get_movie_genres function
            genres = get_movie_genres(api_key, base_url, movie_data['id'])
            genres_str = ', '.join(genres) if genres else 'N/A'

            # Extracting director information from credits endpoint
            credits_endpoint = f'/movie/{movie_data["id"]}/credits'
            credits_response = requests.get(f'{base_url}{credits_endpoint}', params={'api_key': api_key})
            if credits_response.status_code == 200:
                credits_data = credits_response.json()
                directors = [crew['name'] for crew in credits_data['crew'] if crew['job'] == 'Director']
                director = ', '.join(directors) if directors else 'N/A'
            else:
                director = 'N/A'

            # Extracting cast information
            cast_endpoint = f'/movie/{movie_data["id"]}/credits'
            cast_response = requests.get(f'{base_url}{cast_endpoint}', params={'api_key': api_key})
            if cast_response.status_code == 200:
                cast_data = cast_response.json()
                # Extracting top 12 cast members
                cast = ', '.join(actor['name'] for actor in cast_data.get('cast', [])[:12]) or 'N/A'
            else:
                cast = 'N/A'

            # Extracting release year
            release_year = movie_data['release_date'][:4] if 'release_date' in movie_data else 'N/A'

            # Extracting movie rating
            rating = movie_data.get('vote_average', 'N/A')

            # Writing the information to the CSV file
            writer.writerow({
                'Rank': index,
                'Title': title,
                'Director': director,
                'Tagline': tagline,
                'Overview': movie_data.get('overview', 'N/A'),
                'Runtime': runtime,
                'Genres': genres_str,
                'Release Year': release_year,
                'Cast': cast,
                'Rating': rating
            })

            print(f'#{index} - {title} added to CSV')

    print('CSV file generated successfully.')

# Replace 'your_api_key' with your actual TMDb API key
api_key = '0d13f73cf295b7077388ca476d22bf1b'
base_url = 'https://api.themoviedb.org/3'

# Fetch and write data for movies from rank 5789 to 10000
fetch_and_write_movie_data(api_key, base_url, start_rank=5789, end_rank=10000)
