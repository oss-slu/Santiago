classdef Santiago < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        ImportMenu                  matlab.ui.container.Menu
        ExportMenu                  matlab.ui.container.Menu
        OpeninnewfigurewindowMenu   matlab.ui.container.Menu
        ExportasimageMenu           matlab.ui.container.Menu
        ExportasCOLLADAMenu         matlab.ui.container.Menu
        SendneuronstoworkspaceMenu  matlab.ui.container.Menu
        HelpMenu                    matlab.ui.container.Menu
        KeyboardcontrolsMenu        matlab.ui.container.Menu
        TabGroup                    matlab.ui.container.TabGroup
        SourceSelectionTab          matlab.ui.container.Tab
        GridLayout2                 matlab.ui.container.GridLayout
        Panel_3                     matlab.ui.container.Panel
        SetSourceButton             matlab.ui.control.Button
        SourceDropDown              matlab.ui.control.DropDown
        SourceDropDownLabel         matlab.ui.control.Label
        SelectedSourceLabel         matlab.ui.control.Label
        Label                       matlab.ui.control.Label
        GraphApp                    matlab.ui.container.Tab
        Panel                       matlab.ui.container.Panel
        GraphAppPlotButton          matlab.ui.control.Button
        GraphAppLamp                matlab.ui.control.Lamp
        SourceLabel                 matlab.ui.control.Label
        ShowSurfaceCheckBox         matlab.ui.control.CheckBox
        ShowunfinishedCheckBox      matlab.ui.control.CheckBox
        ShowterminalsCheckBox       matlab.ui.control.CheckBox
        ShowoffedgesCheckBox        matlab.ui.control.CheckBox
        CellEditField_2Label        matlab.ui.control.Label
        CellEditField_2             matlab.ui.control.NumericEditField
        GraphAppPlot                matlab.ui.control.UIAxes
        RenderAppTab                matlab.ui.container.Tab
        Panel_2                     matlab.ui.container.Panel
        PlotsPanel                  matlab.ui.container.Panel
        GridLayout                  matlab.ui.container.GridLayout
        SourceLabel_2               matlab.ui.control.Label
        RenderPlotButton            matlab.ui.control.Button
        RenderLamp                  matlab.ui.control.Lamp
        ColorButton                 matlab.ui.control.Button
        ColorLamp                   matlab.ui.control.Lamp
        CellEditFieldLabel          matlab.ui.control.Label
        CellEditField               matlab.ui.control.NumericEditField
        RenderAppPlot               matlab.ui.control.UIAxes
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
        graphPlot
        row
    end
    
    methods (Access = public)
        
        function plotCheckbox(app, event)

            disp(event.Source)
            disp(event.Source.Tag)
            
            if(event.Source.Value)
                set(findall(app.RenderAppPlot, 'Type', 'patch'), 'Visible', 'on');
            else
                set(findall(app.RenderAppPlot, 'Type', 'patch'), 'Visible', 'off');
            end

      end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            app.showSurface = true;
            app.row = 1;
            app.GraphAppPlot.Toolbar.Visible = 'off'; 
            app.RenderAppPlot.Toolbar.Visible = 'off'; 
            camlight(app.RenderAppPlot, 'headlight')
        end

        % Button pushed function: GraphAppPlotButton
        function plot(app, event)
            app.GraphAppLamp.Color = 'r';
            cla(app.GraphAppPlot);
            drawnow
            
            app.neuronID = app.CellEditField_2.Value;
            app.neuron = Neuron(app.neuronID, 't');
            app.segments = sbfsem.render.Segment(app.neuron);
            
            for i = 1:height(app.segments.segmentTable)
                
                % Generate cylinder coordinates with correct radii
                radii = cell2mat(app.segments.segmentTable{i, 'Rum'});
       
                [X, Y, Z] = cylinder(radii);
                % Translate the cylinder points by annotation XYZ
                xyz = cell2mat(app.segments.segmentTable{i, 'XYZum'});
                Z = repmat(xyz(:, 3), [1, size(Z, 2)]);
                % The PickableParts setting ensures surfaces are invisible
                % in datacursormode.
                app.graphPlot = surf(app.GraphAppPlot, X+xyz(:, 1), Y+xyz(:,2), Z,...
                    'FaceAlpha', 0.3,...`
                    'EdgeColor', 'none',...
                    'PickableParts', 'none',...
                    'Tag', ['s', num2str(i)]);
                if ~app.showSurface
                    set(app.graphPlot, 'Visible', 'off');
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
        
            app.GraphAppLamp.Color = 'g';
        end

        % Value changed function: ShowSurfaceCheckBox
        function surfaces(app, event)
            val = app.ShowSurfaceCheckBox.Value;
            app.showSurface = val;
            
            if ~app.showSurface
                    set(app.graphPlot, 'Visible', 'off');
            else
                set(app.graphPlot, 'Visible', 'on');
            end
            
            drawnow
        end

        % Button pushed function: SetSourceButton
        function SetSourceButtonPushed(app, event)
                      
            sourceVal = app.SourceDropDown.Value;
            app.SourceLabel.Text = sourceVal;
            app.SourceLabel_2.Text = sourceVal;
            app.Label.Text = sourceVal;

        end

        % Button pushed function: RenderPlotButton
        function plotNeuron(app, event)
            app.RenderLamp.Color = 'r';
            cellID = app.CellEditField.Value;
            drawnow
            n = Neuron(cellID, 't');
            
            checkBox = uicheckbox(app.GridLayout, 'Value', 1);
            checkBox.Text = sprintf("c%d", cellID);
            checkBox.Layout.Row = app.row;
            checkBox.ValueChangedFcn = createCallbackFcn(app, @plotCheckbox, true);
            checkBox.Tag = int2str(cellID);            
            app.row = app.row + 1;
          
            
            n.render('ax', app.RenderAppPlot,...
             'FaceColor', app.ColorLamp.Color,...
            'FaceAlpha', 0.6000);
        
            app.RenderLamp.Color = 'g';
        end

        % Button pushed function: ColorButton
        function ColorButtonPushed(app, event)
            c = uisetcolor([0.6 0.8 1]);
            app.ColorLamp.Color = c;
        end

        % Button down function: UIFigure
        function UIFigureButtonDown(app, event)
            
        end

        % Key press function: UIFigure
        function UIFigureKeyPress(app, event)
            key = event.Key;

            currentTab = app.TabGroup.SelectedTab.Title;
            disp(app.GraphAppPlot.XLim)
            if currentTab == "GraphApp"
                angle = app.GraphAppPlot.View;    
           
                if key == "downarrow"
                    view(app.GraphAppPlot, angle(1), angle(2)+5);
                elseif key == "uparrow"
                    view(app.GraphAppPlot, angle(1), angle(2)-5); 
                elseif key == "rightarrow"
                    view(app.GraphAppPlot, angle(1)-5, angle(2));    
                elseif key == "leftarrow"
                    view(app.GraphAppPlot, angle(1)+5, angle(2));       
            
    
    
                end     
            elseif currentTab == "RenderApp"
                angle = app.RenderAppPlot.View;  
          
                if key == "downarrow"
                    view(app.RenderAppPlot, angle(1), angle(2)+5);
                elseif key == "uparrow"
                    view(app.RenderAppPlot, angle(1), angle(2)-5); 
                elseif key == "rightarrow"
                    view(app.RenderAppPlot, angle(1)-5, angle(2));    
                elseif key == "leftarrow"
                    view(app.RenderAppPlot, angle(1)+5, angle(2));   
 
                end     
            end
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
            app.UIFigure.ButtonDownFcn = createCallbackFcn(app, @UIFigureButtonDown, true);
            app.UIFigure.KeyPressFcn = createCallbackFcn(app, @UIFigureKeyPress, true);

            % Create ImportMenu
            app.ImportMenu = uimenu(app.UIFigure);
            app.ImportMenu.Text = 'Import';

            % Create ExportMenu
            app.ExportMenu = uimenu(app.UIFigure);
            app.ExportMenu.Text = 'Export';

            % Create OpeninnewfigurewindowMenu
            app.OpeninnewfigurewindowMenu = uimenu(app.ExportMenu);
            app.OpeninnewfigurewindowMenu.Text = 'Open in new figure window';

            % Create ExportasimageMenu
            app.ExportasimageMenu = uimenu(app.ExportMenu);
            app.ExportasimageMenu.Text = 'Export as image';

            % Create ExportasCOLLADAMenu
            app.ExportasCOLLADAMenu = uimenu(app.ExportMenu);
            app.ExportasCOLLADAMenu.Text = 'Export as COLLADA';

            % Create SendneuronstoworkspaceMenu
            app.SendneuronstoworkspaceMenu = uimenu(app.ExportMenu);
            app.SendneuronstoworkspaceMenu.Text = 'Send neurons to workspace';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.UIFigure);
            app.HelpMenu.Text = 'Help';

            % Create KeyboardcontrolsMenu
            app.KeyboardcontrolsMenu = uimenu(app.HelpMenu);
            app.KeyboardcontrolsMenu.Text = 'Keyboard controls';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create SourceSelectionTab
            app.SourceSelectionTab = uitab(app.TabGroup);
            app.SourceSelectionTab.Title = 'Source Selection';
            app.SourceSelectionTab.BackgroundColor = [1 1 1];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.SourceSelectionTab);
            app.GridLayout2.ColumnWidth = {'1x', 79, 46, 42, 157, 85, '1x'};
            app.GridLayout2.RowHeight = {'1x', 78, 22, 73, 22, 81, '1.18x'};

            % Create Panel_3
            app.Panel_3 = uipanel(app.GridLayout2);
            app.Panel_3.BackgroundColor = [1 1 1];
            app.Panel_3.Layout.Row = [2 6];
            app.Panel_3.Layout.Column = [2 6];

            % Create SetSourceButton
            app.SetSourceButton = uibutton(app.Panel_3, 'push');
            app.SetSourceButton.ButtonPushedFcn = createCallbackFcn(app, @SetSourceButtonPushed, true);
            app.SetSourceButton.Position = [163 163 100 22];
            app.SetSourceButton.Text = 'Set Source';

            % Create SourceDropDown
            app.SourceDropDown = uidropdown(app.GridLayout2);
            app.SourceDropDown.Items = {'NeitzInferiorMonkey', 'NeitzNasalMonkey', 'NeitzTemporalMonkey', 'NeitzCped', 'Option 1', 'Option 2'};
            app.SourceDropDown.Layout.Row = 3;
            app.SourceDropDown.Layout.Column = [4 5];
            app.SourceDropDown.Value = 'NeitzInferiorMonkey';

            % Create SourceDropDownLabel
            app.SourceDropDownLabel = uilabel(app.GridLayout2);
            app.SourceDropDownLabel.HorizontalAlignment = 'right';
            app.SourceDropDownLabel.FontWeight = 'bold';
            app.SourceDropDownLabel.Layout.Row = 3;
            app.SourceDropDownLabel.Layout.Column = 3;
            app.SourceDropDownLabel.Text = 'Source';

            % Create SelectedSourceLabel
            app.SelectedSourceLabel = uilabel(app.GridLayout2);
            app.SelectedSourceLabel.FontWeight = 'bold';
            app.SelectedSourceLabel.Layout.Row = 5;
            app.SelectedSourceLabel.Layout.Column = [3 4];
            app.SelectedSourceLabel.Text = 'Selected Source:';

            % Create Label
            app.Label = uilabel(app.GridLayout2);
            app.Label.Layout.Row = 5;
            app.Label.Layout.Column = 5;
            app.Label.Text = '';

            % Create GraphApp
            app.GraphApp = uitab(app.TabGroup);
            app.GraphApp.Title = 'GraphApp';
            app.GraphApp.BackgroundColor = [1 1 1];

            % Create Panel
            app.Panel = uipanel(app.GraphApp);
            app.Panel.Position = [1 1 188 454];

            % Create GraphAppPlotButton
            app.GraphAppPlotButton = uibutton(app.Panel, 'push');
            app.GraphAppPlotButton.ButtonPushedFcn = createCallbackFcn(app, @plot, true);
            app.GraphAppPlotButton.Position = [12 52 100 22];
            app.GraphAppPlotButton.Text = 'Plot';

            % Create GraphAppLamp
            app.GraphAppLamp = uilamp(app.Panel);
            app.GraphAppLamp.Position = [129 53 20 20];

            % Create SourceLabel
            app.SourceLabel = uilabel(app.Panel);
            app.SourceLabel.Position = [16 414 137 22];
            app.SourceLabel.Text = 'Source';

            % Create ShowSurfaceCheckBox
            app.ShowSurfaceCheckBox = uicheckbox(app.Panel);
            app.ShowSurfaceCheckBox.ValueChangedFcn = createCallbackFcn(app, @surfaces, true);
            app.ShowSurfaceCheckBox.Text = 'Show Surface';
            app.ShowSurfaceCheckBox.Position = [15 311 97 22];
            app.ShowSurfaceCheckBox.Value = true;

            % Create ShowunfinishedCheckBox
            app.ShowunfinishedCheckBox = uicheckbox(app.Panel);
            app.ShowunfinishedCheckBox.Text = 'Show unfinished';
            app.ShowunfinishedCheckBox.Position = [15 280 110 22];

            % Create ShowterminalsCheckBox
            app.ShowterminalsCheckBox = uicheckbox(app.Panel);
            app.ShowterminalsCheckBox.Text = 'Show terminals';
            app.ShowterminalsCheckBox.Position = [15 248 104 22];

            % Create ShowoffedgesCheckBox
            app.ShowoffedgesCheckBox = uicheckbox(app.Panel);
            app.ShowoffedgesCheckBox.Text = 'Show off edges';
            app.ShowoffedgesCheckBox.Position = [15 217 104 22];

            % Create CellEditField_2Label
            app.CellEditField_2Label = uilabel(app.Panel);
            app.CellEditField_2Label.HorizontalAlignment = 'right';
            app.CellEditField_2Label.Position = [14 93 26 22];
            app.CellEditField_2Label.Text = 'Cell';

            % Create CellEditField_2
            app.CellEditField_2 = uieditfield(app.Panel, 'numeric');
            app.CellEditField_2.Position = [55 93 100 22];

            % Create GraphAppPlot
            app.GraphAppPlot = uiaxes(app.GraphApp);
            app.GraphAppPlot.View = [20 45];
            app.GraphAppPlot.Projection = 'perspective';
            app.GraphAppPlot.PlotBoxAspectRatio = [1.01450447669729 1.00193353653608 1];
            app.GraphAppPlot.XGrid = 'on';
            app.GraphAppPlot.YGrid = 'on';
            app.GraphAppPlot.ZGrid = 'on';
            app.GraphAppPlot.Position = [189 21 439 415];

            % Create RenderAppTab
            app.RenderAppTab = uitab(app.TabGroup);
            app.RenderAppTab.Title = 'RenderApp';
            app.RenderAppTab.BackgroundColor = [1 1 1];

            % Create Panel_2
            app.Panel_2 = uipanel(app.RenderAppTab);
            app.Panel_2.Position = [1 1 200 454];

            % Create PlotsPanel
            app.PlotsPanel = uipanel(app.Panel_2);
            app.PlotsPanel.Title = 'Plots';
            app.PlotsPanel.Position = [15 136 174 277];

            % Create GridLayout
            app.GridLayout = uigridlayout(app.PlotsPanel);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.BackgroundColor = [1 1 1];

            % Create SourceLabel_2
            app.SourceLabel_2 = uilabel(app.Panel_2);
            app.SourceLabel_2.Position = [18 423 137 22];
            app.SourceLabel_2.Text = 'Source';

            % Create RenderPlotButton
            app.RenderPlotButton = uibutton(app.RenderAppTab, 'push');
            app.RenderPlotButton.ButtonPushedFcn = createCallbackFcn(app, @plotNeuron, true);
            app.RenderPlotButton.Position = [26 53 100 22];
            app.RenderPlotButton.Text = 'Plot';

            % Create RenderLamp
            app.RenderLamp = uilamp(app.RenderAppTab);
            app.RenderLamp.Position = [143 54 20 20];

            % Create ColorButton
            app.ColorButton = uibutton(app.RenderAppTab, 'push');
            app.ColorButton.ButtonPushedFcn = createCallbackFcn(app, @ColorButtonPushed, true);
            app.ColorButton.Position = [26 94 100 22];
            app.ColorButton.Text = 'Color';

            % Create ColorLamp
            app.ColorLamp = uilamp(app.RenderAppTab);
            app.ColorLamp.Position = [143 95 20 20];

            % Create CellEditFieldLabel
            app.CellEditFieldLabel = uilabel(app.RenderAppTab);
            app.CellEditFieldLabel.HorizontalAlignment = 'right';
            app.CellEditFieldLabel.Position = [26 12 26 22];
            app.CellEditFieldLabel.Text = 'Cell';

            % Create CellEditField
            app.CellEditField = uieditfield(app.RenderAppTab, 'numeric');
            app.CellEditField.Position = [67 12 100 22];

            % Create RenderAppPlot
            app.RenderAppPlot = uiaxes(app.RenderAppTab);
            app.RenderAppPlot.View = [20 45];
            app.RenderAppPlot.Projection = 'perspective';
            app.RenderAppPlot.PlotBoxAspectRatio = [1.01450447669729 1.00193353653608 1];
            app.RenderAppPlot.XGrid = 'on';
            app.RenderAppPlot.YGrid = 'on';
            app.RenderAppPlot.ZGrid = 'on';
            app.RenderAppPlot.Position = [210 33 429 381];

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