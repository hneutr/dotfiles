from pathlib import Path
import re


class Reference(object):
    """
    A marker _reference_ is as follows: `[label](path:text?=flags)`

    Only a `path` is required.
    """
    PATH_DELIMITER = ':'
    FLAGS_DELIMITER = '?='

    REGEX = "\[(.*)\]\((.*)\)"

    def __init__(self, project, label='', path='', text='', flags=None):
        self.project = project

        self.label = label
        self.path = path
        self.text = text
        self.flags = [] if flags == None else flags

    def __str__(self):
        return f"[{self.label}]({self.reference})"

    @property
    def reference(self):
        reference = self.project.shorten_path(self.path)

        if self.text:
            reference += f'{self.PATH_DELIMITER}{self.text}'

        if self.flags:
            flags = "".join(self.flags)
            reference += f'{self.FLAGS_DELIMITER}{flags}'

        return reference

    @classmethod
    def string_contains_instance(cls, string):
        return re.match(cls.REGEX, string)

    @classmethod
    def from_string(cls, string, project):
        label, reference = re.search(cls.REGEX, string).groups()

        path, text, flags = cls.parse_reference(reference)

        path = project.expand_path(path)

        return Reference(
            project=project,
            label=label,
            path=path,
            text=text,
            flags=flags,
        )

    @classmethod
    def parse_reference(cls, string):
        path = string
        text = ''
        flags = ''

        if cls.PATH_DELIMITER in string:
            path, text = string.split(cls.PATH_DELIMITER)

        if cls.FLAGS_DELIMITER in text:
            text, flags = text.split(cls.FLAGS_DELIMITER)

        if flags:
            flags = list(flags)

        return path, text, flags

    @classmethod
    def get_references_in_string(cls, project, string):
        unparsed = string

        content = []
        while unparsed:
            if Reference.string_contains_instance(unparsed):
                reference = Reference.from_string(string, project)
                parsed, unparsed = unparsed.split(str(reference), 1)
                content.append(parsed)
                content.append(reference)
            else:
                content.append(unparsed)
                break

        return content

    @classmethod
    def update_references_in_string(cls, project, string, updates):
        """
        updates are of the form:
        [
            {
                'old_path': required. Path.
                'new_path': optional. Path.
                'old_text': optional. String.
                'new_text': optional. String.
            }
        ]

        paths should be unshortened
        """
        new_string = ""
        for item in cls.get_references_in_string(project, string):
            if isinstance(item, Reference):
                for update in updates:
                    if item.update_applies(update):
                        item.apply_update(update)

            new_string += str(item)

        return new_string

    def update_applies(self, update):
        conditions = []

        path = update['old_path']

        if path.is_dir():
            conditions.append(str(self.path).startswith(str(path)))
        elif path.is_file():
            conditions.append(str(self.path) == str(path))

        if 'old_text' in update:
            conditions.append(self.text == update['old_text'])

        return all(conditions)

    def apply_update(self, update):
        if 'new_path' in update:
            new_path = str(self.path).replace(
                str(update['old_path']),
                str(update['new_path']),
            )

            self.path = Path(new_path)

        if 'new_text' in update:
            self.text = update['new_text']


class Marker(object):
    """
    A marker is as follows:
    [text]()
    """
    STARTCHARS = "".join(['#', '>'])
    REGEX = ".*\[(.*)\]\(\)"

    def __init__(self, text=''):
        self.text = text

    def __str__(self):
        return f"[{self.text}]()"

    @classmethod
    def string_contains_instance(cls, string):
        return re.match(cls.REGEX, string)

    @classmethod
    def from_string(cls, string):
        text = re.search(cls.REGEX, string).groups()[0]

        return Marker(text=text)

    def get_reference(
        self, 
        project,
        path,
        label=None,
        flags=None,
    ):
        return Reference(
            project=project,
            label=self.text if not label else label,
            path=path,
            text=self.text,
            flags=flags,
        )

    def get_reference_from_string(cls, string, project, path, label=None, flags=None):
        marker = Marker.from_string(string)

        return marker.get_reference(
            project=project,
            path=path,
            label=label,
            flags=flags,
        )

    @classmethod
    def update_file_markers(self, path, old_text, new_text):
        if not path.exists():
            return

        old = str(Marker(old_text))
        new = str(Marker(new_text))

        content = path.read_text()
        content = content.replace(old, new)
        path.write_text(content)
