for name in dbmotion:2310-hcs-oem dbmotion-ui:2310-hcs-oem kafka:hcs-oem
do
docker pull "${1}${name}"
docker tag "${1}${name}" $name
docker push $name
for ip in 10.10.66.25 10.10.66.26 10.10.66.27;
do
docker tag $name $ip:30081/irds/$name
docker push  $ip:30081/irds/$name
done
done