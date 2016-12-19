# manna-sandpile
p_grain = MANNA(L, nr_grains) calculates the grain density on LxL lattice of the Manna sandpile model. The algorithm is based on the original model description in Manna, S. S. "Two-state model of self-organized criticality." Journal of Physics A: Mathematical and General 24.7 (1991): L363.

From the article:

Consider a square lattice where the sites can be either empty or occupied with particles. No more than one particle is allowed to be at a site in the stationary state. One particle is added to one of the randomly chosen sites. If it is empty, it gets occupied by that particle and a new particle is launched. If there is already a particle at that site a 'hard core interaction' throws all the particles out from that site and the particles are redistributed in a random manner among its neighbors. It can happen that some of the neighbors were already occupied; then the particles are again redistributed and so on. In this way cascades are created. A cascade is stopped if no occupancy higher than one is present. Free boundaries are used, i.e. particles can leave the system on the boundaries. We update the sytem through the following step which all together constitute a unit time step:
(a) at any instant all collision sites are located;
(b) all these sites are made empty
(c) for each particle in each collision site one neighboring site is randomly selected and the particle number at that site is increased by one
(d) collision sites for the next time step are located from these new sites
