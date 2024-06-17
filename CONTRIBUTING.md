## Code generation

1. Run below command to update the OpenAPI generated code:
```
openapi-generator generate -i https://api.swaggerhub.com/apis/passage/passage-auth-api/1 -g swift5 --additional-properties=responseAs=AsyncAwait -o Sources/Passage/generated
```

2. Run script to fix known generated code issues:
```
python3 Sources/Passage/fix_generated_code.py
```
