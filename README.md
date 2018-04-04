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

### How to Build a Vagrant Samvera-Hyrax Box (in two steps)

    packer build -only=vagrant -var-file=config.json samvera-base.json
    packer build -only=amazon-ebs -var-file=config.json samvera-hyrax.json

The second step can be run independently (and repeatedly) once the first has been successfully run.

### But I Don't Want to Build Anything

An alternative to building the Vagrant Box yourself is to just use my prebuilt one:

    https://app.vagrantup.com/ksclarke/boxes/samvera-hyrax

You can see the passwords that have been set in the sample-config.json file from this project's root directory.

### Tips and Tricks

A useful flag to add to get the build to pause when there is an error: `-on-error=ask`

Add it to any of the other above command lines, as needed, and you can SSH into the box to see what's broken (if the Packer logs aren't sufficient).

### License

[BSD-3-Clause](LICENSE.txt)

### Contacts

Kevin S. Clarke &lt;<a href="mailto:ksclarke@ksclarke.io">ksclarke@ksclarke.io</a>&gt;
