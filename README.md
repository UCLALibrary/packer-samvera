# Packer Samvera

An experimental project to build Samvera/Hyrax using Packer. Things aren't the way they'd ideally be, but my focus at this point is on incremental progress. I'm new to the Samvera-Hyrax space so I'm 
using this project as a learning tool.

In the end, I'd like to see the option of an all-in-one box or a collection of service-specific boxes (with an orchestration piece) but, right now, an all-in-one box is what's built.

FWIW (and to their credit), the heavy lifting of the build is done by Data Curation Experts' [ansible-samvera](https://github.com/curationexperts/ansible-samvera) project.

There are currently two possible outputs from this Packer Samvera build: an AWS AMI (stored in your AWS space) and/or a Vagrant VirtualBox.

## Requirements

Bash is required to run the wrapper script. [Packer](https://www.packer.io/downloads.html) is required to run the build. And, [jq](https://stedolan.github.io/jq/download/) is required to work around a 
[Packer limitation](https://github.com/hashicorp/packer/issues/2679).

There are also some optional requirements, depending on the type of output you desire: an AWS account if you want to create AMIs, Vagrant and VirtualBox installed on your local machine if you want to use 
Vagrant, and Docker installed on your local machine if you want to use Docker.

## Getting Started

Copy the `sample-config.json` file to `config.json` and add or change its variables as needed. You can skip variables that aren't relevant to your build (e.g. AWS credentials if you're building a Vagrant 
box).

The Packer build is basically done in two steps. The first builds a "base box" with all the necessary system dependencies installed and the second installs a Hyrax application from a GitHub repo. The 
default Hyrax application is Nurax, which if I understand correctly is a snapshot/sandbox environment.

### How to Build a Samvera-Hyrax AWS AMI (In Two Steps)

    ./build.sh base ami
    ./build.sh hyrax ami

The second step can be run independently (and repeatedly) once the first has been successfully run.

### How to Build a Samvera-Hyrax Vagrant Box (In Two Steps)

    ./build.sh base vagrant
    ./build.sh hyrax vagrant

The second step can be run independently (and repeatedly) once the first has been successfully run.

### How to Use the Samvera-Hyrax Vagrant Box

The first thing you'll want to do after building is to add the box to your local Vagrant environment:

    cd vagrant/hyrax
    vagrant box add ksclarke/samvera-hyrax ../../builds/vagrant/samvera-hyrax.box

After that you can bring it up and, if you want, SSH into it:

    vagrant up
    vagrant ssh

Hyrax is exposed on http://localhost:8080 and Solr on http://localhost:8983/solr.

In case you were wondering what happened to `vagrant init` in the above steps... by changing into the `vagrant/hyrax` directory, we changed into the directory that has the box's Vagrantfile. If you use 
the prebuilt version of samvera-hyrax, mentioned below, you would also need to run `vagrant init` to get a local copy of the Vagrantfile.

### But I Don't Want to Build Anything

An alternative to building the Vagrant box yourself is to just use my prebuilt one:

    https://app.vagrantup.com/ksclarke/boxes/samvera-hyrax

The steps to do that are pretty simple (you might want to create a new directory to do them in):

    vagrant box add ksclarke/samvera-hyrax
    vagrant init
    vagrant up

You can then SSH in if you want to poke around further:

    vagrant ssh

If you want to interact with the box's services, you can see the passwords for them in the sample-config.json file from this project's root directory. You can also change characteristics of the Vagrant 
Box (for instance, memory, etc.) in the Vagrantfile that is downloaded in the `vagrant init` step.

### Deploying from VM to a Remote Server

The VM is setup to forward SSH keys to an agent that's running on the host machine. That means you can deploy from your Hyrax VM to a remote server if your Hyrax application is configured to do that 
and you have a key agent running on the host machine. GitHub has [a page](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) on using a ssh-agent on different 
platforms if you've not done this before.

### License

[BSD-3-Clause](LICENSE.txt)

### Contacts

Kevin S. Clarke &lt;<a href="mailto:ksclarke@ksclarke.io">ksclarke@ksclarke.io</a>&gt;
