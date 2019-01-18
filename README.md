### Build docker image
```
docker build -t my-ds-notebook -f ./Dockerfile ./
```

### Run container, pass keys as env vars
```
docker run -it --name my-ds-notebook -p 8888:8888 -v ./work:/home/jovyan/work -e AWS_ACCESS_KEY_ID=$(aws --profile default configure get aws_access_key_id) -e AWS_SECRET_ACCESS_KEY=$(aws --profile default configure get aws_secret_access_key) my-ds-notebook
```

### List containers
```
docker container ls
```

### Remove container
```
docker container rm my-ds-notebook
```

### Remove image
```
docker rmi my-ds-notebook:latest
```

### Remove all images
```
docker rm $(docker ps -a -q)
```

### Start stopped container
```
docker start -i my-ds-notebook
```

### Stop container
```
docker stop my-ds-notebook
```

### Restart container
```
docker restart my-ds-notebook
```

### Rebuild ami_utilities package (; for chaining in powershell..)
```
cd ./my_utilities; python setup.py install
```

### Copy over updated ami_utilities package into running docker container for package changes (need restart kernel)
```
docker cp ./my_utilities/. my-ds-notebook:/home/jovyan/my_utilities/
```

### my_utilities, rebuild and copy to docker
```
cd ./ami_utilities; python setup.py install; docker cp ./ami_utilities/. my-ds-notebook:/home/jovyan/my_utilities/
```

### Get back some space from docker
````
docker image prune
docker container prune
```