docker load -i ./images/dbmotion.tar
for name in dbmotion:hcs-oem dbmotion-ui:hcs-oem kafka:hcs-oem phoenix:1.4.7-dbmotion-hcs-oem
do
docker tag "${1}${name}" $name
for ip in 10.10.30.146
do
docker tag $name $ip:30081/irds/$name
docker push  $ip:30081/irds/$name
done
done