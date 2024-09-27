#!/bin/bash

echo "Doing installation"

ANSIBLE_REPO="https://github.com/mmaschenk/tudelft-wsl-ansible.git"

apt-get update -y

apt install -y ansible

cat << EOD >> /etc/wsl.conf
[user]
default=tud

[network]
hostname=tudelft
EOD

CLONE_DIR="/tmp/repo"
ANSIBLE_BOOTSTRAP_PLAYBOOK="/tmp/ansible_bootstrap.yml"
ANSIBLE_TEMP_PLAYBOOK="/tmp/combined_ansible.yml"
ANSIBLE_MAIN_PLAYBOOK="${CLONE_DIR}/wsl.yml"

cat <<EOD > "$ANSIBLE_BOOTSTRAP_PLAYBOOK"
---
- name: Clone and run Ansible playbook from GitHub
  hosts: localhost
  gather_facts: no
  tasks:
    - name: Ensure Git is installed
      package:
        name: git
        state: present

    - name: Clone the GitHub repository
      shell: |
        if [ ! -d "${CLONE_DIR}/.git" ]; then
          git clone ${ANSIBLE_REPO} ${CLONE_DIR}
        else
          cd ${CLONE_DIR} && git pull
        fi

    - name: Find the main playbook file
      find:
        paths: "${CLONE_DIR}"
        patterns: "*.yml"
        recurse: yes
      register: found_playbooks

EOD

ansible-playbook -i localhost, -c local "$ANSIBLE_BOOTSTRAP_PLAYBOOK"

ansible-playbook -i localhost, -c local "$ANSIBLE_MAIN_PLAYBOOK"
