## There are some reservation in Ipv4 for public and private
  * There 5 classes in IPV4
    ```
    A       0-127     arge networks, 8 bits for network, 24 for hosts
    B      128-191    Medium-sized networks, 16 bits for network, 16 for hosts
    C      192-223    Small networks, 24 bits for network, 8 for hosts
    D      224-239    Reserved for multicasting
    E      240-255    Reserved for experimental purposes
    
    Reservations for IP
    Private IPv4 addresses = END User
    10.0.0.0/8 = 10.0.0.1 = 10.255.255.254 (NID=10.0.0.0, BID=10.255.255.255) SM = 255.0.0.0 = Class A => 16581375
    172.16.0.0/12 = 172.16.0.0 – 172.31.255.255 = 255.240.0.0  = Class B = 910350
    192.168.0.0/16 = 192.168.0.0 – 192.168.255.255 = Class C = 65025 SM=255.255.0.0
    
    Public IPv4 addresses = ISP
    1.0.0.0 -> 9.255.255.255 =Public
    11.0.0.0 -> 172.15.255.255 = Public
    172.32.255.255 -> 192.167.255.255 = Public
    192.169.0.0 -> 255.255.255.255 =Public
    
    Reservations for Ports
    Well-Known Ports = 0-1023
    Registered ports = 1024-49151
    Dynamic, private or ephemeral ports = 49152–65535

    ```
