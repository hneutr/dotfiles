#!/usr/local/bin/python3
from pathlib import Path
from datetime import datetime
import argparse

from project import Project
import sections

GOALS_DIRECTORY = Path('/Users/hne/Documents/text/written/nonfiction/on-writing/goals')


CURRENT_YEAR = datetime.today().strftime('%Y')
CURRENT_MONTH = datetime.today().strftime('%m')


class Goals(object):
    def __init__(self, year, month, directory=GOALS_DIRECTORY):
        self.year = year
        self.month = month
        self.directory = directory

        self.set_up()

    @property
    def path(self):
        return self.directory.joinpath(f"{self.year}{self.month}.md")

    @property
    def content(self):
        spacer = "\n\n"

        content = [
            sections.Heading("monthly"),
            spacer,
            sections.Heading("weekly"),
            spacer,
            sections.Heading("daily"),
            spacer,
        ]

        return "\n".join([str(s) for s in content])

    def set_up(self):
        self.directory.mkdir(exist_ok=True)

        if not self.path.exists():
            self.path.write_text(self.content)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='goals locator')
    parser.add_argument('--year', '-y', default=CURRENT_YEAR, help='month of goals')
    parser.add_argument('--month', '-m', default=CURRENT_MONTH, help='year of goals')

    args = parser.parse_args()

    goals = Goals(
        year=args.year,
        month=args.month,
        directory=GOALS_DIRECTORY,
    )

    print(goals.path)
