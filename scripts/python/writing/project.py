from pathlib import Path
import yaml
import json
import argparse
from functools import cached_property

from marker import Marker, Reference


JOURNALS_DIRECTORY = Path('/Users/hne/Documents/text/written/journals/content')


class Project(object):
    PROJECT_FILENAME = '.project'

    def __init__(self, path):
        self.start_path = Path(path)
        self.start_dir = self.start_path if self.start_path.is_dir() else self.start_path.parent
        self.find_config()

    def find_config(self):
        self.root_dir = self.start_dir

        while self.root_dir != Path('/'):
            if self.config_path.exists():
                return
            else:
                self.root_dir = self.root_dir.parent

        self.root_dir = self.start_dir

    @property
    def config_path(self):
        return self.root_dir.joinpath(self.PROJECT_FILENAME)

    @cached_property
    def config(self):
        if self.config_path.exists():
            return yaml.load(self.config_path.read_text(), Loader=yaml.BaseLoader)

        return {}

    @property
    def journals_directory(self):
        directory = JOURNALS_DIRECTORY

        if self.config.get('name'):
            directory = directory.joinpath(self.config['name'].replace(' ', '-'))

        directory.mkdir(exist_ok=True)

        return directory

    def shorten_path(self, path):
        return str(path).replace(str(self.root_dir), '.')

    def expand_path(self, path):
        path = str(path).replace('.', str(self.root_dir), 1)
        return Path(path)

    def prefix_path(self, path, prefix):
        prefixed_path = self.shorten_path(path).replace('.', prefix, 1)
        return self.root_dir.joinpath(prefixed_path)

    ################################################################################
    # updating markers:
    # - update marker text
    #   - update marker-labels in marker file
    #   - update references (change text) in all files
    # - move file with markers
    #   - update reference-s (change file) in all files
    #   - rename file
    #   - rename file mirrors
    ################################################################################
    def execute_update(self, old_path, new_path=None, old_text=None, new_text=None):
        """
        there are three kinds of changes:
        1. marker text changes. In this case, find all references to the marker and update the text
        2. file changes. In this case, find all references to the marker and update the path
        3. directory changes. In this case:
            1. move mirrored directories
            2. find all references to updated directories and update the path
        """
        old_path = Path(old_path)

        if old_text != new_text:
            Marker.update_file_markers(old_path, old_text, new_text)

        if not new_path:
            return

        if old_path != new_path:
            updates = self.get_paths_to_update(old_path, new_path)
        else:
            updates = [{
                'old_path': Path(old_path),
            }]

        if old_text:
            for update in updates:
                update['old_text'] = old_text

        if new_text:
            for update in updates:
                update['new_text'] = new_text

        self.update_references(updates)
        self.update_paths(updates)

    def get_paths_to_update(self, old, new):
        """
        we want to update mirrored paths, too. So, say:
        - old_path: './text/chapter-1.md'
        - new_path: './text/chapters/1.md'

        and the project looks like so:
        - ./text/chapter-1.md
        - ./outlines/text/chapter-1.md

        should result in:
        - ./text/chapters/1.md
        - ./outlines/text/chapters/1.md

        `old_path` and `new_path` should either both be files or both be directories
        """
        old = Path(old)
        new = Path(new)

        if old.is_dir() and new.is_file():
            return
        elif old.is_file() and new.is_dir():
            return

        short_old = self.shorten_path(old).replace('./', '', 1)
        short_new = self.shorten_path(new).replace('./', '', 1)

        if old.is_dir():
            short_old = short_old.rstrip('/')
            short_new = short_new.rstrip('/')

        mirrors = []
        for other in self.root_dir.rglob('*'):
            short_other = self.shorten_path(other).replace('./', '', 1)

            if short_other.endswith(short_old):
                short_new_other = short_other.replace(short_old, short_new, 1)

                mirrors.append({
                    'old_path': other,
                    'new_path': self.root_dir.joinpath(short_new_other),
                })

        return mirrors

    def update_paths(self, updates):
        for update in updates:
            old = update['old_path']
            new = update['new_path']

            target_dir = new if new.is_dir() else new.parent
            target_dir.mkdir(exist_ok=True, parents=True)

            old.rename(new)

        for path in self.root_dir.rglob('*'):
            if path.is_dir() and not len(list(path.rglob('*'))):
                path.rmdir()

    def update_references(self, updates):
        """
        iterate through all files
        - whenever you find a line that matches one of the things to change
            (will need to look recursively within a line)
        """
        for path in self.root_dir.rglob('*.md'):
            old_content = path.read_text()

            new_content = Reference.update_references_in_string(
                project=self,
                string=old_content,
                updates=updates,
            )

            if new_content != old_content:
                path.write_text(new_content)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='project handler')
    parser.add_argument('--source', '-s', default=Path.cwd(), help='where to look for the project file')
    parser.add_argument('--save_json', default=False, action='store_true', help='if true, save the json somewhere')
    parser.add_argument('--json_destination', default='/tmp/project-json.json', help='where to save json')

    parser.add_argument('--update', '-u', default=False, action='store_true', help='update markers/references')
    parser.add_argument('--old_path', type=str, help='path to update from')
    parser.add_argument('--new_path', type=str, help='path to update to')
    parser.add_argument('--old_text', type=str, help='text to update from')
    parser.add_argument('--new_text', type=str, help='text to update text')

    args = parser.parse_args()

    source = args.source

    if not source.startswith('/'):
        source = Path.cwd().joinpath(source)

    project = Project(source)

    if args.update:
        project.execute_update(
            old_path=args.old_path,
            new_path=args.new_path,
            old_text=args.old_text,
            new_text=args.new_text,
        )

    """
    todo:
    - make paths relative paths absolute 
    - we prolly have to be careful about multi-named files (eg `definition.md`)

    tested:
    - marker text changes
    - file change results in change
    - file change produces reference updates
    - directory changes effects mirrors
    - directory change results in updates to mirror references

    still to test:
    """
    import sys; sys.exit()

    if args.save_json:
        Path(args.json_destination).write_text(json.dumps(project.config))