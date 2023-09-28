		Pour toutes les machines autres que r2, observez les routes définies dans /etc/network/interfaces et vérifiez la cohérence avec les routes affichées par la commande route. Représentez sous la forme d'un tableau les différentes routes des machines (on négligera les routes directes)

r1
*		r2

r3
192.168.1.0/24	r2
192.168.2.0/24	r2
192.168.3.0/24	r5
192.168.5.0/24	r5
192.168.8.0/24	r5
*		10.0.2.15

r4
192.168.1.0/24	r1
192.168.2.0/24	r1
192.168.4.0/24	r5
192.168.5.0/24	r5
*		r5

r5
192.168.1.0/24	r4
192.168.2.0/24	r2
192.168.3.0/24	r4
* 		r3



		Proposez, sous la forme d'un tableau, la table de routage de r2 

r2
192.168.1.0/24	r1(192.168.2.1)-eth0
192.168.3.0/24	r1(192.168.2.1)-eth0
192.168.6.0/24	r1(192.168.4.2)-eth1
192.168.8.0/24	r5(192.168.5.2)-eth2
*		r3(192.168.4.2)



		Modifiez le fichier /etc/network/interfaces de r2 en conséquence et testez 

###
# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 192.168.2.2
        netmask 255.255.255.0
    up route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.2.1
    up route add -net 192.168.3.0 netmask 255.255.255.0 gw 192.168.2.1
 
auto eth1
iface eth1 inet static
        address 192.168.4.1
        netmask 255.255.255.0 
    	gateway 192.168.4.2

auto eth2
iface eth2 inet static
        address 192.168.5.1
        netmask 255.255.255.0
    up route add -net 192.168.8.0 netmask 255.255.255.0 gw 192.168.5.2
###
    
sysctl -w net.ipv4.ip_forward=1 => pour activer routage sur la machine




		La table de routage de r4 peut-être simplifiée ! proposez un nouveau tableau des routes de r4 et testez cette nouvelle configuration. Le script ping-all doit toujours fonctionner ! 

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 192.168.3.2
        netmask 255.255.255.0
    up route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.3.1
    up route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.3.1

auto eth1
iface eth1 inet static
        address 192.168.8.1
        netmask 255.255.255.0
    gateway 192.168.8.2
    


	Le routeur r2 vient de subir une attaque et a peut-être été compromis ! Éteignez le (Graph → clic droit → Halt) en attendant son audit par l'équipe de sécurité, proposez une stratégie de modification des routes pour assurer l'interconnexion de toutes les machines.
	
r1
192.168.5.0/24	r4(192.168.3.2)-eth2
192.168.7.0/24	r4(192.168.3.2)-eth2
192.168.8.0/24	r4(192.168.3.2)-eth2
*		r4

r3
192.168.1.0/24	r5(192.168.7.2)-eth2
192.168.2.0/24	r5(192.168.7.2)-eth2
192.168.3.0/24	r5(192.168.7.2)-eth2
192.168.5.0/24	r5(192.168.7.2)-eth2
192.168.8.0/24	r5(192.168.7.2)-eth2
*		10.0.2.15

r4
192.168.1.0/24	r1(192.168.3.1)-eth0
192.168.2.0/24	r1(192.168.3.1)-eth0
192.168.4.0/24	r5(192.168.8.2)-eth1
192.168.5.0/24	r5(192.168.8.2)-eth1
*		r5(192.168.8.2)-eth1

r5

192.168.1.0/24	r4(192.168.8.1)-eth0
192.168.2.0/24	r4(192.168.8.1)-eth0
192.168.3.0/24	r4(192.168.8.1)-eth0
* 		r3(192.168.7.1)-eth2


#---------------------------------------
R1

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 192.168.1.1
        netmask 255.255.255.0

auto eth1
iface eth1 inet static
        address 192.168.2.1
        netmask 255.255.255.0

auto eth2
iface eth2 inet static
        address 192.168.3.1
        netmask 255.255.255.0
	gateway 192.168.3.2

#---------------------------------------
R3

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 192.168.6.1
        netmask 255.255.255.0

auto eth1
iface eth1 inet static
        address 192.168.4.2
        netmask 255.255.255.0

auto eth2
iface eth2 inet static
        address 192.168.7.1
        netmask 255.255.255.0
    up route add -net 192.168.8.0 netmask 255.255.255.0 gw 192.168.7.2
    up route add -net 192.168.3.0 netmask 255.255.255.0 gw 192.168.7.2
    up route add -net 192.168.5.0 netmask 255.255.255.0 gw 192.168.7.2
    up route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.7.2
    up route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.7.2

#---------------------------------------
R4

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 192.168.3.2
        netmask 255.255.255.0
    up route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.3.1
    up route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.3.1

auto eth1
iface eth1 inet static
        address 192.168.8.1
        netmask 255.255.255.0
    gateway 192.168.8.2

#---------------------------------------
R5

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.8.2
    netmask 255.255.255.0
    up route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.8.1
    up route add -net 192.168.3.0 netmask 255.255.255.0 gw 192.168.8.1
    up route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.8.1

auto eth1
iface eth1 inet static
    address 192.168.5.2
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.168.7.2
    netmask 255.255.255.0
    gateway 192.168.7.1


#-------------------------------------------------------------------------------
Routage Dynamique
#-------------------------------------------------------------------------------
ospfd.conf de R2
 
echo -n "!/etc/quagga/zebra.conf \n
hostname router-zebra \n
password zebraiut* \n
log file /var/log/quagga/zebra.log \n" > /etc/quagga/zebra.conf 



echo "!/etc/quagga/ospfd.conf
hostname router-ospfd
password ospfdiut*
log file /var/log/quagga/ospfd.log"> /etc/quagga/ospfd.conf 

#---------------------------------------
Faire 
`telnet localhost 2601`
`telnet localhost 2604`
#---------------------------------------

echo "
interface eth0
 ip ospf hello-interval 5
 ip ospf dead-interval 20
interface eth1
 ip ospf hello-interval 5
 ip ospf dead-interval 20
interface eth2
 ip ospf hello-interval 5
 ip ospf dead-interval 20


router ospf
ospf router-id 1.1.1.2
network 192.168.2.0/24 area 0
network 192.168.4.0/24 area 0
network 192.168.5.0/24 area 0" >> /etc/quagga/ospfd.conf 

#---------------------------------------
systemctl restart ospfd
systemctl restart networking
 // ou restart totalement

#---------------------------------------
Quelle route est maintenant empruntée par un paquet allant de s1 à s2 ?
r1 -> r4 -> r5 -> r3 -> s2