#!/bin/bash
# Copied from https://github.com/logandonley/dotfiles
# based on https://www.youtube.com/watch?v=-RkANM9FfTM

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        source /etc/os-release
        case "$ID" in
            fedora|amzn|rocky)
                if [[ "$VERSION_ID" == "2" ]]; then
                    # on amazon linx 2, ansible is not in the repos so we need to install it
                    # from pypi using pip.
                    sudo yum install -y python3 python3-pip
                    python3 -m pip install ansible --user
                    
                elif [[ "$VERSION_ID" == "2023" ]]; then
                    sudo dnf install -y ansible
                fi
                ;;
            ubuntu)
                sudo apt-get update && sudo apt-get install -y ansible
                ;;
            *)
                echo "Unsupported Linux distribution"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac


ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass

echo "Ansible installation complete."

