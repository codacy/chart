from os.path import dirname, abspath
from diagrams import Diagram, Cluster
from diagrams.k8s.group import NS
from diagrams.digitalocean.network import Firewall
from diagrams.digitalocean.database import DbaasPrimary
from diagrams.digitalocean.compute import K8SCluster, K8SNodePool

file_dir = dirname(abspath(__file__))

with Diagram(
    name="Digital Ocean K8s Cluster",
    show=False,
    direction="LR",
    curvestyle="ortho",
    outformat=["jpg"],
    filename=dirname(file_dir) + "/out/" + "do",
    graph_attr={"pad": "0.2",},
):

    with Cluster("Digital Ocean"):
        
        with Cluster("k8s_cluster"):
            cluster = K8SCluster("k8s_cluster")
            node_pools = cluster - [
                K8SNodePool("default_node_pool"),
                K8SNodePool("auto_scale_pool"),
            ]

            with Cluster("namespaces"):
                namespaces = cluster - [
                    NS("codacy_dev"),
                    NS("codacy_sandbox"),
                    NS("codacy_release"),
                ]

        with Cluster("database_cluster"):
            node_pools - Firewall("postgres_fw") - DbaasPrimary("postgres_db")

