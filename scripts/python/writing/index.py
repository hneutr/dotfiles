#!/usr/local/bin/python3
from functools import cached_property
from pathlib import Path
import argparse

from project import Project 
from marker import Marker, Reference
import sections


class Entry(object):
    TAB = '  '

    STARTSTR = '-'
    ENDSTR = '\n'

    MARKER_STARTCHAR_TO_LEVEL = {
        '#': 0,
        '>': 1,
    }

    def __init__(
        self,
        item,
        level=0,
        startstr=None,
        endstr=None,
        indent=True,
    ):
        self.item = item
        self.level = level
        self.startstr = self.STARTSTR if startstr == None else startstr
        self.endstr = self.ENDSTR if endstr == None else endstr
        self.indent = indent

    def __str__(self):
        return f"{self.lpad}{self.STARTSTR} {str(self.item)}{self.ENDSTR}"

    @property
    def lpad(self):
        return self.level * self.TAB if self.indent else ''

    @classmethod
    def from_file_marker(cls, string, project, path, level=0, **kwargs):
        level += cls.STARTCHAR_TO_LEVEL[string[0]]

        reference = Marker.get_reference_from_string(
            string=string,
            project=project,
            path=path,
            **kwargs,
        )

        return Entry(
            item=reference,
            level=level,
        )

    @classmethod
    def from_path(cls, project, path, level, label=''):
        reference = Reference(
            project=project,
            label=label if label else path.stem,
            path=path,
        )

        return Entry(
            item=reference,
            level=level,
        )


class MultiIndex(object):
    def __init__(self, path, max_depth=None):
        path = Path(path)
        self.file_index = Index(path, max_depth=max_depth)
        self.directory_index = Index(path.parent, max_depth=max_depth)

    @property
    def content(self):
        content = [
            sections.Heading("dir"),
            self.directory_index.content,
            sections.Heading("file"),
            self.file_index.content,
        ]

        return "\n\n".join([str(s) for s in content])

    @property
    def index_path(self):
        return self.file_index.index_path


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
        return "".join([str(e) for e in self.entries]).rstrip()

    def exclude_entries_by_path(self, path):
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
    def entries(self):
        if self.path.is_file():
            entries = self.get_entries_from_file(self.path)
        else:
            entries = self.get_entries(self.path)

        min_level = min([e.level for e in entries])

        for entry in entries:
            entry.level -= min_level

        return entries

    def get_entries(self, path, level=0):
        entries = []

        if self.max_depth and level == self.max_depth:
            return entries

        if self.exclude_entries_by_path(path):
            return entries

        if path.is_file():
            entries.append(Entry.from_path(
                project=self.project,
                path=path,
                level=level,
            ))
        elif path.is_dir():
            entries += self.get_directory_entries(path, level=level)

        return entries

    def get_entries_from_file(self, path, level=0):
        entries = []
        for line in path.read_text().split("\n"):
            if Marker.is_marker(line):
                entries.append(Entry.from_file_marker(
                    string=line,
                    project=self.project,
                    path=path,
                    level=level,
                ))

        return entries

    def get_directory_entries(self, path, level=0):
        entries = []

        if self.include_directory_entry(path, level):
            entries.append(self.get_directory_entry(path, level))

        for subpath in sorted(path.glob('*')):
            entries += self.get_entries(subpath, level=level + 1)

        return entries

    def include_directory_entry(self, path, level=0):
        return level or path.joinpath('definition.md').exists()

    def get_directory_entry(self, path, level=0):
        """
        if the directory has a `definition.md` file, use that as the path for
        the marker. Otherwise, just make a directory marker.
        """
        definition_path = path.joinpath('definition.md')

        label = path.name

        if definition_path.exists():
            path = definition_path

            if not level:
                label = 'definition'
                level = 1

        return Entry.from_path(
            project=self.project,
            label=label,
            path=path,
            level=level,
        )



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

    if Path(args.source).name == 'definition.md':
        index = MultiIndex(args.source, max_depth=args.max_depth)
    else:
        index = Index(args.source, max_depth=args.max_depth)

    if args.save:
        outpath = index.index_path
        outpath.parent.mkdir(parents=True, exist_ok=True)
        outpath.write_text(index.content)
