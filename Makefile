
all: PutHTML

PutHTML:
	cp LabR.html /var/www/html/Lab1/

	echo "Current contents of your Ruby directory: "
	ls -l /var/www/html/Lab1/
