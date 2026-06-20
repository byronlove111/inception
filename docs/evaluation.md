# Inception — Evaluation Scale

> You should evaluate **1 student** in this team.

---

## Introduction

Please comply with the following rules:

- Remain **polite, courteous, respectful and constructive** throughout the evaluation process. The well-being of the community depends on it.
- Identify with the student or group the possible dysfunctions in their project. Take the time to discuss and debate the problems that may have been identified.
- Consider that there might be some differences in how your peers understood the project's instructions and the scope of its functionalities. Always keep an open mind and grade as honestly as possible.

---

## Guidelines

- Only grade the work that was turned in the **Git repository** of the evaluated student or group.
- Double-check that the Git repository belongs to the student(s). Ensure that the project is the one expected. Check that `git clone` is used in an empty folder.
- Check carefully that no malicious aliases were used to fool you.
- Review together any scripts used to facilitate the grading.
- If you have not completed the assignment you are going to evaluate, read the entire subject prior to starting.
- Use the available flags to report an empty repository, a non-functioning program, a Norm error, cheating, etc.
  - In these cases, the evaluation process ends and the final grade is **0** (or **-42** in case of cheating).

---

## Preliminaries

> If cheating is suspected, the evaluation stops here. Use the **"Cheat"** flag to report it. Take this decision calmly, wisely, and with caution.

### Preliminary Tests

- Any credentials, API keys, and environment variables must be set inside a `.env` file during the evaluation. If any credentials or API keys are found in the git repository outside of the `.env` file, **the evaluation stops and the mark is 0**.
- Defense can only happen if the **evaluated student or group is present**.
- If no work has been submitted (or wrong files, wrong directory, or wrong filenames), the grade is **0** and the evaluation process ends.
- For this project, you have to **clone their Git repository on their station**.

---

## General Instructions

> For the entire evaluation process, if you don't know how to check a requirement, the evaluated student has to help you.

- Ensure that all required configuration files are inside a `srcs` folder at the root of the repository.
- Ensure that a `Makefile` is located at the root of the repository.
- Before starting the evaluation, run this command:

```bash
docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null
```

- Read `docker-compose.yml`:
  - There must **not** be `network: host` or `links:` → otherwise evaluation ends.
  - There **must** be `network(s)` → otherwise evaluation ends.
- Examine the Makefile and all scripts:
  - There must **not** be `--link` anywhere → otherwise evaluation ends.
- Examine the Dockerfiles:
  - If you see `tail -f` or any background command in the `ENTRYPOINT` section → evaluation ends.
  - If `bash` or `sh` are used but not to run a script → evaluation ends.
  - If the entrypoint is a script, ensure it runs **no program in background**.
- Examine all scripts — ensure **none of them runs an infinite loop** (e.g., `sleep infinity`, `tail -f /dev/null`, `tail -f /dev/random`).
- **Run the Makefile.**

---

## Mandatory Part

### Project Overview

The evaluated person must explain in simple terms:

- How **Docker** and **docker compose** work.
- The difference between a Docker image used **with** docker compose and **without**.
- The benefit of Docker compared to **VMs**.
- The pertinence of the **directory structure** required for this project.

---

### Simple Setup

- Ensure that NGINX can be accessed by **port 443 only**.
- Ensure that a **SSL/TLS certificate** is used.
- Ensure that the **WordPress website** is properly installed and configured (the WordPress Installation page should not appear).
- Access `https://login.42.fr` in your browser (replace `login` with the student's login).
- Verify you **cannot** access the site via `http://login.42.fr`.

> If something doesn't work as expected, the evaluation process ends now.

---

### Docker Basics

- Check the Dockerfiles. There must be **one Dockerfile per service**. Dockerfiles must not be empty.
- Ensure the student has written their **own Dockerfiles** and built their own Docker images. Using ready-made images or DockerHub is **forbidden**.
- Ensure every container is built from the **penultimate stable version of Alpine/Debian**.
  - Each `Dockerfile` must start with `FROM alpine:X.X.X` or `FROM debian:XXXXX` (or another local image).
- Docker images must have the **same name as their corresponding service**.
- Ensure the Makefile has set up all services via **docker compose** without crashes.

> If any of the above points is not correct, the evaluation process ends now.

---

### Docker Network

- Ensure **docker-network** is used by checking `docker-compose.yml`.
- Run `docker network ls` to verify that a network is visible.
- The evaluated student must give a simple explanation of **docker-network**.

> If any of the above points is not correct, the evaluation process ends now.

---

### NGINX with SSL/TLS

- Ensure there is a `Dockerfile`.
- Using `docker compose ps`, ensure the container was created.
- Try to access the service via **http (port 80)** and verify you **cannot** connect.
- Open `https://login.42.fr/` — the displayed page must be the configured WordPress website.
- The use of a **TLSv1.2/v1.3 certificate** is mandatory and must be demonstrated.
  - A self-signed certificate warning may appear — this is acceptable.

> If any of the above points is not clearly explained and correct, the evaluation process ends now.

---

### WordPress with php-fpm and its Volume

- Ensure there is a `Dockerfile`.
- Ensure there is **no NGINX** in the Dockerfile.
- Using `docker compose ps`, ensure the container was created.
- Ensure there is a **Volume**:
  - Run `docker volume ls` then `docker volume inspect <volume name>`.
  - Verify the output contains the path `/home/login/data/`.
- Ensure you can add a **comment** using the available WordPress user.
- Sign in with the **administrator account** to access the Administration dashboard.
  - The Admin username must **not** include `admin` or `Admin`.
- From the Administration dashboard, **edit a page** and verify the change is visible on the website.

> If any of the above points is not correct, the evaluation process ends now.

---

### MariaDB and its Volume

- Ensure there is a `Dockerfile`.
- Ensure there is **no NGINX** in the Dockerfile.
- Using `docker compose ps`, ensure the container was created.
- Ensure there is a **Volume**:
  - Run `docker volume ls` then `docker volume inspect <volume name>`.
  - Verify the output contains the path `/home/login/data/`.
- The evaluated student must explain how to **login into the database**. Verify the database is **not empty**.

> If any of the above points is not correct, the evaluation process ends now.

---

### Persistence

- **Reboot the virtual machine.**
- Once restarted, launch docker compose again.
- Verify that everything is functional, and that both **WordPress and MariaDB** are configured.
- The changes made previously to the WordPress website should **still be present**.

> If any of the above points is not correct, the evaluation process ends now.

---

## Bonus

> Evaluate the bonus part **only if** the mandatory part has been entirely and perfectly done.
> If all mandatory points were not passed, bonus points must be **totally ignored**.

### Bonus Checklist

- Add **1 point per bonus** authorized in the subject.
- Verify and test the proper functioning and implementation of each extra service.
- For the **free choice service**, the evaluated student must give a simple explanation of how it works and why they think it is useful.

**Rate from 0 (failed) to 5 (excellent).**

---

## Ratings

> Don't forget to check the flag corresponding to the defense.

---

## Conclusion

*(End of evaluation scale.)*
