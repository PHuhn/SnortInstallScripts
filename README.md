# Raspberry PI
## Overview

This repository contains scripts to configure Raspian and Snort project as follows:
- Raspain - one bash scripts for installing and configuring.
  1. RaspianConfig.sh
  2. Python3_x.sh

At the time of creation, RaspianConfig.sh script was designed be executed without any paramenters.  I tried to make the scripts, also work as versions change, so I allowed passing parameters.

### Raspian Configuration

#### RaspianConfig.sh
Configuration as follows:
- change password
- set timezone
- configure bluetooth serial connection
- set keyboard locale
- update the Raspian O/S

```
$ wget https://raw.githubusercontent.com/PHuhn/RaspberryPI/master/RaspianConfig.sh
$ chmod 755 RaspianConfig.sh
$ ./RaspianConfig.sh -h
  Usage: ./RaspianConfig.sh [options]

  -h    this help text.
  -c    country code,  default value: US
  -t    timezone code, default value: michigan

  Example:  ./RaspianConfig.sh -c canada -t eastern

$ ./RaspianConfig.sh
```

### Python 3.x Installation

Download and install updated version of python. Including:

- pip
- gpio
- pyodbc

#### Python3_x.sh

```
$ wget https://raw.githubusercontent.com/PHuhn/RaspberryPI/master/Python3_x.sh
$ chmod 755 Python3_x.sh
$ ./Python3_x.sh -h
  Usage: ./Python3_x.sh [options]

  -h    this help text.
  -p    python version, default value: 3.7.2

  Example:  ./Python3_x.sh -p 3.8.0a2

$ ./Python3_x.sh
```

Good luck, Phil
