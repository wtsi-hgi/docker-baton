_BATON_WITH_IRODS_3_3_1_BASE = ("mercury/baton:base-for-baton-with-irods-3.3.1", "base/irods-3.3.1")
_BATON_WITH_IRODS_4_1_8_BASE = ("mercury/baton:base-for-baton-with-irods-4.1.8", "base/irods-4.1.8")


builds_to_test = [
    [_BATON_WITH_IRODS_3_3_1_BASE, ("mercury/baton:0.16.1-with-irods-3.3.1", "0.16.1/irods-3.3.1")],
    [_BATON_WITH_IRODS_3_3_1_BASE, ("mercury/baton:0.16.2-with-irods-3.3.1", "0.16.2/irods-3.3.1")],
    [_BATON_WITH_IRODS_4_1_8_BASE, ("mercury/baton:0.16.2-with-irods-4.1.8", "0.16.2/irods-4.1.8")],
    [_BATON_WITH_IRODS_3_3_1_BASE, ("mercury/baton:0.16.3-with-irods-3.3.1", "0.16.3/irods-3.3.1")],
    [_BATON_WITH_IRODS_4_1_8_BASE, ("mercury/baton:0.16.3-with-irods-4.1.8", "0.16.3/irods-4.1.8")],
    [_BATON_WITH_IRODS_3_3_1_BASE, ("mercury/baton:devel-with-irods-3.3.1", "devel/irods-3.3.1")],
    [_BATON_WITH_IRODS_4_1_8_BASE, ("mercury/baton:devel-with-irods-4.1.8", "devel/irods-4.1.8")]
]