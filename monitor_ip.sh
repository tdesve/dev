#!/bin/bash
# Récupère l'adresse IP publique du routeur au lancement et envoie un message pour la communiquer
# Ensuite, revérifie régulièrement cette adresse et envoie un message en cas de changement
# Doit etre appelé depuis /etc/rc.local en background :
# monitor_ip&
# Utilise Dyndns pour obtenir l'adresse (sous forme d'une page HTML) puis gawk pour extraire l'adresse IP
# T. Desvé - Janvier 2013 - test

_IP1=`curl -s http://checkip.dyndns.org | gawk ' { gsub(/[[:alpha:]]|[<>\/ :]/,"");print }'`

echo $_IP1 | mail -s "Le Raspberry Pi a rebooté" tdesve@gmail.com


while true
do
	sleep 10m
	_IP2=`curl -s http://checkip.dyndns.org | gawk ' { gsub(/[[:alpha:]]|[<>\/ :]/,"");print }'`

	if [ $_IP1 != ${_IP2:="Connexion/ en cours"} ]
	then
                echo $_IP2 | mail -s "L'adresse du routeur Raspberry Pi a changé" tdesve@gmail.com
		_IP1=$_IP2
  	fi
done

