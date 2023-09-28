#!/bin/bash


#Lancer le script suivi du port voulu => ./script.sh 2021
#Sur navigateur => http://localhost:2021/index.html -> ici port 2021, doit mettre meme apres nom script


E403=0
E404=0
E501=0

if [ "$1" != "--script" ]; then
	socat TCP-LISTEN:$1,reuseaddr,fork EXEC:"$0 --script"
fi
while [ "$1" = "--script" ]; do
	read request #lit requette http
	get=$(echo $request | cut -d ' ' -f 1) #methode requette
	file=$(echo $request | cut -d ' ' -f 2) #chemin fich demandé
	file="www-test$file" #ajoute www-test au début du chemin du fich demandé
	if [ $get != "GET" ]; then
		echo "ERREUR 501 : GET !"
		exit 1
	else
		E501=1
	fi
	if [ -f $file ]; then #si file existe
		E404=1
	else 
		echo "ERREUR 404 : File not found !"
		exit 2
	fi
	if [ -r $file ]; then #verif si lisible
		E403=1
	else 
		echo "ERREUR 403 : Forbidden !"
		exit 3
	fi
	if [ $E501 -eq 1 ] && [ $E404 -eq 1 ] && [ $E403 -eq 1 ]; then

	mime=$(file -L --brief --mime-type $file)
		echo -e "HTTP/1.1 200 OK"
		echo -e "Content-Length: $(wc -c < $file)"
		echo -e "Content-Type: $mime"
		echo -e ""
		cat $file
	fi
done
