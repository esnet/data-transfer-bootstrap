# How to Use this Ansible Role

This ansible role is intended to redistribute a collection of best practices surrounding the Globus "Django Globus Portal Framework" and various related work, including cookiecutter install scripts

## Topics

- [Installation](#installation)
- [Customization](#customization)
- [Settings](#settings)
  - [Required Settings](#required-settings)
  - [Styling Settings](#styling-settings)
  - [Template Settings](#template-settings)

## Installation

Generally, this role can be used to install the data portal into a number of targets. See [Installation Targets](#installation-targets) to
select the target that will work best for your situation.

### Installation Targets

This ansible role can be installed or used in a number of ways:

- [Install from Existing Docker Image](#install-from-existing-docker-image)
- [Build and Publish Custom Docker Image](#build-and-publish-docker-image)
- [Install to VM with Ansible](#install-to-vm-with-ansible)

If you want to install directly to a VM, you should use the "Install to VM" instructions below.

### Install from existing Docker Image

This is the simplest way to get started with this repo. Just:

```
docker run jkafader-esnet/globus-portal
```

Then point a brower to http://localhost:8080

This image can be customized using docker mount points. See [Customization With Docker](#customization-with-docker) below.

### Publishing for production

If you're using the instructions for [Installing from an Existing Docker Image](#install-from-existing-docker-image),
you'll need to use some type of reverse proxy (usually nginx or apache2) 
with SSL encryption in front of the running docker image.

Configuring a reverse proxy is outside the scope of this documentation, but
a good guide can be found via google.


### Build and publish Docker Image

Generally, these instructions are for developers on this repo, or 

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
docker build -t globus-portal .
docker run -d -t --name=globus-portal -p 8080:80 globus-portal
```

10. if so, we're ready to run the role which will bring up the image
```
cd $WORK_DIR/data-transfer-bootstrap
ansible-playbook --connection docker --inventory inventory playbooks/docker.yml
```

11. Commit the ansible changes from the container to the image using `docker commit`
```
docker commit globus-portal
```

12. Kill the running docker container and restart it
```
docker stop globus-portal
docker run globus-portal
```

13. Use a brower to deal check that the application is running

http://localhost:8080


14. After verifying that the image is working as desired, publish it to docker:

```
docker push esnet/globus-portal
```

15. Users will now be able to follow instructions under [Install from Existing Docker Image](#install-from-existing-docker-image)

### Install to VM with Ansible

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

5. Install ansible
```
pip install ansible
```

6. Deactivate virtual environment
```
deactivate
```

7. Re-activate the ansible venv
```
source $WORK_DIR/ansible-venv/bin/activate
```

8. Edit the `[development]` or `[production]` hosts in the inventory file. (Replace `vi` with an editor of your choice if desired)

```
cd $WORK_DIR/data-transfer-bootstrap
vi inventory
```

9. Install ansible role to development hosts from inventory.
```
cd $WORK_DIR/data-transfer-bootstrap
ansible-playbook --inventory inventory playbooks/development.yml
```

10. Check your work by visiting your development host. You should see a data transfer site running on the HTTPS port, 443.

11. Make any changes or customizations needed, redeploying regularly to your development host
```
cd $WORK_DIR/data-transfer-bootstrap
ansible-playbook --inventory inventory playbooks/development.yml
```

12. Install ansible role to production hosts when ready.
```
cd $WORK_DIR/data-transfer-bootstrap
ansible-playbook --inventory inventory playbooks/production.yml
```

13. Check your work by visiting your production host on HTTPS.


## Customization with Docker

This project is heavily customizable. The simplest way to get a running site is by 
[Installing with the default Docker Image](#install-from-existing-docker-image). 
However, this will serve a default site. This section gives some direction on 
customizing the default docker image.

### Docker Mount Points

Docker supports the concept of "mounting" external files to the root filesystem
within the docker container. The default image looks for files from a number of 
mount points:

- `/mnt/templates` Django/Jinja2 templates
- `/mnt/static/fonts` Custom Fonts
- `/mnt/static/images` Custom images
- `/mnt/static/js` Custom Javascript

Generally, users will first want to customize templates, then add images, javascript,
and fonts as needed to support their customizations. See [Template Locations](template-locations)
below for details on which templates you're likely to want to override.


## Customization with Ansible

This project is heavily customizable. While you can customize many details about the UI using the
[Ansible Settings File](#the-settings-file), your institution may want to change the
header, footer, some, or all of the content presented on the site. To do this, you will need to
customize the [Jinja2](#https://jinja.palletsprojects.com/en/2.10.x/templates/) HTML templates listed below

## Custom Templates

### Template locations

Customizable templates are stored in `templates` directory. Each template name is linked in the
[Ansible Settings File](#the-ansible-settings-file). The current files in the templates directory are:

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

## The Ansible Settings File

If you're [Installing to a VM](#install-to-vm-with-ansible), the ansible
settings file will be of particular interest to you. You'll need to
specify [Required Settings](#required-settings) as below to configure
globus transfers properly.

### Required Settings

Globus settings are required for this ansible role to function. Most of these settings will need to be determined at https://app.globus.com/


```
globus.client_id
```
The client ID is available from the "settings" section, under "developers:" https://app.globus.org/settings/developers. It is listed as "Project UUID" in the UI as of this writing. It is a UUID in the form of `1234567-1234-1234-1234-123456789012`. You will have to be logged in as an administrator to register a Project (using the "+ Add Project" button in the UI) to find this setting.

```
globus.secret_key
```

The secret key is also available from the "developers" section. This should be available in the UI immediately after registering your project. It is a long string. 

```
globus.search_index
```
This setting is currently not used, but is required to be set by the globus framework this project depends on. We typically set it to a nonsense value like `1234567-1234-1234-1234-123456789012`


```
globus.collections
```

This is a YAML list of collections in your account, listed with their UUIDs. You can find the UUID for each collection by navigating to it in the globus UI and copying the UUID from the URL bar.


Here is an example of a fully filled in `globus` section for the config file:

```
globus:
  client_id: 1234567-1234-1234-1234-123456789012
  secret_key: akldichfj8e9vnowinuNEFFEJ0
  search_index: null
  collections:
    - id: 1234567-1234-1234-1234-123456789012
      name: Example collection 1
      description: This collection is included as an example.
    - id: 1234567-1234-1234-1234-123456789012
      name: Example collection 2
      description: This collection is included as an example.
    - id: 1234567-1234-1234-1234-123456789012
      name: Example collection 3
      description: This collection is included as an example.
```

### Styling Settings

In the `colors` section, you can specify some colors to make sure your data transfer site matches your organization's branding.

The default set of colors:
```
colors:
  header: "#333333"
  primary: "#AAAAFF"
  secondary: "#AAAAAA"
  surfaces:
    - "#FFFFFF"
    - "#EEEEEE"
    - "#DDDDDD"
```

### Templates Settings

The `templates` section specifies templates that will be installed by ansible. You can either customize this default set of templates, or you can add new templates to the list. The templates use `{% django_style %}` tags and variable substitution `{{ like_this }}`. 

#### Two-step Template Rendering

Some sections of the templates are rendered by ansible, and some are rendered in the django template engine. 

For this project ansible uses a special different rendering syntax. Tags look ```[% like_this %]``` and variables look `[[ like_this ]]`. This was done because some templates must be rendered during ansible deployment, whereas others must be rendered at runtime.

It will take some trial and error to understand when different variables are available, but generally, the settings (from settings.yml) are available at ansible deployment time and everything else will use the normal django syntax at runtime.

As of this writing, current documentation on django template syntax is available here: https://docs.djangoproject.com/en/5.1/topics/templates/