Create a lambda function in us-east-1

vi index.mjs

```
// index.mjs or index.js
export const handler = async (event) => {
  return {
    status: '200',
    statusDescription: 'OK',
    headers: {
      'content-type': [{ key: 'Content-Type', value: 'text/plain; charset=utf-8' }],
      'cache-control': [{ key: 'Cache-Control', value: 'no-store' }],
    },
    body: 'Hello from Lambda@Edge 👋',
  };
};
```

publish the lambda function. Note the ARN.

Create a cloudfront distribution

Origin: Any s3 bucket

After creation of cloudfront

Click Behavior tab -> Create behavior -> Scroll down to Function Associations

Function type: Lambda@Edge
Function ARN: e.g. arn:aws:lambda:us-east-1:627073650332:function:helloWorld123:2 (Must have version number appended at the end)

Click Create behavior

After deployment, access the function through distribution domain name. e.g. d1iddpypwxmd7c.cloudfront.net


