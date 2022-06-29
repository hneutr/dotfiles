from pathlib import Path
import yaml
import json
import argparse
from functools import cached_property


JOURNALS_DIRECTORY = Path('/Users/hne/Documents/text/written/journals/content')


class Project(object):
    PROJECT_FILENAME = '.project'

    def __init__(self, path):
        path = Path(path)
        self.config_dir = path if path.is_dir() else path.parent

    @cached_property
    def config(self):
        directory = self.config_dir

        while directory != Path('/'):
            config_path = directory.joinpath(self.PROJECT_FILENAME)
            if config_path.exists():
                self.config_dir = directory
                self.config_path = config_path
                return yaml.load(self.config_path.read_text(), Loader=yaml.BaseLoader)
            else:
                directory = directory.parent

        return {}

    @property
    def journals_directory(self):
        directory = JOURNALS_DIRECTORY

        if self.config.get('name'):
            directory = directory.joinpath(self.config['name'].replace(' ', '-'))

        directory.mkdir(exist_ok=True)

        return directory

    def shorten_path(self, path):
        path = str(path).replace(str(self.config_dir), '')

        if path.startswith('/'):
            path = path.replace('/', '', 1)

        return f'./{path}'

    def prefix_path(self, path, prefix):
        new_path = self.shorten_path(path).replace('.', prefix, 1)
        return self.config_dir.joinpath(new_path)

    # @property
    # def journal_name(self):


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='project handler')
    parser.add_argument('--source', '-s', default=Path.cwd(), help='where to look for the project file')
    parser.add_argument('--save_json', default=False, action='store_true', help='if true, save the json somewhere')
    parser.add_argument('--json_destination', default='/tmp/project-json.json', help='where to save json')

    args = parser.parse_args()

    project = Project(Path(args.source))

    if args.save_json:
        Path(args.json_destination).write_text(json.dumps(project.config))
