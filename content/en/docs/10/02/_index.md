---
title: "10.2 Security scanning"
weight: 12
sectionnumber: 10.2
---

A lot of the container images contains security issues. I you wan't to use images from public registries you should be able to scan them, to verify the image is clean.

There are some tools on the market which can help you to check these images. 

In this lab you will learn how to scann an image with the tool Trivy.


## Scan Image for Vulnerabilities and Secrets

Trivy is as simply as it sounds! you can just point on your image and trivy will do the rest.

When Trivy is running the very first time, it is downloading the latest vulnerbility database from the internet. Without this, Trivy is not able to scan anything. You could also predownload this database and point to it during the runtime if you have this need.

```bash
trivy image quay.io/acend/example-web-python:latest
```

You may have now some outout like this:

```
2022-05-11T11:47:17.787Z        INFO    Need to update DB
2022-05-11T11:47:17.787Z        INFO    DB Repository: ghcr.io/aquasecurity/trivy-db
2022-05-11T11:47:17.787Z        INFO    Downloading DB...
31.76 MiB / 31.76 MiB [------------------------------------------------------------------------------------------------------] 100.00% 10.19 MiB p/s 3.3s
2022-05-11T11:47:26.485Z        INFO    Detected OS: alpine
2022-05-11T11:47:26.485Z        INFO    Detecting Alpine vulnerabilities...
2022-05-11T11:47:26.487Z        INFO    Number of language-specific files: 1
2022-05-11T11:47:26.487Z        INFO    Detecting python-pkg vulnerabilities...

quay.io/acend/example-web-python:latest (alpine 3.15.4)
=======================================================
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)


Python (python-pkg)
===================
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

As you can see we have no issues here (as this text was written). Let's check another image:

```bash
trivy image debian:stable-slim
```

As you can see, the output is now much larger than before. You could use Trivy in pipelines where it can break the build if the image has serious severities like HIGH or CRITICAL. For more information check the `trivy --help` page.

## Scan Filesystem for Vulnerabilities, Secrets and Misconfigurations

You are also able to scan projects locally on disc for several things. This scan check your code for best practises and gives you hints about configurations issues / mistakes which can help you to improve your codebase.

```bash
git clone https://github.com/acend/awesome-apps.git
trivy fs --security-checks vuln,secret,config awesome-apps/
```

```
go/Dockerfile (dockerfile)
==========================
Tests: 23 (SUCCESSES: 23, FAILURES: 0, EXCEPTIONS: 0)
Failures: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)


python/Dockerfile (dockerfile)
==============================
Tests: 23 (SUCCESSES: 23, FAILURES: 0, EXCEPTIONS: 0)
Failures: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

For more informations checkout the [Trivy Github page](https://github.com/aquasecurity/trivy)
