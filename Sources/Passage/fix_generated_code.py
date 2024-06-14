import os

# Define a list of tuples for replacements where each tuple is ('file_path', 'old_text', 'new_text')
replacements = [

  # Add more replacements here as needed
  # ('oldText', 'newText'),
]

def replace_in_file(replacement):
  file_path, old_text, new_text = replacement
  with open(file_path, 'r', encoding='utf-8') as file:
    content = file.read()

  updated_content = content
  # for old_text, new_text in replacements:
  updated_content = updated_content.replace(old_text, new_text)
  
  if content != updated_content:
    with open(file_path, 'w', encoding='utf-8') as file:
      file.write(updated_content)
    print(f"Updated {file_path}")

for replacement in replacements:
  replace_in_file(replacement)
  