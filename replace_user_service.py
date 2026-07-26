import os
import glob
import re

directory = r'e:\Projects\LMS_APP\lms-single-tenant-app-main\lib'

for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith('.dart'):
            file_path = os.path.join(root, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            if 'UserService.' in content:
                # Add locator import if not present
                if 'import \'package:esoi/locator.dart\';' not in content:
                    # Find the last import and add it after
                    # It's safer to just inject it at the top
                    content = "import 'package:esoi/locator.dart';\n" + content

                # Replace
                content = re.sub(r'UserService\.', 'locator<UserService>().', content)
                
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
