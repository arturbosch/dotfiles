#!/bin/bash
sudo apt update
sudo apt upgrade

## software
sudo apt install zip unzip fish curl wget htop tig snapd

## snaps
sudo snap install core
sudo snap install nextcloud

## reposilite
sudo apt install openjdk-17-jre-headless