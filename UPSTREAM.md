# Upstream

| | |
| --- | --- |
| Project | AWSGoat |
| Repository | https://github.com/ine-labs/AWSGoat |
| Version | master (no releases) |
| Commit | b24869ad455ed8d1393d00ecdc15ee638d1c1332 |
| Licence | MIT |

`app/` is that commit, unchanged, without its Git history (the whole AWSGoat repository; this lab
applies its Terraform root module `app/modules/module-1/` directly, as upstream's GitHub Actions
workflow does). Upstream's deploy steps (`local-exec`) write into that folder while they run: they
fill placeholders (bucket name, API URL, EC2 address) in files under `resources/` with `sed -i`,
seed DynamoDB with `python3` and boto3, and put Lambda archives in `resources/lambda/out/`.
`git checkout -- app && git clean -fd app` restores the pristine copy. To update, replace `app/`
with a newer commit and change this table.
