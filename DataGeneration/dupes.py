import pandas as pd

def remove_identical_rows(csv_file_path, columns):
    # Read CSV file into a pandas DataFrame
    df = pd.read_csv(csv_file_path)

    # Identify completely identical rows based on specified columns
    duplicate_rows = df[df.duplicated(subset=columns, keep=False)]

    # Remove completely identical rows based on specified columns
    df_no_duplicates = df.drop_duplicates(subset=columns, keep=False)

    return df_no_duplicates, duplicate_rows

if __name__ == "__main__":
    # Replace 'your_file.csv' with the actual path to your CSV file
    file_path = 'C:/Users/jmhha/Downloads/MovieData - MASTER.csv'

    # Specify columns for identifying duplicates
    # For example, if you want to remove rows that are identical in 'Title', 'Year', and 'Runtime':
    target_columns = ['Title', 'Year', 'Runtime']

    # Remove identical rows and get removed rows
    modified_df, removed_rows = remove_identical_rows(file_path, target_columns)

    if not removed_rows.empty:
        # Print titles of removed movies
        print("Titles of Removed Movies:")
        print(removed_rows['Title'])

        # Save the modified DataFrame to a new CSV file
        modified_df.to_csv('modified_file.csv', index=False)
        print("Identical rows removed. Modified CSV saved to 'modified_file.csv'.")
    else:
        print("No identical rows found.")
