## How to change multiple file name at onces?

#### Step 1: Run down below script 
```
for file in *.jenkins; do mv "$file" "${file%.jenkins}.jenkinsfile"; done
```
By running this command you can change extension of multiple files at onces.
