#!/bin/bash
#!/bin/sh
sh /rainloop-install.bash
#service apache2 start
httpd-foreground
#tail -f /dev/null
