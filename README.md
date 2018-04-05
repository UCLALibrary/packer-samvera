# Packer Samvera

An experimental project to build Samvera/Hyrax using Packer. Things aren't the way they'd ideally be, but my focus at this point is on incremental progress. I'm new to the Samvera-Hyrax space so I'm 
using this project as a learning tool.

In the end, I'd like to see the option of an all-in-one box or a collection of service-specific boxes (with an orchestration piece) but, right now, an all-in-one box is what's built.

FWIW (and to their credit), the heavy lifting of the build is done by Data Curation Experts' [ansible-samvera](https://github.com/curationexperts/ansible-samvera) project.

There are currently two possible outputs from this Packer Samvera build: an AWS AMI (stored in your AWS space) and/or a Vagrant VirtualBox.

## Getting Started

Copy the `sample-config.json` file to `config.json` and add or change its variables as needed. You'll also need to download and install [Packer](https://www.packer.io/downloads.html).

The Packer build is basically done in two steps. The first builds a "base box" with all the necessary system dependencies installed and the second installs a Hyrax application from a GitHub repo. The 
default Hyrax application is Nurax, which if I understand correctly is a snapshot/sandbox environment.

### How to build a Samvera-Hyrax AWS AMI (in two steps)

    packer build -only=amazon-ebs -var-file=config.json samvera-base.json
    packer build -only=amazon-ebs -var-file=config.json samvera-hyrax.json

The second step can be run independently (and repeatedly) once the first has been successfully run.

### How to Build a Samvera-Hyrax Vagrant Box (in two steps)

    packer build -only=vagrant -var-file=config.json samvera-base.json
    packer build -only=vagrant -var-file=config.json samvera-hyrax.json

The second step can be run independently (and repeatedly) once the first has been successfully run.

### How to Use the Samvera-Hyrax Vagrant Box

The first thing you'll want to do after building the box is to add the box to your local Vagrant environment:

    cd vagrant/hyrax
    vagrant box add ksclarke/samvera-hyrax ../../builds/vagrant/samvera-hyrax.box

After that you can bring it up and, if you want, SSH into it:

    vagrant up
    vagrant ssh

Hyrax is exposed on http://localhost:8080 and Solr on http://localhost:8983/solr.

In case you were wondering what happened to `vagrant init` in the above steps... by changing into the `vagrant/hyrax` directory, we changed into the directory that has the box's Vagrantfile. If you use 
the prebuilt version of samvera-hyrax, mentioned below, you would also need to run `vagrant init` to get a local copy of the Vagrantfile.

### But I Don't Want to Build Anything

An alternative to building the Vagrant Box yourself is to just use my prebuilt one:

    https://app.vagrantup.com/ksclarke/boxes/samvera-hyrax

The steps to do that are pretty simple:

    vagrant box add ksclarke/samvera-hyrax
    vagrant init
    vagrant up

You can then SSH in if you want to poke around further:

    vagrant ssh

If you want to interact with the box's services, you can see the passwords for them in the sample-config.json file from this project's root directory. You can also change characteristics of the Vagrant 
Box (for instance, memory, etc.) in the Vagrantfile that is downloaded in the `vagrant init` step.

### Tips and Tricks

A useful flag to add to get the build to pause when there is an error: `-on-error=ask`

Add it to any of the other above command lines, as needed, and you can SSH into the box to see what's broken (if the Packer logs aren't sufficient).

### License

[BSD-3-Clause](LICENSE.txt)

### Contacts

Kevin S. Clarke &lt;<a href="mailto:ksclarke@ksclarke.io">ksclarke@ksclarke.io</a>&gt;
