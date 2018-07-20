# Packer Samvera

An experimental project to build Samvera/Hyrax using Packer. Things aren't the way they'd ideally be, but my focus at this point is on incremental progress. I'm new to the Samvera-Hyrax space so I'm 
using this project as a learning tool.

In the end, I'd like to see the option of an all-in-one box or a collection of service-specific boxes (with an orchestration piece) but, right now, an all-in-one box is what's built.

FWIW (and to their credit), the heavy lifting of the build is done by Data Curation Experts' [ansible-samvera](https://github.com/curationexperts/ansible-samvera) project.

There are currently two possible outputs from this Packer Samvera build: an AWS AMI (stored in your AWS space) and/or a Vagrant VirtualBox.

## Requirements

Bash is required to run the wrapper script. [Packer](https://www.packer.io/downloads.html) is required to run the build. And, [jq](https://stedolan.github.io/jq/download/) is required to work around a 
[Packer limitation](https://github.com/hashicorp/packer/issues/2679).

There are also some optional requirements, depending on the type of output you desire:
* An AWS account if you want to create AMIs
* Vagrant and VirtualBox installed on your local machine if you want to use Vagrant

If you decide to use Vagrant, you'll also need to install a few additional things on your host system:
* An SSH agent to handle GitHub commits and deploying to a remote server (GitHub has [a page on setting up 
ssh-agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) on different platforms if you've not done this before)
* SSHFS and the Vagrant SSHFS plugin to expose the Hyrax source code to your host machine (How you install these will vary depending on your OS, but both are available in the Ubuntu repositories)

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

Hyrax is exposed at http://localhost:8080, Fedora at http://localhost:8181/fedora/rest, and Solr at http://localhost:8983/solr.

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

### License

[BSD-3-Clause](LICENSE.txt)

### Contacts

If you have any questions, suggestions, comments, etc., about the build feel free to send them to Kevin S. Clarke &lt;<a href="mailto:ksclarke@ksclarke.io">ksclarke@ksclarke.io</a>&gt;
