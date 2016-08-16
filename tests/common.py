import os

from shutil import rmtree
from uuid import uuid4

import atexit


def create_temp_docker_mountable_directory() -> str:
    """
    Creates a temporary Docker mountable directory that will be removed on exit.
    :return: the path to the directory.
    """
    def remove_temp_folder(location: str):
        if os.path.exists(location):
            try:
                rmtree(location)
            except OSError:
                pass

    # XXX: Using the default setup of Docker, the temp directory that Python uses cannot be mounted on Mac.
    # As a work around, mounting in the directory in which the test is running in.
    accessible_directory = "%s/.." % os.path.dirname(os.path.realpath(__file__))
    temp_directory_path = os.path.join(accessible_directory, ".test-%s" % str(uuid4()))
    atexit.register(remove_temp_folder, temp_directory_path)
    os.mkdir(temp_directory_path)

    return temp_directory_path
