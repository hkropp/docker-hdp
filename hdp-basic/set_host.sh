#!/bin/bash

echo $(head -1 /etc/hosts | cut -f1) n1.hdp >> /etc/hosts
