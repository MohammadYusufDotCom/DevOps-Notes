```
import axios from 'axios'


const SUCCESS_RESPONSE_CODE = 20000;
const AUTH_SERVICE_URL = '<APIGATEWAY URL FOR AUTH SERVICE>';
const REQUEST_FORWARDER_ARN = '<ARN>';
const error_response = {
  "message": "Something went wrong !!",
  "responseCode": "5000",
  "status": "Failure",
  "data": null
}

export const handler = async (event) => {
  const headers = event.headers || {};
  try {

    // Step 1: Call the authentication service
    const authResponse = await axios({
      method: 'post',
      url: AUTH_SERVICE_URL,
      headers: fetchHeaders(headers),
      data: {}
    });
    const data = JSON.stringify(authResponse.data)
    // Step 2: Check if the authentication service returns 20000
    if (authResponse?.data?.responseCode === SUCCESS_RESPONSE_CODE) {
      // Return an "Allow" policy if authentication succeeds
      return generatePolicy('user', 'Allow', event.methodArn, data);
    }
    else {
      // Return a "Deny" policy if authentication fails
      return generatePolicy('user', 'Deny', event.methodArn, data);
    }
  }
  catch (error) {
    // If an error occurs, deny access
    return generatePolicy('user', 'Deny', event.methodArn, JSON.stringify(error_response));
  }
};


const generatePolicy = (principalId, effect, resource, response) => {
  var authResponse = {};
  authResponse.principalId = principalId;
  const policyDocument = {
    Version: '2012-10-17',
    Statement: [{
      Action: 'execute-api:Invoke',
      Effect: effect,
      Resource: resource,
    }],
  };
  authResponse.policyDocument = policyDocument;

  authResponse.context = {
    "custom_response": response
  };
  return authResponse;
};


function convertKeysToLowercase(obj = {}) {
  const newObj = {};

  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      newObj[key.toLowerCase()] = obj[key];
    }
  }

  return newObj;
}


const fetchHeaders = (orginalHeaders = {}) => {
  orginalHeaders = convertKeysToLowercase(orginalHeaders);
  return {
    "Accept": "application/json",
    "appLanguage": orginalHeaders.applanguage,
    "appName": orginalHeaders.appname,
    "appVersion": orginalHeaders.appversion,
    "appVersionCode": orginalHeaders.appversioncode,
    "channel": orginalHeaders.channel,
    "checksum": orginalHeaders.checksum,
    "client": orginalHeaders.client,
    "deviceId": orginalHeaders.deviceid,
    "deviceManufacturer": orginalHeaders.devicemanufacturer,
    "deviceName": orginalHeaders.devicename,
    "deviceType": orginalHeaders.devicetype,
    "mmReqIdentifier": orginalHeaders.mmreqidentifier,
    "OSFIRMWAREBUILD": orginalHeaders.osfirmwarebuild,
    "OSMODELNAME": orginalHeaders.osmodelname,
    "OSNAME": orginalHeaders.osname,
    "OSPRODUCTNAME": orginalHeaders.osproductname,
    "OSVERSION": orginalHeaders.osversion,
    "userType": orginalHeaders.usertype,
    "api-key": orginalHeaders["api-key"],
    "Authorization": orginalHeaders.authorization,
    "subscriberId": orginalHeaders.subscriberid
  }
}
```
