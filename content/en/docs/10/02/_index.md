---
title: "10.2 Security scanning"
weight: 12
sectionnumber: 10.2
---

A lot of the container images contain security issues. If you want to use images from public registries you should be able to scan them to verify the image is clean.

There are some tools on the market which can help you to check these images.

In this lab you will learn how to scan an image with the tool [Trivy](https://trivy.dev/).


## Scan image for vulnerabilities and secrets

Trivy is as simple as it sounds! Just point it to your image and it will do the rest.

When Trivy runs for the very first time, it will download the latest vulnerability database from the internet. Without this, Trivy is not able to scan anything.

{{% alert title="Note" color="primary" %}}
A [pre-download](https://aquasecurity.github.io/trivy/v0.40/docs/advanced/air-gap/) of the database is possible if Trivy has no direct access to the internet.
{{% /alert %}}

Scan an image for vulnerabilities:
```bash
trivy image quay.io/acend/example-web-python:latest
```

Above command will generate output looking similar to this:

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

No issues were detected in this image (at time of writing). So let's check another image:

```bash
trivy image debian:stable-slim
```

As you can see, the output is now much larger than before. You could use Trivy in pipelines where it can break the build if the image has serious severities like HIGH or CRITICAL. For more information check the `trivy --help` page.


## Scan filesystem for vulnerabilities, secrets and misconfigurations

You can also scan projects locally on disc for several things. This scan checks your code for best practices and gives you hints about configurations issues and mistakes which can help you to improve your codebase.

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

For more information, check out the [Trivy Github page](https://github.com/aquasecurity/trivy).
