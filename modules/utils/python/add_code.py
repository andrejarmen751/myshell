import os

# Function to modify Jenkinsfile
def modify_jenkinsfile(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Flags to check if we found the Checkout stage and if modifications were made
    found_checkout = False
    brace_count = 0  # To track the number of opening and closing braces
    added_checkov_stage = False  # To track if Checkov stage was added

    # Check if Checkov stage already exists
    for line in lines:
        if 'stage("Checkov") {' in line or 'stage(\'Checkov\') {' in line:
            return False, True  # Skip modification and indicate Checkov stage exists

    for i, line in enumerate(lines):
        stripped_line = line.strip()
        
        if stripped_line == 'stage("Checkout") {' or stripped_line == 'stage(\'Checkout\') {':
            found_checkout = True
            brace_count += 1  # Increment for the opening brace
        elif found_checkout:
            brace_count += line.count('{')  # Count opening braces
            brace_count -= line.count('}')  # Count closing braces
            
            # Check if we have closed the stage block
            if brace_count == 0:
                # Insert the Checkov stage after the last closing brace
                lines.insert(i + 1, '\n')  # Insert a blank line before Checkov stage
                lines.insert(i + 2, '    stage("Checkov") {\n')
                lines.insert(i + 3, '        script {\n')
                lines.insert(i + 4, '            GIT_URL = sh(returnStdout: true, script: \'git config --get remote.origin.url\').trim()\n')
                lines.insert(i + 5, '            REPO_PARTS = GIT_URL.split(\'/\')\n')
                lines.insert(i + 6, '            REPO_ID = "${REPO_PARTS[-3]}/${REPO_PARTS[-2]}/${REPO_PARTS[-1]}"\n')
                lines.insert(i + 7, '            prismaCloudAnalysis(\n')
                lines.insert(i + 8, '                repoId: "${REPO_ID}",\n')
                lines.insert(i + 9, '                branch: "${env.GIT_BRANCH}"\n')
                lines.insert(i + 10, '            )\n')
                lines.insert(i + 11, '        }\n')
                lines.insert(i + 12, '    }\n')
                added_checkov_stage = True  # Indicate that Checkov stage was added
                break  # Exit the loop after insertion

    # Write the modified lines back to the file if the Checkov stage was added
    if added_checkov_stage:
        with open(file_path, 'w') as file:
            file.writelines(lines)
        return True, False  # Indicate that the file was modified and Checkov stage was not present

    return False, True  # Indicate that the file was not modified and Checkov stage was present

# Function to walk through directories
def search_and_modify(base_dir):
    modified_folders = []  # List to store paths where modifications were made
    existing_checkov_folders = []  # List to store paths where Checkov stage already exists
    checked_folders = []  # List to store all checked folders

    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file == 'Jenkinsfile':
                jenkinsfile_path = os.path.join(root, file)

                # Modify the Jenkinsfile and check if it was modified
                modified, exists = modify_jenkinsfile(jenkinsfile_path)
                
                checked_folders.append(os.path.basename(root))  # Add the folder name to the checked list
                
                if modified:
                    modified_folders.append(os.path.basename(root))  # Add only the folder name to the modified list
                elif exists:
                    existing_checkov_folders.append(os.path.basename(root))  # Add only the folder name to existing list if Checkov stage was found

    return modified_folders, existing_checkov_folders, checked_folders  # Return all lists

# Use the current directory as the base directory
base_directory = os.getcwd()
modified_found_folders, existing_checkov_folders, checked_folders = search_and_modify(base_directory)

# Print the final report
if modified_found_folders:
    print("Checkov stages added in the following directories:")
    for folder in modified_found_folders:
        print(folder)

if existing_checkov_folders:
    print("\nCheckov stages already present in the following directories:")
    for folder in existing_checkov_folders:
        print(folder)