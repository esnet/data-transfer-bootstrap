# How to Use this Ansible Role

This ansible role is intended to redistribute a collection of best practices surrounding the Globus "Django Globus Portal Framework" and various related work, including cookiecutter install scripts

## Topics

- [Installation](#installation)
- [Customization](#customization)
- [Settings](#settings)
  - [Required Settings](#required-settings)

## Installation

Generally, this role can be used to install the data portal into a number of targets. See [Installation Targets](#installation-targets) to
select the target that will work best for your situation.

### Installation Targets

This ansible role can be installed or used in a number of ways:

- [Install to Docker](#install-to-docker)
- [Publish Docker Image](#publish-docker-image)
- [Install to VM](#install-to-vm)
- [Publish Vagrant Box](#publish-vagrant-box)

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
cd $WORK_DIR/data-transfer-bootstrap
ansible-playbook --connection docker --inventory inventory playbooks/docker.yml
```

11. Use a brower to deal check that the application is running

http://localhost:8080




### Publish Docker Image

TODO

### Install to VM

TODO

### Publish Vagrant Box

TODO

## Customization

This project is heavily customizable. While you can customize many details about the UI using the
[Ansible Settings File](#the-settings-file), your institution may want to change the
header, footer, some, or all of the content presented on the site. To do this, you will need to
customize the [Jinja2](#https://jinja.palletsprojects.com/en/2.10.x/templates/) HTML templates listed below

### Template locations

Customizable templates are stored in `templates` directory. Each template name is linked in the
[Ansible Settings File](#the-settings-file). The current files in the templates directory are:

#### Header Block Template

This is the header block on all pages. Most installations will want to customize this, to match the look and feel of your organization or team.

```
templates/header.html 
```

#### Footer Block Template

This is the footer block on all pages. Most installations will want to customize this, to match the look and feel of your organization or team.

```
templates/footer.html 
```

#### Base Template

This page is the "framework" that all other pages will use to display their content. It's the "base" page that all others "inherit" from.

```
templates/base.html
```

#### Main Page

This page is the landing / main / index.html page for the site.

```
templates/main.html
```

##### Main Page: "Getting Started" block

This block allows you to override the "getting started" block, if needed.

```
templates/getting_started_block.html
```

##### Main Page: "Documentation" block

This block allows you to override the "documentation" block, if needed.

```
templates/documentation_block.html
```

#### Transfer Page

This is the page that allows users to initiate a transfer

```
templates/transfers.html
```

#### Documentation Page

This page shows a documentation overview and documentation sections. The URLs correspond to the names of files in the [Individual Documentation Sections](#individual-documentation-sections). When a user visits `/documentation/`, they see `templates/documentation/overview.html`, at `/documentation/transfers/` they see `templates/documentation/transfers.html`.

```
templates/documentation.html
```

#### Individual Documentation Sections

These are all stored in the `templates/documentation` directory.

```
templates/documentation/overview.html
templates/documentation/transfers.html
```

### Re-deploying Templates

During the lifecycle of your site, you will likely need to deploy templates multiple times to "get them right." We made a special shortcut for this workflow to speed things up:

```
ansible-playbook --connection docker --inventory inventory playbooks/templates.yml
```

## The Settings File

TODO

### Required Settings

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
