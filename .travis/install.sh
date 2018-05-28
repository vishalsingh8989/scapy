# Detect the pip version
PIP=`which pip || (python --version 2>&1 | grep -q 'Python 2' && which pip2) || (python --version 2>&1 | grep -q 'Python 3' && which pip3)`

# Install Python3 on osx
if [ "$TRAVIS_OS_NAME" = "osx" ] && ! python3
then
  brew upgrade python
  pip3 install tox
  if [ ! -z $SCAPY_USE_PCAPDNET ]
  then
    brew update
    brew install libdnet libpcap
  fi
  exit 0
fi

# Install wireshark data
if [ "$TRAVIS_OS_NAME" = "linux" ] && [ "$TRAVIS_SUDO" = "true" ]
then
  sudo apt-get install ppa-purge
  sudo apt-get install aptitude
  sudo aptitude clean
  sudo ppa-purge ppa:dreibh/ppa
  sudo aptitude remove tshark
  sudo apt-add-repository ppa:dreibh/ppa
  sudo aptitude install wireshark

  #sudo apt-get -qyf install tshark
  sudo apt-get -qy install can-utils build-essential linux-headers-$(uname -r);
fi

# Install pcap & dnet
if [ ! -z $SCAPY_USE_PCAPDNET ] && [ "$TRAVIS_OS_NAME" = "linux" ]
then
  $SCAPY_SUDO apt-get -qy install libdumbnet-dev libpcap-dev
fi

# Make sure tox is installed and up to date
$PIP install -U tox
