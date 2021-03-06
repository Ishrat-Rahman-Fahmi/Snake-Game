% Phillip Ngo
% Classic Snake Game

function snake_gui(command_str) 

if nargin < 1
    command_str = 'initialize';
end

%% Initialize GUI
if strcmp(command_str, 'initialize') 
    
    clear, close all
    
    %% Initial Settings
    
    handles.snakeColor = 'black';
    handles.pointColor = 'black';
    handles.wallColor = 'black';
    handles.baseSpeed = .06;
    handles.speed = handles.baseSpeed;
    handles.markerSize = 30;
    handles.walls = true;
    
    %% Create Figure
    
    screensize = get(0, 'screensize');
    screensize = screensize(3:4);
    figureX = 960; %% change this value to change gui size. keep same X/Y ratio
    figureY = 700; %% change this value to change gui size. keep same X/Y ratio
    fig = figure(                              ...
        'position', [(screensize(1)-figureX)/2 ...
                     (screensize(2)-figureY)/2 ...
                     figureX figureY],         ...
        'name','Snake',                        ...
        'visible', 'off',                      ...
        'MenuBar','none',                      ...
        'color', [0.5625 0.9297 0.5625],       ...
        'resize', 'off');
    
    %% Create Axes
    
    handles.axes = axes(                         ...
        'units', 'pixels',                       ...
        'position', [5 5 figureY-10 figureY-10]);
    plot([-10 10 10 -10 -10], [-10 -10 10 10 -10], 'k-', 'LineWidth', 10, 'Color', handles.wallColor)

    %% Create Title and Author Texts
    
    titleText = uicontrol(fig,                     ...
        'style', 'text',                           ...
        'position', [figureX - 230 figureY - 105   ...
                    195 100],                      ...
        'string', 'Snake',                         ...
        'fontsize', 50,                            ...
        'fontangle', 'italic',                     ...
        'backgroundcolor', [0.5625 0.9297 0.5625]);
    
    authorText = uicontrol(fig,                    ...
        'style', 'text',                           ...
        'position', [figureX-80 -80                ...
                    100 100],                      ...
        'string', 'Phillip Ngo',                   ...
        'fontangle', 'italic',                     ...
        'fontsize', 8,                             ...
        'backgroundcolor', [0.5625 0.9297 0.5625]);
    
    %% Create Play Button
    
    handles.playButton = uicontrol(fig,            ...
        'Style', 'pushbutton',                     ...
        'position', [figureX/1.33 5+figureX/1.6-75 ...
                     215 75],                      ...
        'string', 'Play!',                         ...
        'fontsize', 30,                            ...
        'callback', 'snake_gui(''play'')');
    
    %% Create Themes DropDown and Text
    
    handles.themesMenu = uicontrol(fig,       ...
        'Style', 'popupmenu',                 ...
        'position', [figureX/1.33 figureY-725 ...
                      215 75],                ...
        'String', {'Jungle'                   ...
                   'Galactic'                 ...
                   'Hello Kitty'              ...
                   'Fire'                     ...
                   'Sky'},                    ...
        'fontsize', 12,                       ...
        'callback', 'snake_gui(''themes'')');
    
    themesText = uicontrol(fig,                    ...
        'Style', 'text',                           ...
        'position', [figureX/1.33 figureY-650      ...
                     100 30],                      ...
        'backgroundcolor', [0.5625 0.9297 0.5625], ...
        'String', 'Themes:',                       ...
        'fontsize', 18);

    %% Create Difficulty Dropdown and Text
    
    handles.difficultyMenu = uicontrol(fig,       ...
        'Style', 'popupmenu',                     ...
        'position', [figureX/1.33 figureY-400     ...
                      215 75],                    ...
        'String', {'Slow'                         ...
                   'Normal'                       ...
                   'Fast'                         ...
                   'Extreme'},                    ...
        'Value', 2,                               ...
        'fontsize', 12,                           ...
        'callback', 'snake_gui(''speed'')');
    
    difficultyText = uicontrol(fig,                ...
        'Style', 'text',                           ...
        'position', [figureX/1.33 figureY-325      ...
                     100 30],                      ...
        'backgroundcolor', [0.5625 0.9297 0.5625], ...
        'String', 'Difficulty:',                   ...
        'fontangle', 'italic',                     ...
        'fontsize', 18);

    %% Create 'Large Board' Checkbox
    
    handles.largeBoard = uicontrol(fig,            ...
        'Style', 'checkbox',                       ...
        'Position', [figureX/1.33 figureY-385      ...
                     100 30],                      ...
        'String', 'Large Board',                   ...
        'BackgroundColor', [0.5625 0.9297 0.5625], ...
        'fontsize', 10,                            ...
        'callback', 'snake_gui(''large board'')');
    
    %% Create 'No Walls' Checkbox
    
    handles.noWalls = uicontrol(fig,               ...
        'Style', 'checkbox',                       ...
        'Position', [figureX/1.15 figureY-385      ...
                     100 30],                      ...
        'String', 'No Walls',                      ...
        'BackgroundColor', [0.5625 0.9297 0.5625], ...
        'fontsize', 10,                            ...
        'callback', 'snake_gui(''no walls'')');
    
    %% Create Length Title and Text
    
    handles.lengthText = uicontrol(fig,            ...
        'Style', 'text',                           ...
        'Position', [figureX/1.23 figureY-230      ...
                     100 40],                      ...
        'String', '-',                             ...
        'BackgroundColor', [0.5625 0.9297 0.5625], ...
        'fontsize', 30);
    
    lengthTitle = uicontrol(fig,                   ...
        'Style', 'text',                           ...
        'Position', [figureX/1.23 figureY-275      ...
                     100 35],                      ...
        'String', 'Length',                        ...
        'BackgroundColor', [0.5625 0.9297 0.5625], ...
        'fontsize', 20);
    
    %% Create Array of Static Texts and Color Variables
    
    handles.staticTexts = [titleText authorText themesText difficultyText handles.largeBoard ...
                           handles.lengthText lengthTitle handles.noWalls];
    
    %% Save handles and make GUI visible
    
    set(fig, 'userdata', handles)
    set(fig, 'visible', 'on')

