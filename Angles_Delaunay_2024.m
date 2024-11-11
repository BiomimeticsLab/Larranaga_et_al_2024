%% Create the Matrix to host the proliferative regions.

lattice=[];

% load the coordinates of the proliferative regions

lattice(:,1)=Results(:,7);
lattice(:,2)=Results(:,8);


%% Perform Delaunay Triangulation

DT = delaunayTriangulation(lattice);


%% Create the matrix to host the angles of each triangle

numTriangles = size(DT.ConnectivityList, 1);
angles = zeros(numTriangles, 3);

% calculate the angles by scanning the connectivity list
for i = 1:numTriangles
    % Identify coordinates of each vertex
    vertices = DT.ConnectivityList(i, :);
    P1 = DT.Points(vertices(1), :);
    P2 = DT.Points(vertices(2), :);
    P3 = DT.Points(vertices(3), :);
 
   % Vectors for the sides
    v1 = P2 - P1;
    v2 = P3 - P1;
    v3 = P3 - P2;
    
    % Calculate the lengths of each side
    a = norm(v3);
    b = norm(v2);
    c = norm(v1);

     % Calculate the angles using the law of cosines
    angles(i,1) = acos(dot(v1, v2) / (b * c)); % Angle at P1
    angles(i,2) = acos(dot(-v1, v3) / (a * c)); % Angle at P2
    angles(i,3) = acos(dot(-v2, -v3) / (a * b)); % Angle at P3
end

%% Convert to degrees
angles_degrees = rad2deg(angles);

%% Sum of angles for verification (each triangle should sum to 180 degrees)
S = sum(angles_degrees, 2);

%% Write the angles to a CSV file
writematrix(angles_degrees, 'angles_degrees.csv');

%% Calculate unique side lengths
edges = [];

% Use a set to avoid repetition
edgesSet = containers.Map;

for i = 1:numTriangles
    vertices = DT.ConnectivityList(i, :);
    for j = 1:3
        % Get the vertex indices for the current edge
        v1 = vertices(j);
        v2 = vertices(mod(j, 3) + 1);
        
        % Ensure the smaller index comes first to avoid duplication
        edge = sort([v1, v2]);

        % Create a unique key for the edge
        edgeKey = sprintf('%d-%d', edge(1), edge(2));
        
        % Check if the edge is already in the set
        if ~isKey(edgesSet, edgeKey)
            % Calculate the length of the edge
            length = norm(DT.Points(edge(1), :) - DT.Points(edge(2), :));
            
            % Add the length to the edges array and the edge key to the set
            edges = [edges; length];
            edgesSet(edgeKey) = true;
        end
    end
end

%% Write the unique side lengths to a CSV file
writematrix(edges, 'side_lengths.csv'); 

%% Plot the Delaunay triangulation
figure;
triplot(DT);
title('Delaunay Triangulation');
xlabel('X');
ylabel('Y');

%% Plot the histogram of the angles
edges_histogram = 0:5:180;
figure;
histogram(angles_degrees, edges_histogram);
title('Histogram of Triangle Angles');
xlabel('Angle (degrees)');
ylabel('Frequency');