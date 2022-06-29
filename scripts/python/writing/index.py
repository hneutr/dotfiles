#!/usr/local/bin/python3
from functools import cached_property
from pathlib import Path
import argparse

from project import Project 
from marker import Marker


class Index(object):
    INDEX_DIRECTORY = '.indexes'

    FILE_EXCLUSIONS = [
        '.project',
        'index.md',
        'questions.md',
        'definition.md',
    ]

    DIRECTORY_EXCLUSIONS = [
        "changes",
        'outlines',
        'goals',
        "other's-ideas"
        "possibilities",
    ]

    FILE_SUFFIXES = [
        '.md',
    ]

    def __init__(self, path, max_depth=None):
        self.path = Path(path)
        self.project = Project(self.path)
        self.max_depth = max_depth

    @property
    def index_path(self):
        path = self.project.prefix_path(self.path, self.INDEX_DIRECTORY)

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
                path.stem.startswith('.'),
                path.name in self.DIRECTORY_EXCLUSIONS,
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

        short_path = self.project.shorten_path(path)
        return [Marker.from_line(l, short_path) for l in lines if Marker.is_marker(l)]

    def get_file_marker(self, path, text=None, **kwargs):
        if not text:
            text = path.stem 

        return Marker(
            text=text,
            reference=f"{self.project.shorten_path(path)}:",
            **kwargs,
        )

    def get_directory_markers(self, path, level=0):
        markers = []

        markers.append(self.get_directory_marker(path, level))

        for subpath in sorted(path.glob('*')):
            markers += self.get_markers(subpath, level=level + 1)

        return markers

    def get_directory_marker(self, directory_path, level=0):
        """
        if the directory has a `definition.md` file, use that as the path for
        the marker. Otherwise, just make a directory marker.
        """
        path = directory_path.joinpath('definition.md')

        if path.exists():
            kwargs = {
                'text': 'definition',
                'level': level,
            }

            if level:
                kwargs['text'] = directory_path.name
            else:
                kwargs['level'] = 1

            return self.get_file_marker(path, **kwargs)
        else:
            return self.get_file_marker(directory_path, level=level)


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

    index = Index(args.source, max_depth=args.max_depth)

    if args.save:
        outpath = index.index_path
        outpath.parent.mkdir(parents=True, exist_ok=True)
        outpath.write_text(index.content)
