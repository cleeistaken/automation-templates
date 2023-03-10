#! /bin/bash

echo "Installing vim"
sudo apt install -y vim

echo "Install python"
sudo apt install -y python3

echo "Upgrade python pip"
python3 -m pip install pip --upgrade

echo "Upgrade python setuptools"
python3 -m pip install setuptools --upgrade

echo "Install pipenv"
python3 -m pip install pipenv --upgrade

if [ ! ~/.ssh/id_rsa ]
then
 echo "Generate new id_rsa"
 ssh-keygen -q -t rsa -N '' <<< $'\ny' > /dev/null 2>&1
else
  echo "id_rsa already exists"
fi

echo "Install terraform"
sudo snap install terraform --classic

echo "Install docker"
sudo apt install -y docker.io
sudo usermod -aG docker `whoami`

# Nasty bug
# Ref. https://github.com/pypa/pipenv/issues/5075
echo "Exporting SETUPTOOLS_USE_DISTUTILS"
export SETUPTOOLS_USE_DISTUTILS=stdlib

echo "Creating and entering into pipenv"
pipenv install --python `which python3`

echo "Running ansible"
pushd ansible > /dev/null
pipenv run ansible-playbook main.yml --ask-become-pass
popd > /dev/null

echo "Done"