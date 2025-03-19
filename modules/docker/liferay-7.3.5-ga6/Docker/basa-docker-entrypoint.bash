#!/bin/bash
#!/bin/sh
chown -R liferay:liferay data/
su -s /bin/sh -c '/usr/local/bin/liferay_entrypoint.bash' liferay
