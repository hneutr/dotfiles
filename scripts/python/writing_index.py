#!/usr/local/bin/python3
import re
from functools import cached_property

from pathlib import Path
import argparse


class Marker(object):
    TAB = '  '

    STARTSTR = '-'

    STARTCHARS = ['#', '>']

    STARTCHAR_TO_LEVEL = {
        '#': 0,
        '>': 1,
    }

    def __init__(self, text='', reference='', level=0, startstr=None, endstr='\n', indent=True):
        self.text = text
        self.reference = reference
        self.level = level
        self.startstr = self.STARTSTR if startstr == None else startstr
        self.endstr = endstr
        self.indent = indent

    def __str__(self):
        return f"{self.lpad}{self.startstr} {self.link}{self.endstr}"

    @property
    def lpad(self):
        return self.level * self.TAB if self.indent else ''

    @property
    def link(self):
        return f"[{self.text}]({self.reference})"

    @classmethod
    def regex(cls):
        startchars_string = "".join(cls.STARTCHARS)
        return f"^([{startchars_string}]) \[(.*)\]\(\)"

    @classmethod
    def is_marker(cls, line):
        return re.match(cls.regex(), line)

    @classmethod
    def from_line(cls, line, file=''):
        match = re.search(cls.regex(), line)
        startchar, text = match.groups()

        level = cls.STARTCHAR_TO_LEVEL[startchar]

        return Marker(
            text=text,
            reference=f"{file}:{text}",
            level=level,
        )

class Index(object):
    FILE_EXCLUSIONS = [
        '.project',
        'index.md',
        'questions.md',
        'definition.md',
    ]

    FILE_SUFFIXES = [
        '.md',
    ]

    def __init__(self, path, project, max_depth=None):
        self.path = Path(path)
        self.project = project
        self.max_depth = max_depth

    @property
    def index_path(self):
        path = self.project.add_prefix_to_path(self.path, self.project.INDEXES_DIRECTORY)

        if self.path.is_dir():
            path = path.joinpath('index.md')

        return path

    @property
    def content(self):
        return "".join([str(m) for m in self.markers]).rstrip()

    def exclude_path_markers(self, path):
        """
        TODO: also exclude gitignored things
        """
        if path.is_file():
            return any([
                path.name in self.FILE_EXCLUSIONS,
                path.suffix not in self.FILE_SUFFIXES,
            ])
        else:
            return any([
                path.stem.startswith('.')
            ])

    @cached_property
    def markers(self):
        if self.path.is_file():
            markers = self.get_text_markers(self.path)
        else:
            markers = self.get_markers(self.path)

        min_level = min([m.level for m in markers])

        for marker in markers:
            marker.level -= min_level

        return markers

    def get_markers(self, path, level=0):
        markers = []

        if self.max_depth and level == self.max_depth:
            return markers

        if self.exclude_path_markers(path):
            return markers

        if path.is_file():
            markers.append(self.get_file_marker(path, level=level))
        elif path.is_dir():
            markers += self.get_directory_markers(path, level=level)

        return markers

    def get_text_markers(self, path):
        lines = path.read_text().split("\n")

        short_path = self.project.get_short_path(path)
        return [Marker.from_line(l, short_path) for l in lines if Marker.is_marker(l)]

    def get_file_marker(self, path, text=None, **kwargs):
        if not text:
            text = path.stem 

        return Marker(
            text=text,
            reference=f"{self.project.get_short_path(path)}:",
            **kwargs,
        )

    def get_directory_markers(self, path, level=0):
        markers = []

        if level:
            markers.append(self.get_file_marker(path, level=level))

        markers = self.add_directory_definition_marker(markers, path, level)

        for subpath in sorted(path.glob('*')):
            markers += self.get_markers(subpath, level=level + 1)

        return markers

    def add_directory_definition_marker(self, markers, directory_path, level=0):
        path = directory_path.joinpath('definition.md')

        if path.exists():
            kwargs = {
                'path': path,
                'text': 'definition',
                'level': level,
            }

            # we inline the directory definition marker with the directory
            # marker if we're not at the first level 
            if level:
                markers[-1].endstr = ''
                kwargs['startstr'] = ':'
                kwargs['indent'] = False

            markers.append(self.get_file_marker(**kwargs))

        return markers



class Project(object):
    PROJECT_FILENAME = '.project'
    SCRATCH_DIRECTORY = 'scratch'
    INDEXES_DIRECTORY = '.indexes'
    DELIMITER = '='

    def __init__(self, path):
        self.set_config(Path(path))

    def set_config(self, path):
        if path.is_file():
            directory = Path(path).parent
        else:
            directory = path

        self.config = {}

        while directory != Path('/'):
            config_path = directory.joinpath(self.PROJECT_FILENAME)
            if config_path.exists():
                self.directory = directory
                self.config = self.read_config(config_path)
                return
            else:
                directory = directory.parent

    def read_config(self, path):
        lines = path.read_text().split('\n')

        config = {}
        for line in lines:
            line = line.strip()

            if line:
                key, value = line.split(self.DELIMITER)
                config[key] = value

        return config

    def remove_project_path(self, path):
        path = str(path).replace(str(self.directory), '')

        if path.startswith('/'):
            path = path.replace('/', '', 1)

        return path

    def get_short_path(self, path):
        return './' + self.remove_project_path(path)

    def get_project_path(self, path, prefix=None):
        full_path = self.directory

        if prefix:
            full_path = full_path.joinpath(prefix)

        full_path = full_path.joinpath(path)

        return full_path

    def add_prefix_to_path(self, path, prefix):
        return self.directory.joinpath(prefix, self.remove_project_path(path))


if __name__ == '__main__':
    """
    currently supports:
    - file indexes. 
        TODO: create a way to save them
    - directory indexes:
        - can be saved, will be stored at `.index.md`

    to support:
    - taking a "meta" index (index of file paths) and filling it out with the
      indexes found in the referenced files
    """
    parser = argparse.ArgumentParser(description='makes indexes for things')
    parser.add_argument('--source', '-s', help='what to generate the index from (file/directory)')
    parser.add_argument('--max_depth', '-m', default=None, help='max depth for a directory index')
    parser.add_argument('--save', default=True, action='store_false', help='whether to save the file')

    args = parser.parse_args()

    project = Project(args.source)

    source_path = project.get_project_path(args.source)

    index = Index(source_path, project=project, max_depth=args.max_depth)

    if args.save:
        outpath = index.index_path
        outpath.parent.mkdir(parents=True, exist_ok=True)
        outpath.write_text(index.content)
