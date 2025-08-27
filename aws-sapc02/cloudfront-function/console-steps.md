Go to CloudFront

### Create CloudFront function

Left side menu -> Functions -> Create function

function code

```
function handler(event) {
    var response = {
        statusCode: 200,
        statusDescription: 'OK',
        headers: {
            'content-type': { value: 'text/plain; charset=utf-8' },
        },
        body: 'Hello from CloudFront Function 👋',
    };
    return response;
}

```

Click publish



### Create distribution


Click on the created distribution -> Behaviors tab -> Select default behavior (0) -> Edit -> 

Scroll down to bottom -> Viewer request -> Select 'CloudFront Functions' as Function Type -> Select the CloudFront function 

Wait for deployment

curl d58an524la6th.cloudfront.net  # distribution domain name
