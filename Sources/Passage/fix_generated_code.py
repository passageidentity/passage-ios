import os

openApiDirectory = './Sources/Passage/generated/OpenAPIClient/Classes/OpenAPIs'

# Define a list of tuples for replacements where each tuple is ('file_path', 'old_text', 'new_text')
replacements = [

  # User model requires `webauthn_types` property, but webauthn start returns user WITHOUT it, so we must make it optional.
  (
    f'{openApiDirectory}/Models/User.swift',
    '''public var webauthnTypes: [WebAuthnType]

    ''',
    '''public var webauthnTypes: [WebAuthnType]?

    '''
  ),

  (
    f'{openApiDirectory}/Models/CurrentUser.swift',
    '''public var webauthnTypes: [WebAuthnType]

    ''',
    '''public var webauthnTypes: [WebAuthnType]?

    '''
  ),

  # Some endpoints return a user with a status set to "". This is incompatible with the spec, so we have to add the statusUnavailable option.
  (
    f'{openApiDirectory}/Models/UserStatus.swift',
    '''case pending = "pending"
}
''',
    '''case pending = "pending"
    case statusUnavailable = ""
}
'''
  ),

  # Fix identifier encoding issue in UsersAPI:
  (
    f'{openApiDirectory}/APIs/UsersAPI.swift',
    'return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)',
    'return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string?.removingPercentEncoding ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: false)'
  ),

  # Add more replacements here as needed
  # ('file', 'oldText', 'newText'),
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

def remove_file(file_path):
  if os.path.exists(file_path):
    os.remove(file_path)
    print(f"File '{file_path}' deleted successfully.")
  else: print(f"File '{file_path}' not found.")

for replacement in replacements:
  replace_in_file(replacement)

remove_file('Sources/Passage/generated/Package.swift'
            )