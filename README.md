# Bastion

A bastion is an appliance that enables authorized access to a network via SSH Tunneling.

This module has support for IP whitelists (a list of IPs that are allowed to access the network).

## When to use

A bastion is a great choice for small teams that want to protect sensitive resources, but do not have the resources for a VPN.

## SSH Tunneling

It's possible to SSH directly into the bastion; however, most developers want to access other resources on the network.
By using `ssh -L ...`, you can forward a port from the remote network to your local computer.

Let's look at an example.
There is a Postgres cluster on the network with address: `teal-fox-jkcpl.chctd4jll7hm.us-west-2.rds.amazonaws.com:5432`.
We can forward using `ssh -L 0.0.0.0:6432:teal-fox-jkcpl.chctd4jll7hm.us-west-2.rds.amazonaws.com:5432 <user>@<bastion-ip>`.
This opens a port `6432` locally that will forward communication to the postgres cluster on the private network through the bastion.

## Manage IP Whitelisting

By default, the allowed IPs are restricted via `var.allowed_cidr_blocks` and `var.allowed_ipv6_cidr_blocks`.

If you are behind a router (home network, coffee shop, etc.), you will need to find and allow your public IP address.
This is discoverable by visiting [whatismyip.com](https://www.whatismyip.com/).
If you are adding an IPv4 address, add your single IP address to `var.allowed_cidr_blocks` with a `/32` suffix.
If you are adding an IPv6 address, add your single IP address to `var.allowed_ipv6_cidr_blocks` with a `/64` suffix.

## Manage SSH Keys

A public key is required to launch this bastion (via `var.ssh_public_key`).
This allows access to SSH into the bastion using the SSH keypair specified.

Follow these instructions at [How to set up SSH Keys on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04#step-2-copying-the-public-key-to-your-ubuntu-server) to authorize additional users.
