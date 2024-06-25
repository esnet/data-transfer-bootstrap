# How to Use this Ansible Role

This ansible role is intended to redistribute a collection of best practices surrounding the Globus "Django Globus Portal Framework" and various related work, including cookiecutter install scripts

## Install Targets

This ansible role can be installed or used in a number of ways:

- Install to Docker
- Publish Docker Image
- Install to VM
- Publish Vagrant Box

If you want to install directly to a VM, you should use the "Install to VM" instructions below.

### Install to Docker

1. Assumption: You use ~/work for work-related files
```
export WORK_DIR=~/work
```

2. Clone this repo
```
cd $WORK_DIR
git clone git@github.com:esnet/data-transfer-bootstrap.git
```

3. Create a virtualenv for installing ansible
```
python3 -m venv $WORK_DIR/ansible-venv
```

4. Activate the Ansible virtualenv
```
source $WORK_DIR/ansible-venv/bin/activate
```

5. Install the python 'docker' module (note that this is not docker)
```
pip install docker
```

6. Install ansible
```
pip install ansible
```

7. Deactivate virtual environment
```
deactivate
```

8. Re-activate the ansible venv
```
source $WORK_DIR/ansible-venv/bin/activate
```

9. Start the target docker container, map port 80 in the container to localhost:8080
```
docker run -d -t --name=globus-portal -p 8080:80 python:3.9-slim-bullseye
```

10. if so, we're ready to run the role which will bring up the image
```
ansible-playbook --connection docker --inventory ansible/inventory $WORK_DIR/data-transfer-bootstrap/ansible/docker.yml
```

11. Use a brower to deal check that the application is running

http://localhost:8080




### Publish Docker Image

TODO

### Install to VM

TODO

### Publish Vagrant Box

TODO

## The Ansible Settings File

TODO

### Required Settings

TODO

#### Globus Settings

Globus settings are required for this ansible role to function. Generally, we'll use the `globus` command line tool to determine these settings

```
globus.client_id
```

```
globus.secret_key
```

```
globus.search_index
```

```
globus.collections
```
