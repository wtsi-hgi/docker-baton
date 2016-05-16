import os
import unittest
from typing import List, Dict
from typing import Tuple

from testwithbaton._baton import build_baton_docker
from testwithbaton._common import create_client
from testwithbaton.irods._api import IrodsVersion, get_static_irods_server_controller
from testwithbaton.models import BatonImage
from testwithbaton.models import IrodsServer

from tests.common import create_temp_docker_mountable_directory

_PROJECT_ROOT = "%s/.." % os.path.dirname(os.path.realpath(__file__))

_started_irods_servers = dict()     # type: Dict[IrodsVersion, IrodsServer]


class _TestBuild(unittest.TestCase):
    """
    TODO
    """
    @staticmethod
    def _build_images(images: List[Tuple[str, str]]):
        """
        TODO
        :param images:
        """
        for tag, directory in images:
            client = create_client()
            baton_image = BatonImage(tag=tag, path=directory)
            build_baton_docker(client, baton_image)

    @staticmethod
    def get_irods_server(irods_version: IrodsVersion) -> IrodsServer:
        """
        TODO
        :param irods_version:
        :return:
        """
        global _started_irods_servers
        if irods_version not in _started_irods_servers:
            _started_irods_servers[irods_version] = get_static_irods_server_controller(irods_version).start_server()
        return _started_irods_servers[irods_version]

    def __init__(self, irods_version: IrodsVersion, images: List[Tuple[str, str]], *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._irods_version = irods_version
        self._images = [(tag, "%s/%s" % (_PROJECT_ROOT, directory)) for tag, directory in images]

    def setUp(self):
        self._build_images(self._images)

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
        IrodsController.write_connection_settings("%s/.irods" % settings_directory, irods_server)
        host_config = create_client().create_host_config(binds={
            settings_directory: {
                "bind": "/root/.irods",
                "mode": "rw"
            }
        })

        print(self._run(command="ls -altr /root/.irods", environment={"DEBUG": 1}, host_config=host_config, stderr=False))
        response = self._run(command="ls", environment={"PASSWORD": 1}, host_config=host_config)
        print(response)
        self.assertFalse(True)

    def _run(self, stderr=True, **kwargs) -> str:
        """
        Run the containerised baton image that is been tested.
        :param stderr: whether content written to stderr should be included in the return
        :param kwargs: named arguments that are binded to corresponding parameters in docker-py's `create_container`
        method
        :return: what the command put onto stdout and stderr (if applicable)
        """
        client = create_client()
        tag = self._images[-1][0]
        container = client.create_container(tag, **kwargs)
        id = container.get("Id")
        client.start(id)
        log_generator = client.attach(id, logs=True, stream=True, stderr=stderr)
        return "".join([line.decode("utf-8") for line in log_generator]).strip()






class TestBuild0_16_1_WithIrods3_3_1(_TestBuild):
    """
    TODO
    """
    _IRODS_VERSION = IrodsVersion.v3_3_1
    _IMAGES = [
        ("mercury/baton:base-for-baton-with-irods-3.3.1", "base/irods-3.3.1"),
        ("mercury/baton:0.16.2-with-irods-3.3.1", "0.16.1/irods-3.3.1")
    ]

    def __init__(self, *args, **kwargs):
        super().__init__(
            TestBuild0_16_1_WithIrods3_3_1._IRODS_VERSION, TestBuild0_16_1_WithIrods3_3_1._IMAGES, *args, **kwargs)
        # logging.root.setLevel(logging.DEBUG)


del _TestBuild

if __name__ == "__main__":
    unittest.main()
