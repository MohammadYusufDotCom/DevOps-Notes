### Step 1: Create a Role with Delete Privileges for security index

You can create a role that has the delete privilege for security indices. Use the following command:
```
curl -X POST --insecure -H "Content-Type: application/json" -u elastic:your_password "https://localhost:9200/_security/role/delete_security_index_role" -d '{
  "cluster": ["all"],
  "indices": [
    {
      "names": [".security-*"],
      "privileges": ["delete_index", "manage","all"],
      "allow_restricted_indices": true
    }
  ]
}'
```
#### Note: 
- if we want to delete security index then it is mendoroty to mention `"allow_restricted_indices": true`.
- it not mandatory to mention `"all"` in the privileges section.

## Step 2: Create a User and Assign the Role
Next, create a user and assign the role you just created. Use the following command:
```
curl -X POST -H "Content-Type: application/json" -u elastic:your_password "https://localhost:9200/_security/user/my_secure_user" -d '{
  "password": "your_user_password",
  "roles": ["delete_security_index_role"]
}'
```
### Important:
- You can retrieve the role details with this command:
  ```
  curl -X GET -u elastic:your_password "https://localhost:9200/_security/role/delete_security_index_role"
  ```
- Sometimes, additional security settings or index lifecycle management policies can prevent the deletion of indices. Check for:
  - Index Settings: Verify if the index has settings that prevent deletion.
  - Read-only Index: Make sure the index isn’t set to read-only mode.
  - You can check the settings of the index using:
  ```
  curl -X GET -u my_secure_user:your_user_password "https://localhost:9200/.security-7/_settings"
  ```
## Example Deletion Command
Ensure you're using the following command correctly to delete the index (replace .security-7 with the actual index name):
```
curl -X DELETE -u my_secure_user:your_user_password "https://localhost:9200/.security-7"
```
### List index and All Shards
To list all indices in your Elasticsearch cluster, you can use the following curl command:
```t
#for listing index
curl -X GET -u elastic:your_password "https://localhost:9200/_cat/indices?v" --insecure

# for deleting the desired indices
curl -X DELETE -u elasticsearch:your_password "https://localhost:9200/<indices name that you want to delete> -K"

#for list the shards
curl -X GET -u elastic:your_password "https://localhost:9200/_cat/shards?v" --insecure

#View Shards for a Specific Index: If you want to see shards for a specific index.

curl -X GET -u elastic:your_password "https://localhost:9200/_cat/shards/my_index_name?v"

```
