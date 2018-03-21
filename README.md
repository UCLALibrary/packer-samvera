# Packer Samvera

An experimental project to build Samvera/Hyrax using Packer. Things aren't the way they'd ideally be, but my focus at this point is on incremental progress.

In the end, I'd like to see the option of an all-in-one box or a collection of service-specific boxes (with an orchestration piece) but, right now, an all-in-one box is what's built.

FWIW, the heavy lifting of the build is done by Data Curation Experts' [ansible-samvera](https://github.com/curationexperts/ansible-samvera) project.

There are two possible outputs from the build: an AWS AMI and/or a Vagrant VirtualBox.

The build is done in two steps. The first produces a 'samvera-base' box/AMI and the second installs an instance of Hyrax from a GitHub repository (with the output of that second build also being either a 
new AMI and/or new Vagrant VirtualBox).

### Getting Started

Copy the `sample-config.json` file to `config.json` and add or change its variables as needed.

### How to Build a 'samvera-base' AMI

    packer build -only=amazon-ebs -var-file=config.json samvera-base.json

### How to Build a Vagrant 'samvera-base' Box

    packer build -only=vagrant -var-file=config.json samvera-base.json

### How to Build and Deploy a Vagrant 'samvera-base' Box

    packer build -only=vagrant-deploy -var-file=config.json samvera-base.json

### Tips and Tricks

A useful flag to get the build to pause when there is an error: `-on-error=ask`

Add it to any of the other above command lines, as needed, and you can SSH into the box to see what's broken (if the Packer logs aren't sufficient).

### License

[BSD-3-Clause](LICENSE.txt)

### Contacts

Kevin S. Clarke &lt;<a href="mailto:ksclarke@ksclarke.io">ksclarke@ksclarke.io</a>&gt;