%% Play Callback
elseif strcmp(command_str, 'play') 
    hold on
    snake = [0 0];
    set(gcf,'CurrentCharacter', 'i')
    direction = 'i';
    gameover = false;
    point = randomPoint(snake);
    %time = []; % for testing loop spped
    while (~gameover)
        %tic % for testing loop speed
        cla
        handles = get(gcf, 'userdata');
        set(handles.lengthText, 'String', num2str(length(snake(:, 1))));
        plot(snake(:, 1), snake(:, 2), 'ks', 'markersize', handles.markerSize, 'linewidth', 2, 'color', handles.snakeColor)
        plot(point(1), point(2), 'ks', 'markersize', handles.markerSize, 'linewidth', 2, 'color', handles.pointColor)
        plot([-10 10 10 -10 -10], [-10 -10 10 10 -10], 'k-', 'LineWidth', 10, 'Color', handles.wallColor)
        if checkCollision(snake, point)
            point = randomPoint(snake);
            snake = growSnake(snake);
        end
        direction = getDirection(snake, direction);
        snake = move(snake, direction);
        gameover = gamestate(snake);
        pause(handles.speed)
        if isempty(findall(0, 'Type', 'Figure')) % exits loop if user closes the GUI
            break;
        end
        %time(length(time)+1) = toc; % for testing loop speed
    end
    %sum(time)/length(time) % the average time for one loop
    
%% Themes Callback    
elseif strcmp(command_str, 'themes')
    handles = get(gcf, 'userdata');
    theme = get(handles.themesMenu, 'String');
    theme = theme(get(handles.themesMenu, 'Value'));
    switch theme{1}
        case 'Jungle'
            figureColor = [0.5625 0.9297 0.5625];
            axesColor = [0.8750 1.0000 1.0000];
            textColor = 'black';
            handles.snakeColor = 'black';
            handles.pointColor = 'black';
            handles.wallColor = 'black';
        case 'Galactic'
            figureColor = 'black';
            axesColor = 'black';
            textColor = 'green';
            handles.snakeColor = 'red';
            handles.pointColor = 'blue';
            handles.wallColor = 'green';
        case 'Hello Kitty'
            figureColor = [1 .4102 .7031];
            axesColor = [0.9 0.9 0.9792];
            textColor = 'yellow';
            handles.snakeColor = [1 0 1];
            handles.pointColor = [0.8594 0.0781 0.2344];
            handles.wallColor = 'yellow';
        case 'Fire'
            figureColor = [0.4500 0 0];
            axesColor = [.5430 0 0];
            textColor = [1 .5469 0];
            handles.snakeColor = [1 .2695 0];
            handles.pointColor = 'red';
            handles.wallColor = [1 .5469 0];
        case 'Sky'
            figureColor = [.1172 .5625 1];
            axesColor = [0.5273 0.8047 0.9180];
            textColor = 'white';
            handles.snakeColor = [0 0 .8008];
            handles.pointColor = [0 0 .8008];
            handles.wallColor = 'white';
    end
    for i = 1:length(handles.staticTexts)
        set(handles.staticTexts(i), 'BackgroundColor', figureColor, ...
            'ForegroundColor', textColor);
    end
    set(gcf, 'color', figureColor)
    plot([-10 10 10 -10 -10], [-10 -10 10 10 -10], 'k-', 'LineWidth', 10, 'Color', handles.wallColor)
    set(handles.axes, 'color', axesColor)  
    set(gcf, 'userdata', handles)
  
