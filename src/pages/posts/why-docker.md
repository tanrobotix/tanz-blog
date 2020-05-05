---
title: 'Why Docker?'
excerpt: Docker is not very old. It was about to hit its 1.0 release in May of 2014 when I wrote a bit of an inflammatory
date: 2020-02-20T16:00:00+07:00
thumb_img_path: "/images/docker.png"
template: post
subtitle: ''
content_img_path: ''
draft: true

---

*Containers are not a new thing, but implementing them was always a little more complicated than it needed to be. Docker made great leaps in simplification of containers and set the world on fire from there. Let’s look at why.*

### Why Docker Became a Household Name?

Docker is not very old. It was about to hit its 1.0 release in May of 2014!

Since hitting version 1.0 in June 2014, Docker has taken “the cloud” by storm even seeing Google, Microsoft, Amazon, Cisco, HP, IBM, RedHat, VMWare, and others working together to develop a common standard with Docker as the core. That’s a non-trivial debut.

### Why Docker Instead of VMs? What’s the Big Deal?

Getting down to the nuts and bolts, Docker allows applications to be isolated into containers with instructions for exactly what they need to survive that can be easily ported from machine to machine. Virtual machines also allow the exact same thing, and numerous other tools like Chef and Puppet already exist to make rebuilding these configurations portable and reproducible.

While Docker has a more simplified structure compared to both of these, the real area where it causes disruption is resource efficiency.

If you have 30 Docker containers that you want to run, you can run them all on a single virtual machine. To run 30 virtual machines, you’ve got to boot 30 operating systems with at least minimum resource requirements available before factoring the hypervisor for them to run on with the base OS.

Just assuming you’re going to go with a minimum 256M VM you’d be looking at 7.5G of RAM with 30 different OS kernels managing resources. With Docker you could allocate a chunk of RAM to one VM and have a single OS managing those competing resources… and you could do all of that on the base operating system without a costly hypervisor needing to be involved at all.

Now that all sounds good for competing resources on individual machines, but what about the 1 to 1 comparison? Boden Russell did exactly that: benchmarking Docker vs KVM. Docker wins going away with a 26 to 1 performance improvement.

A key factor to keep in mind is that Docker is able to do what it does due to tight integration with the Linux kernel. It makes for significant efficiency at a low level, and because of that, Docker is not (currently) a replacement for virtual machines for Windows, OS X, etc. When running Docker containers on a non-Linux machine, they will be run inside of a VM via boot2docker.

Those types of efficiency gains are on par with cloud providers like Amazon and others getting a 26 to 1 performance improvement on the virtual machines that they sell per hour. It’s a huge enabler for their businesses because you’re suddenly able to do a lot more for the same price. Instead of needing to buy two virtual machines (for load balancing/availability) for every isolated application that you need to deploy, you could just cluster three larger VMs and deploy all of them to it, actual processor limits aside.

When business makes cost-benefit decisions around cloud migrations, this creates a huge swing in favor of cloud providers… hence the scrambling.

Docker Enables Consistent Environments
Another reason why Docker is so disruptive is portability. We’ve mostly discussed cloud providers to this point, but using the earlier illustration of needing 30 containers to run versus 30 virtual machines… consider your development machine.

With the explosion of microservices on the development scene, there is a very good chance that doing development on your laptop will involve starting several of these services at the same time in order to work. Vagrant helped with this on a per VM basis, but if I need to start four or five different microservices to work locally, that means running four or five virtual machines on my laptop on top of everything else that I need to work. With Docker, that’s reduced to a much more manageable single VM.

The ever-present challenge of replicating your production set up in development suddenly becomes close to reality. The containers themselves can be started with permission to talk to other containers on the machine. Each can have their own individual ports opened publicly, and they can even share resources of the base operating system.

This is why Docker is a huge help in enabling continous integration, delivery, and deployment pipelines. Here’s what that looks like in action:

Your development team is able to create complex requirements for a microservice within an easy-to-write Dockerfile.
Push the code up to your git repo.
Let the CI server pull it down and build the EXACT environment that will be used in production to run the test suite without needing to configure the CI server at all.
Tear down the entire thing when it’s finished.
Deploy it out to a staging environment for testers or just notify the testers so that they can run a single command to configure and start the environment locally.
Confidently roll exactly what you had in development, testing, and staging into production without any concerns about machine configuration.
A number of different individual languages have taken steps to enable this type of workflow within the bubble of their language. Java has had containerized application servers for over a decade for example, but Docker enables it across all Linux-based languages.

That… is… huge.

Docker Isn’t Going Away
It’s easy to jump on the “look, a new technology buzzword” bandwagon, but Docker is here to stay. The industry is creating major investments in the technology all across the board with skyrocketing adoption in the works.

While companies like Amazon are releasing their own container services, companies like Tutum leverage the portability of containers to create a platform that allows you to work with Docker on any cloud provider from AWS, Microsoft Azure, Digital Ocean, or even to customize it on your own. And by the way, Tutum was just recently acquired by Docker.

That’s why Docker is a game changer. It solves tons of issues that get in the way of teams working together effectively and does so while reducing your costs. You also might want to check out Codeship’s new Docker Platform that offers native Docker support.
