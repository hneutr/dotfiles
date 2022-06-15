#!/usr/local/bin/python3
from pathlib import Path
from datetime import datetime
import argparse

JOURNALS_DIRECTORY = Path('/Users/hne/Documents/text/written/nonfiction/on-writing/journals')

CURRENT_YEAR = datetime.today().strftime('%Y')
CURRENT_MONTH = datetime.today().strftime('%m')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='writing journaler')
    parser.add_argument('project', default=None, nargs='?',  help='which project to open a journal for')
    parser.add_argument('--year', '-y', default=CURRENT_YEAR, help='month of journal')
    parser.add_argument('--month', '-m', default=CURRENT_MONTH, help='year of journal')
    parser.add_argument('--directory', '-d', default=False, action='store_true', help='return only the directory')

    args = parser.parse_args()

    directory = JOURNALS_DIRECTORY

    if args.project:
        directory = directory.joinpath(args.project)

    directory.mkdir(exist_ok=True)

    journal_path = directory.joinpath(f"{args.year}{args.month}.md")

    if args.directory:
        print(directory)
    else:
        print(journal_path)
