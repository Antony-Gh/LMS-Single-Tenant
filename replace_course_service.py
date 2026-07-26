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

            if 'CourseService.' in content:
                # Add locator import if not present
                if 'import \'package:esoi/locator.dart\';' not in content:
                    content = "import 'package:esoi/locator.dart';\n" + content

                # Replace
                content = re.sub(r'CourseService\.', 'locator<CourseService>().', content)
                
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
