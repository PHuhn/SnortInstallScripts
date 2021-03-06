#!/bin/bash
#
# ----------------------------------------------------------------------------
# Install Nagios NRDP on a Raspberry PI running raspian
#  Written by: Phil Huhn
#
# NRDP - Installing NRDP From Source
# https://support.nagios.com/kb/article/nrdp-installing-nrdp-from-source-602.html#Raspbian
#
# program values:
PROGNAME=$(basename "$0")
REVISION="1.0.8"
NRDP_DIR=/usr/local/nrdp
SRC_DIR=/usr/local/src
# Options variables:
NRDP_VER=2.0.2
FORCE=false
COUNT=8
function displayHelp {
    cat <<EOF

  Usage: ${PROGNAME} [options]

  -h    this help text.
  -c    number to tokens to create, default value: ${COUNT}
  -n    nagios nrdp version, default value: ${NRDP_VER}
  -f    force installation,  default value: ${FORCE}
  
  Example:  ${PROGNAME} -n 1.5.2

EOF
}
#
if [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
  displayHelp
  exit
fi
#
echo "=- Running ${PROGNAME} ${REVISION} -="
date
#
while getopts ":c:n:f:" option
do
  case "${option}"
  in
    c) COUNT=${OPTARG}
      [[ ${COUNT} == ?(-)+([0-9]) ]]
      if [ $? == 1 ]; then
        displayHelp
        echo -e "\nCount: ${COUNT} must be numeric.\n"
        exit
      fi
      ;;
    n) NRDP_VER=${OPTARG};;
    f) FORCE=$(echo "${OPTARG}" | tr '[:upper:]' '[:lower:]');;
    *) echo "Invalid option: ${option}  arg: ${OPTARG}"
      exit 1
      ;;
  esac
done
# check for previous installation of nrdp
if [ -d "${NRDP_DIR}" ] || [ -f /etc/apache2/sites-enabled/nrdp.conf ]; then
  if [ "X${FORCE}" != "Xtrue" ]; then
    echo "${LINENO} ${PROGNAME}, NRDP already installed, maybe use the force option."
    exit 1
  fi
fi
# addon source directory
if [ ! -d "${SRC_DIR}" ]; then
  mkdir -p "${SRC_DIR}"
fi
if [ ! -d "${SRC_DIR}" ]; then
  echo "${LINENO} ${PROGNAME}, failed to create src dir."
  exit 1
fi
cd "${SRC_DIR}" || exit 2
#
wget -O "nrdp-${NRDP_VER}.tar.gz" "https://github.com/NagiosEnterprises/nrdp/archive/${NRDP_VER}.tar.gz"
tar xvf "nrdp-${NRDP_VER}.tar.gz"
#
if [ -d "${SRC_DIR}/nrdp-${NRDP_VER}" ]; then
  cd "${SRC_DIR}/nrdp-${NRDP_VER}" || exit 3
  mkdir -p "${NRDP_DIR}"
  if [ -d "${NRDP_DIR}" ]; then
    apt-get update
    apt-get install -y php-xml
    cp -r clients server LICENSE* CHANGES* "${NRDP_DIR}"
    chown -R nagios:nagios "${NRDP_DIR}"
    cp nrdp.conf /etc/apache2/sites-enabled/.
    systemctl restart apache2.service
    # generate 8 random 64 byte tokens with python secrets
    which python3.7 > /dev/null
    if [ $? == 0 ]; then
      python3 << _EOF >> token.txt
import secrets as Secrets
for i in range(0, ${COUNT}):
    print('    "{0}",'.format(Secrets.token_urlsafe(64)))
_EOF
    else
      # these are farely random values, but % bad for DOS, $ bad for UNIX, ! (history) causes 'event not found'
      wget -O token.txt https://api.wordpress.org/secret-key/1.1/salt/
      sed -E -e "s/define\(.................../   /" -e "s/([$%\`\!\])/=/g" -e "s/'/\"/g" -e "s/..$/,/" -i token.txt
    fi
    # edit the nrdp config file by finding the 2 fake tokens and delete them,
    # then read in the token.txt at that point, write and quit
    ed "${NRDP_DIR}/server/config.inc.php" <<EOF
/mysecrettoken/
.,+1d
.-1r token.txt
w
q
EOF
    echo ""
    echo "=- * suggested tokens for config.inc.php * -="
    cat token.txt
    #
    echo "${NRDP_DIR}/server/config.inc.php should now contain the above suggested tokens..."
    echo "You can remove them, or add additional tokens."
    echo "also edit /etc/apache2/sites-enabled/nrdp.conf to verify desired configuration."
    #
    rm token.txt
    rm "${SRC_DIR}/nrdp-${NRDP_VER}.tar.gz"
  else
    echo "${LINENO} ${PROGNAME}, install of nrdp failed, no ${NRDP_DIR} directory."
  fi
  #
else
  echo "${LINENO} ${PROGNAME}, install of nrdp failed, no nrdp-${NRDP_VER} directory."
fi
#
date
echo "=- End of install of NRDP on Raspberry PI -="
#
