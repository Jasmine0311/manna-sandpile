function p_grain = manna(L, nr_grains)
% p_grain = MANNA(L, nr_grains) calculates the grain density on LxL lattice
% of the Manna sandpile model. The algorithm is based on the original model
% description in Manna, S. S. "Two-state model of self-organized
% criticality." Journal of Physics A: Mathematical and General 24.7 (1991):
% L363.
%
% From the article:
%
% Consider a square lattice where the sites can be either empty or occupied
% with particles. No more than one particle is allowed to be at a site in
% the stationary state. One particle is added to one of the randomly chosen
% sites. If it is empty, it gets occupied by that particle and a new
% particle is launched. If there is already a particle at that site a 'hard
% core interaction' throws all the particles out from that site and the
% particles are redistributed in a random manner among its neighbors. It
% can happen that some of the neighbors were already occupied; then the
% particles are again redistributed and so on. In this way cascades are
% created. A cascade is stopped if no occupancy higher than one is present.
% Free boundaries are used, i.e. particles can leave the system on the
% boundaries. We update the sytem through the following step which all
% together constitute a unit time step:
%   (a) at any instant all collision sites are located;
%   (b) all these sites are made empty
%   (c) for each particle in each collision site one neighboring site is
%   randomly selected and the particle number at that site is increased by
%   one
%   (d) collision sites for the next time step are located from these new
%   sites

% Initialize occupancy matrix, i.e. number of grains at each location
h = zeros(L, L);

% Initialize grain density
p_grain = zeros(nr_grains, 1);

tSIM = tic;
tDISPLAY = tic;

% Add grains one by one
for i = 1:nr_grains    
    % Add one particle to a randomly chosen site
    add = randi(L*L);
    h(add) = h(add)+1;
    
    % Update the system if there is at least one collision site
    while ~isempty(find(h>1, 1))        
        % Find 1D and 2D indices of collision sites
        col_sites = find(h>1);
        [col_row, col_col] = ind2sub([L L], col_sites);

        % Randomly select two neighbors with replacement for each collision
        % site
        for j = 1:length(col_sites)      
            c = col_sites(j);
            % Get neighbot site indices
            nsi = neighbor_site_indices(c, col_row(j), col_col(j), L);
            
            % Topple one grain to a randomly selected neighbor site until
            % no more grains are left at the collision site
            for k = 1:h(c)                
                add_index = randi(4, 1);
                % Add a grain if the selected neighbor exists. If it
                % doesn't exist, then the grain falls off the lattice
                if add_index <= length(nsi)
                    h(nsi(add_index)) = h(nsi(add_index))+1;
                end
                % Remove a grain from the collision site
                h(c) = h(c)-1;
            end
        end
    end
       
    % Calculate grain density
    p_grain(i) = sum(sum(h))/(L^2);
    
    % Report simulation progress
    if toc(tDISPLAY) > 6      
        fprintf('%%%.2f of all grains added in %1.2f minutes\n', ...
            i*100/nr_grains, toc(tSIM)/60);
        tDISPLAY = tic;
    end
end

% Plot grain density
figure,
plot(p_grain);
xlabel('Grains added');
legend('Grain density', 'Location', 'Best');
title(['Manna sandpile model on ' num2str(L) 'x' num2str(L) ' lattice']);

end

% Neighbor site index calculator
function nsi = neighbor_site_indices(c, crow, ccol, L)

if crow-1~=0 && crow-L~=0 && ccol-1~=0 && ccol-L~=0
    % Inner side
    nsi = [c-1, c+1, c-L, c+L];
elseif crow-1~=0 && crow-L~=0
    if ccol-1==0
        % Left side
        nsi = [c-1, c+1, c+L];
    elseif ccol-L==0
        % Right side
        nsi = [c-1, c+1, c-L];
    end
elseif ccol-1~=0 && ccol-L~=0
    if crow-1==0
        % Top side
        nsi = [c+1, c-L, c+L];
    elseif crow-L==0
        % Bottom side
        nsi = [c-1, c-L, c+L];
    end
elseif crow-1==0
    if ccol-1==0
        % Top-left corner
        nsi = [c+1, c+L];
    elseif ccol-L==0
        % Top-right corner
        nsi = [c+1, c-L];
    end
elseif crow-L==0
    if ccol-1==0
        % Bottom-left corner
        nsi = [c-1, c+L];
    elseif ccol-L==0
        % Bottom-right corner
        nsi = [c-1, c-L];
    end
end

end