class Heading(object):
    LENGTH = 80
    LINE_STARTCHAR = '#'
    TEXT_STARTCHAR = '#'

    def __init__(self, text, make_link=True):
        self.text = text
        self.make_link = make_link

    @property
    def line(self):
        return self.LINE_STARTCHAR + '-' * (self.LENGTH - 1)

    def __str__(self):
        return "\n".join([
            self.line,
            self.content,
            self.line,
        ])

    @property
    def content(self):
        text = self.link if self.make_link else self.text
        return f"{self.TEXT_STARTCHAR} {text}"

    @property
    def link(self):
        return f"[{self.text}]()"


class SmallHeading(Heading):
    LENGTH = 40
    LINE_STARTCHAR = '-'
    TEXT_STARTCHAR = '>'
