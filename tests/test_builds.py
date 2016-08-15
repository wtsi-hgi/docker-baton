import os
import unittest
from typing import List, Dict, Optional, Tuple

from inflection import camelize

from hgicommon.docker.client import create_client
from tests.builds_to_test import builds_to_test
from tests.common import create_temp_docker_mountable_directory
from testwithbaton._baton import build_baton_docker
from testwithbaton.models import BatonImage
from testwithirods.api import IrodsVersion, get_static_irods_server_controller
from testwithirods.models import IrodsServer, ContainerisedIrodsServer

_PROJECT_ROOT = "%s/.." % os.path.dirname(os.path.realpath(__file__))

_started_irods_servers = dict()     # type: Dict[IrodsVersion, IrodsServer]


class _TestDockerizedBaton(unittest.TestCase):
    """
    Tests for a Dockerised baton setup.
    """
    @staticmethod
    def _build_image(top_level_image: Tuple[Optional[Tuple], Tuple[str, str]]):
        """
        Builds images bottom up, building the top level image last.
        :param top_level_image: representation of the top level image
        """
        image = top_level_image
        images = []     # type: List[Tuple[str, str]]
        while image is not None:
            images.insert(0, image[1])
            image = image[0]

        client = create_client()
        for image in images:
            tag = image[0]
            directory = "%s/%s" % (_PROJECT_ROOT, image[1])
            baton_image = BatonImage(tag=tag, path=directory)
            build_baton_docker(client, baton_image)

    @staticmethod
    def get_irods_server(irods_version: IrodsVersion) -> ContainerisedIrodsServer:
        """
        Gets an iRODS server of the given version.

        This server is NOT isolated between test cases. Therefore it should be treated as read-only. It should also not
        be stopped at teardown.
        :param irods_version: the iRODS version
        :return: the containerised server
        """
        global _started_irods_servers
        if irods_version not in _started_irods_servers:
            _started_irods_servers[irods_version] = get_static_irods_server_controller(irods_version).start_server()
        return _started_irods_servers[irods_version]

    def __init__(self, irods_version: IrodsVersion, top_level_image: Tuple[Optional[Tuple], Tuple[str, str]], *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._irods_version = irods_version
        self._top_level_image = top_level_image

    def setUp(self):
        type(self)._build_image(self._top_level_image)

    def test_baton_installed(self):
        response = self._run(command="baton", environment={"DEBUG": 1}, stderr=False)
        self.assertEqual(response, '{"avus":[]}')

    def test_jq_installed(self):
        response = self._run(command="jq -n '{}'", environment={"DEBUG": 1}, stderr=False)
        self.assertEqual(response, '{}')

    def test_icommands_installed(self):
        response = self._run(command="ienv", environment={"DEBUG": 1}, stderr=False)
        self.assertIn("Release Version = rods", response)

    def test_baton_can_connect_to_irods_with_settings_file(self):
        irods_server = self.get_irods_server(self._irods_version)

        settings_directory = create_temp_docker_mountable_directory()
        IrodsController = get_static_irods_server_controller(self._irods_version)
        # XXX: This is rather hacky - it should be possible to get the name from the iRODS controller
        if self._irods_version == IrodsVersion.v3_3_1:
            IrodsController.write_connection_settings("%s/.irodsEnv" % settings_directory, irods_server)
        else:
            IrodsController.write_connection_settings("%s/irods_environment.json" % settings_directory, irods_server)
        host_config = create_client().create_host_config(binds={
            settings_directory: {
                "bind": "/root/.irods",
                "mode": "rw"
            }
        }, links={
            irods_server.host: irods_server.host
        })

        user = irods_server.users[0]
        response = self._run(command="ils", environment={"IRODS_PASSWORD": user.password}, host_config=host_config)
        self.assertEqual(response, "/%s/home/%s:" % (user.zone, user.username))

    def test_baton_can_connect_to_irods_with_setting_parameters(self):
        irods_server = self.get_irods_server(self._irods_version)
        host_config = create_client().create_host_config(links={
            irods_server.host: irods_server.host
        })
        user = irods_server.users[0]
        response = self._run(command="ils", environment={
            "IRODS_HOST": irods_server.host,
            "IRODS_PORT": irods_server.port,
            "IRODS_USERNAME": user.username,
            "IRODS_ZONE": user.zone,
            "IRODS_PASSWORD": user.password
        }, host_config=host_config)
        self.assertEqual(response, "/%s/home/%s:" % (user.zone, user.username))

    def _run(self, stderr=True, **kwargs) -> str:
        """
        Run the containerised baton image that is been tested.
        :param stderr: whether content written to stderr should be included in the return
        :param kwargs: named arguments that are binded to corresponding parameters in docker-py's `create_container`
        method
        :return: what the command put onto stdout and stderr (if applicable)
        """
        client = create_client()
        tag = self._top_level_image[1][0]
        container = client.create_container(tag, **kwargs)
        id = container.get("Id")
        client.start(id)
        log_generator = client.attach(id, logs=True, stream=True, stderr=stderr)
        return "".join([line.decode("utf-8") for line in log_generator]).strip()


for _setup in builds_to_test:
    test_class_name_postfix = camelize(_setup[1][0].split(":")[-1].replace("-", "_")).replace(".", "_")
    class_name = "%s%s" % (_TestDockerizedBaton.__name__[1:], test_class_name_postfix)

    def init(self, *args, **kwargs):
        irods_version = IrodsVersion["v%s" % type(self)._SETUP[1][1].split("-")[-1].replace(".", "_")]
        super(type(self), self).__init__(irods_version, type(self)._SETUP, *args, **kwargs)

    globals()[class_name] = type(
        class_name,
        (_TestDockerizedBaton, ),
        {
            "_SETUP": _setup,
            "__init__": init
        }
    )


# Stop unittest from running the abstract base test
del _TestDockerizedBaton


if __name__ == "__main__":
    unittest.main()
