#### /etc/ssh/sshd_config

    RSAAuthentication yes
    PubkeyAuthentication yes
    AuthorizedKeysFile .ssh/authorized_keys
    PasswordAuthentication no
    ChallengeResponseAuthentication no
    UsePAM no
    PermitRootLogin no