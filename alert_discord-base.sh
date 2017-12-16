#!/bin/bash
# LinuxGSM alert_discord.sh function
# Author: Daniel Gibbs
# Contributor: faflfama
# Website: https://gameservermanagers.com
# Description: Sends Discord alert.

# your webhook
discordwebhook=""

avatar="https://image.freepik.com/vector-gratis/fondo-pixelador-de-game-over_1051-1014.jpg"

if [ "$1" == "start" ]
then
	titre="ARK Start"
	alertMessage="Le serveur est en cour de démarrage!"
	state="En cour"
	icon="http://wfarm4.dataknet.com/static/resources/icons/set58/8daa4286.png"
elif [ "$1" == "stop" ]
then
        titre="ARK Stop"
        alertMessage="Le serveur est maintenant étein..."
        state="Indisponible"
        icon="http://iconshow.me/media/images/Mixed/small-n-flat-icon/png2/512/-sign-ban.png"
elif [ "$1" == "update" ]
then
        titre="ARK Update"
        alertMessage="Le serveur est cour de mise a jour!!!"
        state="En mise à jour"
        icon="https://vignette.wikia.nocookie.net/scream-queens/images/8/88/Update-icon.png"
elif [ "$1" == "restart" ]
then
        titre="ARK restart"
        alertMessage="Le serveur est en cour de redémarrage"
        state="En redémarrage"
        icon="https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Antu_appointment-recurring.svg/2000px-Antu_appointment-recurring.svg.png"
fi

json=$(cat <<EOF
{
"username":"Gamming Shit OverPower",
"avatar_url":"${avatar}",
"file":"content",

"embeds": [{
        "color": "2067276",
        "author": {"name": "${titre}"},
        "title": "",
        "description": "",
        "url": "",
        "type": "content",
        "thumbnail": {"url": "${icon}"},
        "fields": [
                        {
                                "name": "Message d'alert",
                                "value": "${alertMessage}"
                        },
                        {
                                "name": "Nom du server",
                                "value": "The ARK : Gamming Shit"
                        },
                        {
                                "name": "Server IP",
                                "value": "[yourip:7777](https://www.gametracker.com/server_info/yourip:7777)"
                        },
                        {
                                "name": "État du server",
                                "value": "${state}"
                        }
                ]
        }]
}
EOF
)

echo "Sending Discord alert"
sleep 0.5
discordsend=$(curl -sSL -H "Content-Type: application/json" -X POST -d """${json}""" ${discordwebhook})

if [ -n "${discordsend}" ]; then
	echo "Sending Discord alert: ${discordsend}"
else
	echo "Sending Discord alert not work"
fi
