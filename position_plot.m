function [] = position_plot(data,sel,type)
    % [] = POSITION_PLOT(data,sel,type)
    % data - given struct array 
    % sel - struct with fields:
        %.trial - range or single trial value
        %.angle - range or single angle value    
    % type - string argument: 
        % '2d' - displays X,Y dimensions
        % '3d' - displays X,Y,Z dimensions
    
    for i = 1:1:length(sel.trial)
        for j = 1:1:length(sel.angle)
            plot_data = data(i,j).handPos;
            
            if strcmpi(type,'2d')
                figure;
                hold on;
                plot(plot_data(1,:),plot_data(2,:),'LineWidth',2);
                set(gca,'FontSize',15);
                grid on;
                xlabel('$x$ [mm]','FontSize',20);
                ylabel('$y$ [mm]','FontSize',20); 
            elseif strcmpi(type,'3d')
                figure;
                hold on;
                plot3(plot_data(1,:),plot_data(2,:),plot_data(3,:),'LineWidth',2);
                set(gca,'FontSize',15);
                grid on;
                xlabel('$x$ [mm]','FontSize',20);
                ylabel('$y$ [mm]','FontSize',20); 
                zlabel('$z$ [mm]','FontSize',20); 
            else
                error('Invalid selection: type must be *2d* or *3d*');
            end
        end
    end
    
end

