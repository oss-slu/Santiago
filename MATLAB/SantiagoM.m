classdef Santiago < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        TabGroup                matlab.ui.container.TabGroup
        NeuronTab               matlab.ui.container.Tab
        SourceDropDownLabel     matlab.ui.control.Label
        SourceDropDown          matlab.ui.control.DropDown
        SetNeuronButton         matlab.ui.control.Button
        CellIDEditFieldLabel    matlab.ui.control.Label
        CellIDEditField         matlab.ui.control.NumericEditField
        NeuronLamp              matlab.ui.control.Lamp
        GraphApp                matlab.ui.container.Tab
        Panel                   matlab.ui.container.Panel
        PlotButtons             matlab.ui.control.Button
        Lamp                    matlab.ui.control.Lamp
        SourceLabel             matlab.ui.control.Label
        ShowSurfaceCheckBox     matlab.ui.control.CheckBox
        ShowunfinishedCheckBox  matlab.ui.control.CheckBox
        ShowterminalsCheckBox   matlab.ui.control.CheckBox
        ShowoffedgesCheckBox    matlab.ui.control.CheckBox
        GraphAppPlot            matlab.ui.control.UIAxes
        RenderAppTab            matlab.ui.container.Tab
        PlotButtons_2           matlab.ui.control.Button
        RenderLamp              matlab.ui.control.Lamp
        RenderAppPlot           matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        neuron
        neuronID
        source
        ax
        ui
        figureHandle
        dataCursor
        segments
        showSurface
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            app.showSurface = true;
            app.GraphAppPlot.Toolbar.Visible = 'off'; 
        end

        % Button pushed function: PlotButtons
        function plot(app, event)
            app.Lamp.Color = 'r';
            drawnow
            
            for i = 1:height(app.segments.segmentTable)
                
                % Generate cylinder coordinates with correct radii
                radii = cell2mat(app.segments.segmentTable{i, 'Rum'});
       
                [X, Y, Z] = cylinder(radii);
                % Translate the cylinder points by annotation XYZ
                xyz = cell2mat(app.segments.segmentTable{i, 'XYZum'});
                Z = repmat(xyz(:, 3), [1, size(Z, 2)]);
                % The PickableParts setting ensures surfaces are invisible
                % in datacursormode.
                s = surf(app.GraphAppPlot, X+xyz(:, 1), Y+xyz(:,2), Z,...
                    'FaceAlpha', 0.3,...`
                    'EdgeColor', 'none',...
                    'PickableParts', 'none',...
                    'Tag', ['s', num2str(i)]);
                if ~app.showSurface
                    set(s, 'Visible', 'off');
                end
                hold(app.GraphAppPlot, 'on');
            end
            axis(app.GraphAppPlot, 'equal', 'tight');
            
            
            for i = 1:height(app.segments.segmentTable)
                xyz = cell2mat(app.segments.segmentTable{i, 'XYZum'});
                line(app.GraphAppPlot, xyz(:,1), xyz(:,2), xyz(:,3),...
                    'Marker', '.', 'MarkerSize', 2,...
                    'LineWidth', 1, 'Color', 'k',...
                    'Tag', num2str(i));
            end
        
            app.Lamp.Color = 'g';
        end

        % Value changed function: ShowSurfaceCheckBox
        function surfaces(app, event)
            val = app.ShowSurfaceCheckBox.Value;
            app.showSurface = val;
            drawnow
        end

        % Button pushed function: SetNeuronButton
        function SetNeuronButtonPushed(app, event)
            app.NeuronLamp.Color = 'r';
            drawnow
            
            cla(app.GraphAppPlot);
            sourceVal = app.SourceDropDown.Value;
            app.neuronID = app.CellIDEditField.Value;
            app.SourceLabel.Text = sourceVal;
            disp(app.neuronID)
            app.neuron = Neuron(app.neuronID, 't');
            app.segments = sbfsem.render.Segment(app.neuron);
            
            app.NeuronLamp.Color = 'g';
        end

        % Button pushed function: PlotButtons_2
        function plotNeuron(app, event)
            app.RenderLamp.Color = 'r';
          
            drawnow
            
            app.neuron.render('ax', app.RenderAppPlot,...
             'FaceColor', [1 1 0],...
            'FaceAlpha', 0.6000);
            
             camlight(app.RenderAppPlot, 'headlight')
            
            app.RenderLamp.Color = 'g';
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create NeuronTab
            app.NeuronTab = uitab(app.TabGroup);
            app.NeuronTab.Title = 'Neuron';
            app.NeuronTab.BackgroundColor = [1 1 1];

            % Create SourceDropDownLabel
            app.SourceDropDownLabel = uilabel(app.NeuronTab);
            app.SourceDropDownLabel.HorizontalAlignment = 'right';
            app.SourceDropDownLabel.Position = [210 264 43 22];
            app.SourceDropDownLabel.Text = 'Source';

            % Create SourceDropDown
            app.SourceDropDown = uidropdown(app.NeuronTab);
            app.SourceDropDown.Items = {'NeitzInferiorMonkey', 'NeitzNasalMonkey', 'NeitzTemporalMonkey', 'NeitzCped', 'Option 1', 'Option 2'};
            app.SourceDropDown.Position = [268 264 199 22];
            app.SourceDropDown.Value = 'NeitzInferiorMonkey';

            % Create SetNeuronButton
            app.SetNeuronButton = uibutton(app.NeuronTab, 'push');
            app.SetNeuronButton.ButtonPushedFcn = createCallbackFcn(app, @SetNeuronButtonPushed, true);
            app.SetNeuronButton.Position = [210 179 100 22];
            app.SetNeuronButton.Text = 'Set Neuron';

            % Create CellIDEditFieldLabel
            app.CellIDEditFieldLabel = uilabel(app.NeuronTab);
            app.CellIDEditFieldLabel.HorizontalAlignment = 'right';
            app.CellIDEditFieldLabel.Position = [210 218 42 22];
            app.CellIDEditFieldLabel.Text = 'Cell ID';

            % Create CellIDEditField
            app.CellIDEditField = uieditfield(app.NeuronTab, 'numeric');
            app.CellIDEditField.Position = [267 218 100 22];

            % Create NeuronLamp
            app.NeuronLamp = uilamp(app.NeuronTab);
            app.NeuronLamp.Position = [329 180 20 20];

            % Create GraphApp
            app.GraphApp = uitab(app.TabGroup);
            app.GraphApp.Title = 'GraphApp';
            app.GraphApp.BackgroundColor = [1 1 1];

            % Create Panel
            app.Panel = uipanel(app.GraphApp);
            app.Panel.Position = [1 0 170 455];

            % Create PlotButtons
            app.PlotButtons = uibutton(app.Panel, 'push');
            app.PlotButtons.ButtonPushedFcn = createCallbackFcn(app, @plot, true);
            app.PlotButtons.Position = [12 53 100 22];
            app.PlotButtons.Text = 'Plot';

            % Create Lamp
            app.Lamp = uilamp(app.Panel);
            app.Lamp.Position = [129 54 20 20];

            % Create SourceLabel
            app.SourceLabel = uilabel(app.Panel);
            app.SourceLabel.Position = [16 415 137 22];
            app.SourceLabel.Text = 'Source';

            % Create ShowSurfaceCheckBox
            app.ShowSurfaceCheckBox = uicheckbox(app.Panel);
            app.ShowSurfaceCheckBox.ValueChangedFcn = createCallbackFcn(app, @surfaces, true);
            app.ShowSurfaceCheckBox.Text = 'Show Surface';
            app.ShowSurfaceCheckBox.Position = [15 316 97 22];
            app.ShowSurfaceCheckBox.Value = true;

            % Create ShowunfinishedCheckBox
            app.ShowunfinishedCheckBox = uicheckbox(app.Panel);
            app.ShowunfinishedCheckBox.Text = 'Show unfinished';
            app.ShowunfinishedCheckBox.Position = [15 281 110 22];

            % Create ShowterminalsCheckBox
            app.ShowterminalsCheckBox = uicheckbox(app.Panel);
            app.ShowterminalsCheckBox.Text = 'Show terminals';
            app.ShowterminalsCheckBox.Position = [15 249 104 22];

            % Create ShowoffedgesCheckBox
            app.ShowoffedgesCheckBox = uicheckbox(app.Panel);
            app.ShowoffedgesCheckBox.Text = 'Show off edges';
            app.ShowoffedgesCheckBox.Position = [15 210 104 22];

            % Create GraphAppPlot
            app.GraphAppPlot = uiaxes(app.GraphApp);
            app.GraphAppPlot.View = [20 45];
            app.GraphAppPlot.Projection = 'perspective';
            app.GraphAppPlot.PlotBoxAspectRatio = [1.01450447669729 1.00193353653608 1];
            app.GraphAppPlot.XGrid = 'on';
            app.GraphAppPlot.YGrid = 'on';
            app.GraphAppPlot.ZGrid = 'on';
            app.GraphAppPlot.Position = [200 22 439 415];

            % Create RenderAppTab
            app.RenderAppTab = uitab(app.TabGroup);
            app.RenderAppTab.Title = 'RenderApp';

            % Create PlotButtons_2
            app.PlotButtons_2 = uibutton(app.RenderAppTab, 'push');
            app.PlotButtons_2.ButtonPushedFcn = createCallbackFcn(app, @plotNeuron, true);
            app.PlotButtons_2.Position = [32 53 100 22];
            app.PlotButtons_2.Text = 'Plot';

            % Create RenderLamp
            app.RenderLamp = uilamp(app.RenderAppTab);
            app.RenderLamp.Position = [149 54 20 20];

            % Create RenderAppPlot
            app.RenderAppPlot = uiaxes(app.RenderAppTab);
            app.RenderAppPlot.View = [20 45];
            app.RenderAppPlot.Projection = 'perspective';
            app.RenderAppPlot.PlotBoxAspectRatio = [1.01450447669729 1.00193353653608 1];
            app.RenderAppPlot.XGrid = 'on';
            app.RenderAppPlot.YGrid = 'on';
            app.RenderAppPlot.ZGrid = 'on';
            app.RenderAppPlot.Position = [200 22 439 415];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Santiago

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end