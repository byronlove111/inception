#!/bin/sh

cp -r secrets.example secrets
cp srcs/.env.example srcs/.env

echo "127.0.0.1 abbouras.42.fr" | sudo tee -a /etc/hosts > /dev/null

echo "Done. Fill in secrets/ and srcs/.env, then run make."
