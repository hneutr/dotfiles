from pathlib import Path
from functools import cached_property
import distutils.dir_util


from marker import Marker, Reference


class Manipulator(object):
    """
    use cases:
    - moving paths
    - renaming markers
    - moving markers
    """
    def __init__(self, project):
        self.project = project

    def move_path(self, from_path, to_path):
        """
        don't _rename_, _move_, i.e., don't overwrite `to_path`

        if `from_path` is a file and `to_path` doesn't end in `.md`:
            - infern the filename (add `from_path.stem` to `to_path`)

        process:
        1. call `update_path`
        2. call `update_reference_path`

        test cases:
        1. move file to file in same dir
        2. move file to file in different dir
        3. move file to different dir
        4. move dir to new dir
        5. move dir to existing dir (shouldn't overwrite new_dir)
        """
        if from_path.is_file() and not to_path.name.endswith('.md'):
            to_path = to_path.joinpath(from_path.name)

        paths_to_update = self.get_paths_to_update(from_path, to_path) 
        
        self.update_paths(paths_to_update)
        self.update_references(paths_to_update)

    def get_paths_to_update(self, from_path, to_path):
        old = self.project.shorten_path(from_path).replace('./', '', 1)
        new = self.project.shorten_path(from_path).replace('./', '', 1)

        path_updates = []
        for mirror in self.get_mirrors(from_path):
            path_updates.append({
                'old_path': mirror,
                'new_path': Path(str(m).replace(old, new)),
            })

        return path_updates

    def get_mirrors(self, path):
        """
        if `path` = './dir/...', we're looking for paths like:
        - './subdir/dir/...'

        i.e., paths that are a prefixed version of the input path

        tests:
        - path=file, matches and non-matches in subdirs
        - path=dir, matches and non-matches in subdirs
        - check that path is a mirrored path
        """
        relative_path = self.project.shorten_path(path).replace('./', '', 1)

        # we might have to do this, but not sure
        # relative_path = relative_path.rstrip('/')

        mirrors = []
        for other_path in self.project.root.rglob('*'):
            if str(other_path).endswith(relative_path):
                mirrors.append(other_path)

        return mirrors

    def rename_marker(self, path, from_text, to_text):
        """
        process:
        1. call `update_marker_text`
        2. call `update_reference_text`
        """
        self.update_marker_text(path, from_text, to_text)
        self.update_references({
            'old_path': path,
            'old_text': from_text,
            'new_text': to_text,
        })

    def move_marker(self, from_path, to_path, from_text, to_text):
        """
        1. call `convert_marker_to_reference`
        2. call `convert_reference_to_marker`
        3. call `update_reference`
        """
        self.convert_marker_to_reference(
            marker_path=from_path,
            reference_path=to_path,
            marker_text=from_text,
            reference_text=to_text,
        )

        self.convert_reference_to_marker(
            path=reference_path,
            text=to_text,
        )

        self.update_references({
            'old_path': from_path,
            'new_path': to_path,
            'old_text': from_text,
            'new_text': to_text,
        })

    def update_paths(self, paths_to_update):
        """
        don't _rename_, _move_, i.e., don't overwrite `to_path`
        """
        for update in paths_to_update:
            from_path = update['old_path']
            to_path = update['to_path']

            if to_path.exists() and to_path.is_dir():
                distutils.dir_util.copy_tree(str(from_path), str(to_path))

                for path in from_path.rglob('*'):
                    if path.is_dir():
                        path.rmdir()
                    elif path.is_file():
                        path.unlink()
            else:
                target_dir = to_path if to_path.is_dir() else to_path.parent
                target_dir.mkdir(exist_ok=True, parents=True)

                from_path.rename(to_path)

        for path in self.project.root.rglob('*'):
            if path.is_dir() and not len(list(path.rglob('*'))):
                path.rmdir()

    def update_references(self, updates):
        for path in self.project.root.rglob('*.md'):
            old_content = path.read_text()

            new_content = Reference.update_references_in_string(
                project=self,
                string=old_content,
                updates=updates,
            )

            if new_content != old_content:
                path.write_text(new_content)

    def update_marker_text(self, path, from_text, to_text):
        from_marker = str(Marker(from_text))
        to_marker = str(Marker(to_text))

        content = path.read_text()
        content = content.replace(from_marker, to_marker)
        path.write_text(content)

    def convert_marker_to_reference(self, marker_path, reference_path, marker_text, reference_text):
        marker = Marker(marker_text)

        reference = Reference(
            project=self.project,
            label=reference_text,
            path=reference_path,
            text=reference_text,
        )

        content = marker_path.read_text()
        content = content.replace(str(marker), str(reference))
        marker_path.write_text(content)

    def convert_reference_to_marker(self, path, text):
        update = {
            'old_path': path,
            'new_path': ''
            'old_text': text,
            'new_text': ''
            'new_label': text,
            'new_flags': [],
        }

        content = Reference.update_references_in_string(
            project=self,
            string=path.read_text(),
            updates=update,
        )

        path.write_text(content)
