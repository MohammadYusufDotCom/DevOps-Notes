
# Step 1: Define a custom log format
nginx.conf
```
log_format ratelimited '$remote_addr - $http_x_api_key [$time_local] '
                       '"$request" $status $body_bytes_sent '
                       '"$http_referer" "$http_user_agent"';
```

# Step 2: Add conditional logging

```
access_log /var/log/nginx/access.log;

# This will log only 429 responses into a separate file
if ($status = 429) {
    access_log /var/log/nginx/ratelimited.log ratelimited;
}
```
# 3. Send a Friendly JSON Error Message for Rate-Limited Responses

```
error_page 429 = @rate_limited;
location @rate_limited {
    default_type application/json;
    return 429 '{"error":"Rate limit exceeded. Please try again later."}';
}
```

#4 Exceptions / Special Cases
```
location /health {
    limit_req off;
    proxy_pass http://health_service;
}
```



