#!/usr/local/bin/python3
import re
from functools import cached_property

from pathlib import Path
import argparse


class Marker(object):
    TAB = '  '

    STARTCHARS = ['#', '>']

    STARTCHAR_TO_LEVEL = {
        '#': 0,
        '>': 1,
    }

    def __init__(self, text='', reference='', level=0, startstr='-', endstr='\n'):
        self.text = text
        self.reference = reference
        self.level = level
        self.startstr = startstr
        self.endstr = endstr

    def __str__(self):
        indent = self.level * self.TAB
        return f"{indent}{self.startstr} {self.link}{self.endstr}"

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
    def create_marker_from_line(cls, line, file=''):
        match = re.search(cls.regex(), line)
        startchar, text = match.groups()

        level = cls.STARTCHAR_TO_LEVEL[startchar]

        return Marker(
            text=text,
            reference=f"{file}:{text}",
            level=level,
        )


class FileIndex(object):
    def __init__(self, file):
        self.file = Path(file)
        self.project = Project(file)
        self.markers = self.find_markers()

    @cached_property
    def short_path(self):
        return self.project.shorten_project_path(self.file)

    def find_markers(self):
        lines = self.file.read_text().split("\n")
        markers = []
        for line in lines:
            if Marker.is_marker(line):
                markers.append(Marker.create_marker_from_line(line, self.short_path))

        return markers

    @property
    def index(self):
        return "".join([str(marker) for marker in self.markers])


class DirectoryIndex(object):
    FILE_EXCLUSIONS = [
        '.project',
        'index.md',
        'questions.md',
        'definition.md',
    ]

    def __init__(self, directory, max_depth=None):
        self.directory = Path(directory)
        self.project = Project(directory)
        self.max_depth = max_depth
        self.markers = self.find_markers(self.directory)
        print(self.index)

    @property
    def index(self):
        return "".join([str(m) for m in self.markers]).strip()

    def save(self, path=None):
        if not path:
            path = self.directory.joinpath('.index.md')

        path.write_text(self.index)

    @cached_property
    def short_path(self):
        return self.project.shorten_project_path(self.directory)

    def exclude_path(self, path):
        return path.name in self.FILE_EXCLUSIONS

    def find_markers(self, directory, level=0):
        markers = []

        if self.max_depth and level == self.max_depth:
            return markers

        if not level:
            definition_marker = self.get_directory_definition_marker(
                directory,
                directory_text=False,
                level=level,
            )

            if definition_marker:
                markers.append(definition_marker)

        for path in directory.glob('*'):
            if self.exclude_path(path):
                continue

            if path.is_dir():
                markers += self.get_directory_markers(path, level)
                markers += self.find_markers(path, level=level + 1)

            elif path.is_file() and path.suffix == '.md':
                short_path = self.project.shorten_project_path(path)

                markers.append(Marker(
                    text=path.stem,
                    reference=f"{short_path}:",
                    level=level,
                ))

        return markers

    def get_directory_definition_marker(self, directory, directory_text=True, **kwargs):
        definition_path = directory.joinpath('definition.md')

        if definition_path.exists():
            short_definition_path = self.project.shorten_project_path(definition_path)

            return Marker(
                text=directory.stem if directory_text else 'definition',
                reference=f"{short_definition_path}:",
                **kwargs,
            )

    def get_directory_markers(self, directory, level):
        marker = Marker(
            text=directory.stem,
            reference=f"{self.project.shorten_project_path(directory)}:",
            level=level,
        )

        definition_marker = self.get_directory_definition_marker(
            directory,
            level=0,
            directory_text=False,
            startstr=':',
        )

        if definition_marker:
            marker.endstr = ''
            return [marker, definition_marker]
        else:
            return [marker]


class Project(object):
    PROJECT_FILENAME = '.project'
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

    def shorten_project_path(self, path):
        path_string = str(path)
        directory_string = str(self.directory)

        if path_string.startswith(directory_string):
            path_string = path_string.replace(directory_string, '.')

        return path_string


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
    parser = argparse.ArgumentParser(description='index')
    parser.add_argument('--file', '-f', help='file to generate index for')
    parser.add_argument('--directory', '-d', help='directory to generate index for')
    parser.add_argument('--max_depth', '-m', default=None, help='max depth for a directory index')

    args = parser.parse_args()

    if args.file:
        index = FileIndex(args.file)
    elif args.directory:
        index = DirectoryIndex(args.directory, max_depth=args.max_depth)
