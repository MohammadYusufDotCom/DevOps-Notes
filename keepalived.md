# This is for master

```t
global_defs {
   notification_email {
     prashant1.kumar@paytm.com
   }
   notification_email_from deployment.infra@paytm.com
   smtp_server smtppaytm.pepipost.com
   smtp_connect_timeout 60
}

vrrp_instance RH_1 {
    state MASTER                    ## role of this server 
    interface enp1s0                ## NCI name on which it is connected
    virtual_router_id 50            ## Id that used for join other system (must be same across all the node)
    priority 99                     ## the higher the prioprity the more chance to get selected for master ROLE if
    advert_int 1                    ## check intervel secondes for for master and and worked if master goes down OR comes up
    unicast_src_ip 172.16.210.59    # IP address of Master Server
    unicast_peer {
    172.16.210.58                   # IP address of Slave Server
    }

    virtual_ipaddress {
        172.16.210.57/24 dev enp1s0 ## VIP that assigned
    }
}
```
