Grid Compute Engine Client
==========================

Why gce (Grid Compute Engine)?
------------------------------
The purpose of gce is to get science on to graphics cards (GPUs) _fast_. Specifically, gce provides a simple framework to parallelize an FDTD simulation on to a massively parallel environment (one or multiple GPUs).

How does gce work?
------------------
gce allows users to specify their simulation in Matlab using the gce-client collection of matlab files in this directory. All that is needed is a valid installation of Matlab.

Once a simulation is specified, it can be executed on a _gce server_. A simple, [public server](brainiac5.stanford.edu) is provided by the Jelena Vuckovic group.

What do I need to get started?
------------------------------
1.  Download [gce-client](https://github.com/JesseLu/gce-client)
2.  Unzip it into a directory (e.g. /gce-client).
3.  Start Matlab (and change working directory to /gce-client)
4.  Try the tutorial!
