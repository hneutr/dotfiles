#!/usr/local/bin/python3
from pathlib import Path
from datetime import datetime
import argparse

from project import Project

JOURNALS_DIRECTORY = Path('/Users/hne/Documents/text/written/journals/content')

CURRENT_YEAR = datetime.today().strftime('%Y')
CURRENT_MONTH = datetime.today().strftime('%m')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='writing journaler')
    parser.add_argument('--source', '-s', default=Path.cwd(), help='what to generate the index from (file/directory)')
    parser.add_argument('--journal', '-j', type=str, help="which journal to use")
    parser.add_argument('--year', '-y', default=CURRENT_YEAR, help='month of journal')
    parser.add_argument('--month', '-m', default=CURRENT_MONTH, help='year of journal')

    args = parser.parse_args()

    if args.journal:
        directory = JOURNALS_DIRECTORY.joinpath(args.journal)
    else:
        project = Project(args.source)
        directory = project.journals_directory

    directory.mkdir(parents=True, exist_ok=True)

    journal_path = directory.joinpath(f"{args.year}{args.month}.md")

    print(journal_path)
