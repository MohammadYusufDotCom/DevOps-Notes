# Vault Notes Important and commands

*To create new secret engine:*
```
 vault secrets enable -path=mfs-nagad kv
```

*To check how many secret engine are there:*
```
vault secrets list
```

*to check how many pilicy are there:*
```
vault policy list
```
*we can write policy using CLI:*
```
valut policy write <my-policy-name> - << EOF 
```

*we can read the poilicy:*
```
vault policy read <my-policy-name>
```

*we can delete policy:*
```
vault policy delete <my-policy-name>
```
*how to create a token for a policy:*
```t
# by default this token is for 1 year
export VAULT-TOKEN="$(vault token create -field token --policy=<my-policy>)"

# To create token with 2 years of period
vault token create -field=token -policy=lla-dev -ttl=8760h -max-ttl=17520h
```

*how to start vault in production:*
```
/user/bin/vault server -config=/etc/vault.d/vault.hcl
```

*initilize vault*
```t
# Default this will give five unseal keys
vault oprator init

# if you want to specify keys
vault operator init -key-shares=5 -key-threshold=3
```

*vault create token gives you root tocken to login:*
```
vault create token
```
*how to login into vault:*
```
vault login

vault status
```
*how to delete token:*
```
vault token revoke <my-generated-token>
```

vault kv get -mount=secret creds

*to unseal the vault:*
```
vault operator unseal <unseal-token>
```

*this will provide you to enabled auth type (generally token):*
```vault auth list```

*to create new auth method:*
```
vault auth enable github
```
