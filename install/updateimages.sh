for name in dbmotion:2310-hcs-oem dbmotion-ui:2310-hcs-oem kafka:hcs-oem phoenix:1.4.7-dbmotion-hcs-oem
do
docker pull "${1}${name}"
docker tag "${1}${name}" $name
docker push $name
for ip in 10.10.30.146
do
docker tag $name $ip:30081/irds/$name
docker push  $ip:30081/irds/$name
done
done