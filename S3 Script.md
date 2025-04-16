
## How to setup S3

### 0. Launch S3
Go to AWS console and launch S3 with default settings and a unique name for bucket. Be sure to remove block public access.

### 1. Update Properties of S3
Go to S3 bucket and click on properties. Click on edit Bucket Policy

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```

### 2. Update CORS Policy
Now click on edit CORS policy.

```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "HEAD"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "ETag"
        ],
        "MaxAgeSeconds": 3000
    }
]
```

### 3. Create IAM user for S3
Search IAM and then go to Users on left panel. Click create a user and attach policies directly of S3FullAccess. 
Once created go to that s3User and create Access Key. Download that access key.

Now you have access to your s3 with your credentials

### 4. Important Values to have for .env
```
CDN_BUCKET_NAME=your-bucket-name
CDN_TYPE=aws
CDN_ENDPOINT=s3.us-east-2.amazonaws.com
SERVICE_URL=https://your-bucket-name.s3.us-east-2.amazonaws.com
CDN_KEY=Access-Key
CDN_SECRET=Access-Secret
CDN_REGION=US East (Ohio) us-east-2
```
