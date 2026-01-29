# jan/02/1970 00:02:51 by RouterOS 6.49.13
# software id = Q06M-GSVC
#
# model = RB750Gr3
# serial number = CC210E136A1C
/interface bridge
add admin-mac=2C:C8:1B:5D:ED:07 auto-mac=no comment=defconf name=bridge \
    protocol-mode=none vlan-filtering=yes
/interface ethernet
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] disabled=yes
/interface vlan
add interface=bridge name=vlan10_serveurs vlan-id=10
add interface=bridge name=vlan20_perso vlan-id=20
add interface=bridge name=vlan30_invite vlan-id=30
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \
    supplicant-identity=MikroTik wpa2-pre-shared-key=ChezTJ_2026!
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
add name=dhcp_pool1 ranges=192.168.20.10-192.168.20.254
add name=dhcp_pool2 ranges=192.168.30.2-192.168.30.254
add name=dhcp_pool3 ranges=192.168.10.1-192.168.10.253
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge name=defconf
add address-pool=dhcp_pool1 disabled=no interface=vlan20_perso name=dhcp1
add address-pool=dhcp_pool2 disabled=no interface=vlan30_invite name=dhcp2
add address-pool=dhcp_pool3 disabled=no interface=vlan10_serveurs name=dhcp3
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4 pvid=10
add bridge=bridge comment=defconf interface=ether5 pvid=10
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface bridge vlan
add bridge=bridge tagged=bridge,ether2,ether3 vlan-ids=10
add bridge=bridge tagged=bridge,ether2,ether3 vlan-ids=20
add bridge=bridge tagged=bridge,ether2,ether3 vlan-ids=30
add bridge=bridge vlan-ids=1
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.88.1/24 comment=defconf interface=bridge network=\
    192.168.88.0
add address=192.168.10.1/24 interface=vlan10_serveurs network=192.168.10.0
add address=192.168.20.1/24 interface=vlan20_perso network=192.168.20.0
add address=192.168.30.1/24 interface=vlan30_invite network=192.168.30.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8 gateway=192.168.10.1
add address=192.168.20.0/24 dns-server=8.8.8.8 gateway=192.168.20.1
add address=192.168.30.0/24 dns-server=8.8.8.8 gateway=192.168.30.1
add address=192.168.88.0/24 comment=defconf dns-server=192.168.88.1 gateway=\
    192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 comment=defconf name=router.lan
/ip firewall filter
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment=\
    "defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=drop chain=forward comment="Blocage Invites vers Serveurs" \
    dst-address=192.168.10.0/24 src-address=192.168.30.0/24
add action=drop chain=forward comment="Blocage Invites vers Personnel." \
    dst-address=192.168.20.0/24 src-address=192.168.30.0/24
add action=drop chain=forward comment="Blocage Serveur vers invite" \
    dst-address=192.168.30.0/24 src-address=192.168.10.0/24
add action=drop chain=forward comment="Blocage Personnel vers invite" \
    dst-address=192.168.30.0/24 src-address=192.168.20.0/24
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
/system ntp client
set enabled=yes primary-ntp=162.159.200.1
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
