#!/bin/bash
python /backend/manage.py makemigrations
python /backend/manage.py migrate

copy_files() {
    if [ -d /mnt/templates/ ]; then
	echo "Copying templates from /mnt/templates/...";
	cp /mnt/templates/* /backend/templates/globus-portal-framework/v2/;
    fi;
    if [ -d /mnt/static/fonts/ ]; then
	echo "Copying fonts from /mnt/static/fonts/...";
	cp /mnt/static/fonts/* /backend/static/fonts/;
    fi;
    if [ -d /mnt/static/images/ ]; then
	echo "Copying fonts from /mnt/static/images/...";
	cp /mnt/static/images/* /backend/static/images/;
    fi;
    if [ -d /mnt/static/js/* ]; then	
	echo "Copying javascript from /mnt/static/js/...";
	cp /mnt/static/js/* /backend/static/js/;
    fi;
}

# checking whether backend exists is a proxy for checking that ansible installation is finished
if [ -d /backend/ ]; then
    copy_files
fi;

python /backend/manage.py collectstatic --settings=$DJANGO_SETTINGS_MODULE --noinput

exec /usr/bin/supervisord --nodaemon -c /etc/supervisor/supervisord.conf


