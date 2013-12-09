name             "errbit"
maintainer       "Sachin Sagar Rai"
maintainer_email "millisami@gmail.com"
license          "All rights reserved"
description      "Installs/Configures errbit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.4.0"

depends          "git"
depends          "ruby_build"
depends          "rbenv"
depends          "apt"
depends          "nginx"
depends          "build-essential"

recommends       "mongodb"

supports         "ubuntu"
