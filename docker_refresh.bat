cd .\my_utilities

python setup.py install

docker cp ./ami_utilities/. my-ds-notebook:/home/jovyan/my_utilities/