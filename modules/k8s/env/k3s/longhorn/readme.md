sudo blkid
sudo nano /etc/fstab
sudo mkdir -p /var/lib/longhorn
UUID=13b897af-e5d1-459a-bcc1-7a51d6f4726d	/var/lib/longhorn	ext4	defaults	0	2

https://raw.githubusercontent.com/longhorn/longhorn/v1.3.1/deploy/longhorn.yaml


Volumes distribution:

configurar longhorn (nodos) con los siguientes tags (revisar yaml de los deployment para que el affinity se cumpla)

master0
	jenkins-data
	gogs-db
master1
	jenkins-data
	gogs-data
master2
	gogs-data
	gogs-db


Settings UI:

Automatically Cleanup System Generated Snapshot - enable
Orphan Auto-Deletion - enable
Allow Volume Creation with Degraded Availability - disable
Replica Node Level Soft Anti-Affinity - enable

https://longhorn.io/kb/troubleshooting-volume-pvc-xxx-not-scheduled/

https://longhorn.io/docs/archives/1.0.2/references/settings/#replica-node-level-soft-anti-affinity

https://longhorn.io/docs/1.3.2/volumes-and-nodes/storage-tags/