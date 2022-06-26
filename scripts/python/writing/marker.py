import re

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