%% Difficulty Menu Callback
elseif strcmp(command_str, 'speed')
    handles = get(gcf, 'userdata');
    theme = get(handles.difficultyMenu, 'String');
    theme = theme(get(handles.difficultyMenu, 'Value'));
    
    switch theme{1}
        case 'Slow'
            handles.speed = handles.baseSpeed + .02;
        case 'Normal'
            handles.speed = handles.baseSpeed;
        case 'Fast'
            handles.speed = handles.baseSpeed - .02;
        case 'Extreme'
            handles.speed = handles.baseSpeed - .03;
    end
    set(gcf, 'userdata', handles)
    
%% Large Board Callback
elseif strcmp(command_str, 'large board')
    handles = get(gcf, 'userdata');
    if get(handles.largeBoard, 'value') == 1
        handles.baseSpeed = .04;
        handles.markerSize = 15;
    else
        handles.baseSpeed = .06;
        handles.markerSize = 30;
    end
    set(gcf, 'userdata', handles);
    
%% No Walls Callback
elseif strcmp(command_str, 'no walls')
    handles = get(gcf, 'userdata');
    handles.walls = ~handles.walls;
    set(gcf, 'userdata', handles)
    
end % End of GUI initialization and callbacks


%%% PLAY METHODS - Helper Methods for Play Callback

%% moves the snake in the given direction
function snake = move(snake, direction)
    handles = get(gcf, 'userdata');
    if get(handles.largeBoard, 'Value') == 1
        increment = .5;
    else
        increment = 1;
    end
    if length(snake(:,1)) ~= 1
        for i = length(snake(:,1)):-1:2
            snake(i, 1) = snake(i-1, 1);
            snake(i, 2) = snake(i-1, 2);
        end
    end
    switch direction 
        case 30
            snake(1, 2) = snake(1, 2) + increment;
        case 28
            snake(1, 1) = snake(1, 1) - increment;
        case 31
            snake(1, 2) = snake(1, 2) - increment;
        case 29
            snake(1, 1) = snake(1, 1) + increment;
    end
    if ~handles.walls
        if snake(1, 2) >= 10
            snake(1, 2) = -10 + increment;
        elseif snake(1, 2) <= -10
            snake(1, 2) = 10 - increment;
        elseif snake(1, 1) >= 10
            snake(1, 1) = -10 + increment;
        elseif snake(1, 1) <= -10
            snake(1, 1) = 10 - increment;
        end
    end

%% adds three blocks to the snake length
function snake = growSnake(snake)
    for i = 1:3
        snake(length(snake(:, 1))+1, 1) = snake(length(snake(:, 1)), 1);
        snake(length(snake(:, 2)), 2) = snake(length(snake(:, 2))-1, 2);
    end

%% checks if the snake is in contact with wall or itself
function state = gamestate(snake)
    state = false;
    if snake(1, 2) == 10 || snake(1, 1) == 10 || ...
       snake(1, 2) == -10 || snake(1, 1) == -10
        state = true;
    end
    
    if length(snake(:,1)) ~= 1 && ...
       contains([snake(2:length(snake(:,1)), 1) snake(2:length(snake(:,2)), 2)], [snake(1,1) snake(1,2)])
        state = true;
    end

%% generates a random point on the grid that is not in snake
function point = randomPoint(snake)
    handles = get(gcf, 'userdata');
    if get(handles.largeBoard, 'Value') == 1
        values = [-.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 ...
                   -9 -9.5 0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5];
    else
        values = [-1 -2 -3 -4 -5 -6 -7 -8 -9 0 1 2 3 4 5 6 7 8 9];
    end

    point(1) = values(randi(length(values)));
    point(2) = values(randi(length(values)));
    while contains(snake, point) 
        point(1) = values(randi(length(values)));
        point(2) = values(randi(length(values)));
    end
    
%% looks at keyboard input for the direction of the snake
function direction = getDirection(snake, currentDirection)
    set(gcf, 'KeyPressFcn', @(x,y)get(gcf,'CurrentCharacter'))
    direction = get(gcf, 'CurrentCharacter');
    
    if isempty(direction) || (direction ~= 28 && direction ~= 29 && direction ~= 30 && direction ~= 31)
        direction = currentDirection;
    end
    
    if length(snake(:,1)) ~= 1 && direction ~= currentDirection
        if currentDirection == 30 && direction == 31
            direction = 30;
        elseif currentDirection == 31 && direction == 30
            direction = 31;
        elseif currentDirection == 28 && direction == 29
            direction = 28;
        elseif currentDirection == 29 && direction == 28
            direction = 29;
        end
    end

%% checks if the head of the snake is colliding with the given point
function state = checkCollision(snake, point)
    state = false;
    if snake(1, 2) == point(2) && snake(1, 1) == point(1)
        state = true;
    end

%% checks if a given point is within the snake
function state = contains(snake, point)
    state = false;
    for i = 1:length(snake(:,1))
        if snake(i, 1) == point(1) && snake(i, 2) == point(2)
            state = true;
            return
        end
    end
