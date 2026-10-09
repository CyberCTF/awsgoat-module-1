# AWSGoat: module 1

[AWSGoat](https://github.com/ine-labs/AWSGoat) by INE: a damn vulnerable AWS infrastructure. This
repository runs its module 1 with [Isoloom](https://www.isoloom.com) in your own AWS account:
[`isoloom.yml`](isoloom.yml) describes the cloud services, and AWSGoat sits unchanged in
[`app/`](app) (the Terraform root is `app/modules/module-1/`).

| Cloud services | What |
| --- | --- |
| API Gateway, Lambda, DynamoDB, S3 | The serverless blog application and its data |
| EC2, VPC | A t2.micro instance with an instance profile |
| IAM | Roles and policies with privilege escalation paths |

Cost while it runs: about $0.03 an hour (the EC2 instance and its public IPv4 address; the rest
is billed per request).

## Run it

Use an AWS account with nothing else in it, signed in with the AWS CLI (`aws login`), Terraform
and `python3` with `boto3` installed. Upstream's deploy steps call GNU `sed -i`: run it on Linux,
or on macOS with GNU sed first in your `PATH`.

```bash
isoloom run cloud-services     # about 2 minutes; prints the blog's URL
isoloom test cloud-services
isoloom down cloud-services
```

Upstream's EC2 instance is a t2.micro: an account on the AWS Free plan refuses it (only
Free-Tier-eligible types such as t3.micro), so use an account on a paid plan.

After `down`, the Lambda functions' log groups (`/aws/lambda/blog-application`,
`/aws/lambda/blog-application-data`) remain: AWS made them, not Terraform. Delete them with
`aws logs delete-log-group --log-group-name <name>`.

Lab guide: [`app/attack-manuals/module-1/`](app/attack-manuals/module-1).

Upstream version and commit: [UPSTREAM.md](UPSTREAM.md).

## Licence

MIT, as AWSGoat ([LICENSE](LICENSE)). This lab is deliberately vulnerable: deploy it only in an
account you use for nothing else, and destroy it when you are done.
