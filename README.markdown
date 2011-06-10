Grid Compute Engine Client
==========================

Why gce (Grid Compute Engine)?
------------------------------
The purpose of gce is to get science on to graphics cards (GPUs) _fast_. Specifically, gce provides a simple framework to parallelize an FDTD simulation on to a massively parallel environment (one or multiple GPUs).

How does gce work?
------------------
gce allows users to specify their simulation in Matlab using the gce-client collection of matlab files in this directory. All that is needed is a valid installation of Matlab.

Once a simulation is specified, it can be executed on a _gce server_. A simple, [public server](http://brainiac5.stanford.edu) is provided by the Jelena Vuckovic group.

What do I need to get started?
------------------------------
1.  Download [gce-client](https://github.com/JesseLu/gce-client)
2.  Unzip it into a directory (e.g. /gce-client).
3.  Start Matlab (and change working directory to /gce-client)

Running the  tutorial
---------------------
Now, let's try the tutorial! Execute the following commands in Matlab:

    cd tutorial
    path(path, '..'); % Include the gce-client files.
    thermal_example('first_gce_sim.h5'); % Run the tutorial.

You should now have a file called `first_gce_sim.h5` in the current directory. Use your web browser to go to [brainiac5.stanford.edu](http://brainiac5.stanford.edu) and follow the instructions to simulate it there.

Once the simulation has completed and you've downloaded the simulated file to the current Matlab directory, plot a pretty movie of the results using

    thermal_plot('first_gce_sim.h5'); % Make sure that this is the simulated file!

Making your own gce simulation
------------------------------
Now you're ready to do FDTD simulation really quickly. To make your own gce simulation, 

1.  Look at the code in `thermal_example.m`, and
2.  Read the rules for gce operations in `OP_RULES.markdown`.

Good luck!

Contact info
------------
You may email jesselu at stanford dot edu for additional help.


