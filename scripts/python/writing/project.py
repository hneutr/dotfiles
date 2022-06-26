from pathlib import Path


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

    def remove_project_path(self, path):
        path = str(path).replace(str(self.directory), '')

        if path.startswith('/'):
            path = path.replace('/', '', 1)

        return path

    def get_short_path(self, path):
        return './' + self.remove_project_path(path)

    def get_project_path(self, path, prefix=None):
        full_path = self.directory

        if prefix:
            full_path = full_path.joinpath(prefix)

        full_path = full_path.joinpath(path)

        return full_path

    def add_prefix_to_path(self, path, prefix):
        return self.directory.joinpath(prefix, self.remove_project_path(path))
