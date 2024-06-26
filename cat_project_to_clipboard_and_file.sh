#!/bin/bash

# Output file
OUTPUT_FILE="combined_output.txt"

# Clear the output file if it exists
> "$OUTPUT_FILE"

# List of filenames to search for
FILES_TO_SEARCH=(
	"Makefile"
	"Dockerfile"
	"docker-compose.yml"
	"entrypoint.sh"
	"nginx.conf"
	"mariadb-server.cnf"
	"wp-config.php"
	".env"
)

# Function to search and concatenate files
concatenate_files() {
	local file_name=$1
	find . -type f -name "$file_name" -exec sh -c '
	for file; do
		echo "=========== $file ===========" >> '"$OUTPUT_FILE"'
		cat "$file" >> '"$OUTPUT_FILE"'
		echo "" >> '"$OUTPUT_FILE"'  # Add an empty line for readability
		echo "" >> '"$OUTPUT_FILE"'  # Add an empty line for readability
	done
	' sh {} +
}

# Function to concatenate specific service files
concatenate_service_files() {
	local service_path=$1
	find "$service_path" -type f \( -name "Dockerfile" -o -name "entrypoint.sh" -o -name "*.cnf" -o -name "*.conf" -o -name "*.php" \) -exec sh -c '
	for file; do
		echo "=========== $file ===========" >> '"$OUTPUT_FILE"'
		cat "$file" >> '"$OUTPUT_FILE"'
		echo "" >> '"$OUTPUT_FILE"'  # Add an empty line for readability
		echo "" >> '"$OUTPUT_FILE"'  # Add an empty line for readability
	done
	' sh {} +
}

# Prompt for user choice
echo "Choose an option to concatenate files:"
echo "1. All files"
echo "2. Makefile"
echo "3. Docker Compose"
echo "4. Mariadb"
echo "5. Nginx"
echo "6. WordPress"
echo "7. .env"
read -p "Enter your choice (1-6): " choice

case $choice in
	1)
		# Concatenate all files
		for file_name in "${FILES_TO_SEARCH[@]}"; do
			concatenate_files "$file_name"
		done
		;;
	2)
		# Copy Makefile
		concatenate_files "Makefile"
		;;
	3)
		# Copy Docker Compose file
		concatenate_files "docker-compose.yml"
		;;
	4)
		# Copy Mariadb files
		concatenate_service_files "./project/srcs/requirements/mariadb"
		;;
	5)
		# Copy Nginx files
		concatenate_service_files "./project/srcs/requirements/nginx"
		;;
	6)
		# Copy WordPress files
		concatenate_service_files "./project/srcs/requirements/wordpress"
		;;
	7)
		# Copy .env files
		concatenate_files ".env"
		;;
	*)
		echo "Invalid choice. Exiting."
		exit 1
		;;
esac

cat $OUTPUT_FILE | xclip # Copy file content to clipboard

echo "Content of specified files has been concatenated into $OUTPUT_FILE and is now in your clipboard (Middle mouse button)." 


