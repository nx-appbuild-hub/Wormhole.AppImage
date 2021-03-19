# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)

all: clean

	mkdir -p $(PWD)/build/Boilerplate.AppDir/application
	mkdir -p $(PWD)/build/Boilerplate.AppDir/vendor

	apprepo --destination=$(PWD)/build appdir boilerplate python3.8 python3.8-dev python3.8-psutil \
										python3.8-setuptools python3-pip python3-dnf python3-apt \
										openssl libffi7 intltool libgudev-1.0-0 libffi libgudev


	echo 'case "$${1}" in' 														>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo "  '--python') exec \$${APPDIR}/bin/python3.8 \$${*:2} ;;" 			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '  *)   $${APPDIR}/bin/python3.8  -m wormhole $${@} ;;' 				>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'esac' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun


	sed -i 's/#APPDIR=`pwd`/APPDIR=`dirname \$${0}`/' $(PWD)/build/Boilerplate.AppDir/AppRun
	$(PWD)/build/Boilerplate.AppDir/AppRun --python -m pip install  -r $(PWD)/requirements.txt --target=$(PWD)/build/Boilerplate.AppDir/vendor --upgrade
	$(PWD)/build/Boilerplate.AppDir/AppRun --python -m pip uninstall typing -y
	sed -i 's/APPDIR=`dirname \$${0}`/#APPDIR=`dirname \$${0}`/' $(PWD)/build/Boilerplate.AppDir/AppRun


	rm -f $(PWD)/build/Boilerplate.AppDir/*.png 		|| true
	rm -f $(PWD)/build/Boilerplate.AppDir/*.desktop 	|| true
	rm -f $(PWD)/build/Boilerplate.AppDir/*.svg 		|| true	

	cp --force $(PWD)/AppDir/*.svg 		$(PWD)/build/Boilerplate.AppDir 			|| true	
	cp --force $(PWD)/AppDir/*.desktop 	$(PWD)/build/Boilerplate.AppDir 			|| true	
	cp --force $(PWD)/AppDir/*.png 		$(PWD)/build/Boilerplate.AppDir 			|| true	

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage  $(PWD)/build/Boilerplate.AppDir $(PWD)/Wormhole.AppImage
	chmod +x $(PWD)/Wormhole.AppImage


clean:
	rm -rf ${PWD}/build
