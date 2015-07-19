boot2docker init --memory=8192 --cpus=8

 docker build -t hkropp/hdp-basic .

docker build -c 8 -t hkropp/hdp-basic .

docker run -d -p 8080:8080 -h n1.hdp hkropp/hdp-basic /start-server 
