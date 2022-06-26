from pathlib import Path
from datetime import datetime
import argparse

from project import Project
import sections


CURRENT_YEAR = datetime.today().strftime('%Y')
CURRENT_MONTH = datetime.today().strftime('%m')


class Goals(object):
    GOALS_DIRECTORY = 'goals'

    def __init__(self):
        self.project = Project(Path.cwd())
        self.directory.mkdir(exist_ok=True)
        self.initialize_current_goals()

    @property
    def directory(self):
        return self.project.directory.joinpath('goals')

    @property
    def current_goals_path(self):
        return self.directory.joinpath(f"{CURRENT_YEAR}{CURRENT_MONTH}.md")

    @property
    def goal_page_content(self):
        spacer = "\n\n"

        content = [
            sections.get_heading("[monthly]()"),
            spacer,
            sections.get_heading("[weekly]()"),
            spacer,
            sections.get_heading("[daily]()"),
            spacer,
        ]

        return "\n".join(content)

    def initialize_current_goals(self):
        if self.current_goals_path.exists():
            return

        self.current_goals_path.write_text(self.goal_page_content)


if __name__ == '__main__':
    goals = Goals()

    print(goals.current_goals_path)
