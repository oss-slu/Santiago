function data = GetSurface(neuron)
    segments = sbfsem.render.Segment(neuron);
    data = {3,height(segments.segmentTable)};
    
    for i = 1:height(segments.segmentTable)
                radii = cell2mat(segments.segmentTable{i, 'Rum'});
                [X, Y, Z] = cylinder(radii);
        
                xyz = cell2mat(segments.segmentTable{i, 'XYZum'});
                Z = repmat(xyz(:, 3), [1, size(Z, 2)]);
       
                data{i} = {X+xyz(:, 1), Y+xyz(:,2),Z};
   
    end
end