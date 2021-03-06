function varargout = tcp(varargin)
% TCP M-file for tcp.fig
%      TCP, by itself, creates a new TCP or raises the existing
%      singleton*.
%
%      H = TCP returns the handle to a new TCP or the handle to
%      the existing singleton*.
%
%      TCP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TCP.M with the given input arguments.
%
%      TCP('Property','Value',...) creates a new TCP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tcp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tcp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tcp

% Last Modified by GUIDE v2.5 07-Feb-2014 10:50:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tcp_OpeningFcn, ...
                   'gui_OutputFcn',  @tcp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before tcp is made visible.
function tcp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tcp (see VARARGIN)

% Choose default command line output for tcp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tcp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = tcp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in method_menu.
function method_menu_Callback(hObject, eventdata, handles)
% hObject    handle to method_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method_menu


% --- Executes during object creation, after setting all properties.
function method_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in period_menu.
function period_menu_Callback(hObject, eventdata, handles)
% hObject    handle to period_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns period_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from period_menu


% --- Executes during object creation, after setting all properties.
function period_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to period_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in simulate_button.
function simulate_button_Callback(hObject, eventdata, handles)
% hObject    handle to simulate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('simulate.\n');
% get period
val = get(handles.period_menu,'Value');
string_list = get(handles.period_menu,'String');
% Convert from cell array to string
selected_string = string_list{val}; 
period = str2double(selected_string);
fprintf('period:%d\n',period);
% get linkCapacity
linkCapacity = str2double(get(handles.capacity_edit,'String'));
if isnan(linkCapacity)
    linkCapacity = 1250;
    set(handles.capacity_edit,'String',num2str(linkCapacity));
end
fprintf('linkCapacity:%d\n',linkCapacity);
% get desired queue length
desiredQueueLength = str2double(get(handles.qLen_edit,'String'));
if isnan(desiredQueueLength)
    desiredQueueLength = 150;
    set(handles.qLen_edit,'String',num2str(desiredQueueLength));
end
fprintf('desiredQueueLength:%d\n',desiredQueueLength);
% get maximum queue length
maxQueueLength = str2double(get(handles.maxQLen_edit,'String'));
if isnan(maxQueueLength)
    maxQueueLength = 1000;
    set(handles.maxQLen_edit,'String',num2str(maxQueueLength));
end
fprintf('maxQueueLength:%d\n',maxQueueLength);
% get number of flows
numberOfFlows = str2double(get(handles.numberOfFlows_edit,'String'));
if isnan(numberOfFlows)
    numberOfFlows = 150;
    set(handles.numberOfFlows_edit,'String',num2str(numberOfFlows));
end
fprintf('numberOfFlows:%d\n',numberOfFlows);
% get AQM method type
method = get(handles.method_menu,'Value');
if method == 1
    fprintf('method:%d -> NONE\n',method);
    % simulate RED
    [finalT,finalX,integralAbsoluteError] = simulateNone(0.0,period,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows);
elseif method == 2
    fprintf('method:%d -> Random Early Detection\n',method);
    % simulate RED
    [finalT,finalX,integralAbsoluteError] = simulateRED(0.0,period,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows);
elseif method == 3
    fprintf('method:%d -> Proportional Integral Derivative Controller\n',method);
    % get Kp
    Kp = str2double(get(handles.kp_edit,'String'));
    if isnan(Kp)
        Kp = 1.0e-5;
        set(handles.kp_edit,'String',num2str(Kp));
    end
    % get Ki
    Ki = str2double(get(handles.ki_edit,'String'));
    if isnan(Ki)
        Ki = 1.0e-5;
        set(handles.ki_edit,'String',num2str(Ki));
    end
    % get Kd
    Kd = str2double(get(handles.kd_edit,'String'));
    if isnan(Kd)
        Kd = 1.0e-5;
        set(handles.kd_edit,'String',num2str(Kd));
    end
    % simulate PID
    [finalT,finalX,integralAbsoluteError] = simulatePID(0.0,period,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,Kp,Ki,Kd);
else
    % no simulation, error case!
    fprintf('method:%d -> Unknown!\n',method);
end
% plot the results here
cla;
hold on;
grid on;
plot(handles.output_axes,finalT,finalX(:,1),'b-');
plot(handles.output_axes,finalT,finalX(:,2),'r-');
errX = desiredQueueLength-finalX(:,1);
plot(handles.output_axes,finalT,errX,'k-');
offset = 2;
plot(handles.output_axes,finalT,finalX(:,offset+1:numberOfFlows),'g-');
J = 1/(1+integralAbsoluteError);
if method == 1
    str = sprintf('NONE (J = 1/(1+IAE) = %d)',J);
elseif method == 2
    str = sprintf('RED (J = 1/(1+IAE) = %d)',J);
elseif method == 3
    str = sprintf('PID (J = 1/(1+IAE) = %d)\n(KP:%d KI:%d KD:%d) ',J,Kp,Ki,Kd);
end
title(str);
ylabel (handles.output_axes,'size (packets)')
xlabel (handles.output_axes,'time (secs)')
legend(handles.output_axes,'Estimated Avg. Q. Len.','Avg. Q. Len.','Error','Flow Window Size');


function capacity_edit_Callback(hObject, eventdata, handles)
% hObject    handle to capacity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of capacity_edit as text
%        str2double(get(hObject,'String')) returns contents of capacity_edit as a double


% --- Executes during object creation, after setting all properties.
function capacity_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to capacity_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function qLen_edit_Callback(hObject, eventdata, handles)
% hObject    handle to qLen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qLen_edit as text
%        str2double(get(hObject,'String')) returns contents of qLen_edit as a double


% --- Executes during object creation, after setting all properties.
function qLen_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qLen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to kd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kd_edit as text
%        str2double(get(hObject,'String')) returns contents of kd_edit as a double


% --- Executes during object creation, after setting all properties.
function kd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ki_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ki_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ki_edit as text
%        str2double(get(hObject,'String')) returns contents of ki_edit as a double


% --- Executes during object creation, after setting all properties.
function ki_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ki_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to kp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp_edit as text
%        str2double(get(hObject,'String')) returns contents of kp_edit as a double


% --- Executes during object creation, after setting all properties.
function kp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberOfFlows_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfFlows_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfFlows_edit as text
%        str2double(get(hObject,'String')) returns contents of numberOfFlows_edit as a double


% --- Executes during object creation, after setting all properties.
function numberOfFlows_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfFlows_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberOfGenerations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfGenerations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfGenerations_edit as text
%        str2double(get(hObject,'String')) returns contents of numberOfGenerations_edit as a double


% --- Executes during object creation, after setting all properties.
function numberOfGenerations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfGenerations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function populationSize_edit_Callback(hObject, eventdata, handles)
% hObject    handle to populationSize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of populationSize_edit as text
%        str2double(get(hObject,'String')) returns contents of populationSize_edit as a double


% --- Executes during object creation, after setting all properties.
function populationSize_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to populationSize_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trainPID_button.
function trainPID_button_Callback(hObject, eventdata, handles)
% hObject    handle to trainPID_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('train.\n');
% get period
val = get(handles.period_menu,'Value');
string_list = get(handles.period_menu,'String');
% Convert from cell array to string
selected_string = string_list{val}; 
period = str2double(selected_string);
fprintf('period:%d\n',period);
% get linkCapacity
linkCapacity = str2double(get(handles.capacity_edit,'String'));
if isnan(linkCapacity)
    linkCapacity = 1250;
    set(handles.capacity_edit,'String',num2str(linkCapacity));
end
fprintf('linkCapacity:%d\n',linkCapacity);
% get desired queue length
desiredQueueLength = str2double(get(handles.qLen_edit,'String'));
if isnan(desiredQueueLength)
    desiredQueueLength = 150;
    set(handles.qLen_edit,'String',num2str(desiredQueueLength));
end
fprintf('desiredQueueLength:%d\n',desiredQueueLength);
% get maximum queue length
maxQueueLength = str2double(get(handles.maxQLen_edit,'String'));
if isnan(maxQueueLength)
    maxQueueLength = 1000;
    set(handles.maxQLen_edit,'String',num2str(maxQueueLength));
end
fprintf('maxQueueLength:%d\n',maxQueueLength);
% get number of flows
numberOfFlows = str2double(get(handles.numberOfFlows_edit,'String'));
if isnan(numberOfFlows)
    numberOfFlows = 150;
    set(handles.numberOfFlows_edit,'String',num2str(numberOfFlows));
end
fprintf('numberOfFlows:%d\n',numberOfFlows);
% get number of generations
numberOfGenerations = str2double(get(handles.numberOfGenerations_edit,'String'));
if isnan(numberOfGenerations)
    numberOfGenerations = 5;
    set(handles.numberOfGenerations_edit,'String',num2str(numberOfGenerations));
end
fprintf('numberOfGenerations:%d\n',numberOfGenerations);
% get populationSize
populationSize = str2double(get(handles.populationSize_edit,'String'));
if isnan(populationSize)
    populationSize = 20;
    set(handles.populationSize_edit,'String',num2str(populationSize));
end
fprintf('populationSize:%d\n',populationSize);
% get Uj
Uj = str2double(get(handles.uj_edit,'String'));
if isnan(Uj)
    Uj = 1.0e-3;
    set(handles.uj_edit,'String',num2str(Uj));
end
fprintf('Uj:%d\n',Uj);
% get Lj
Lj = str2double(get(handles.lj_edit,'String'));
if isnan(Lj)
    Lj = 1.0e-4;
    set(handles.lj_edit,'String',num2str(Lj));
end
fprintf('Lj:%d\n',Lj);

[kp,ki,kd] = pidGenetic(0.0,period,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,populationSize,numberOfGenerations,Uj,Lj);
set(handles.kp_edit,'String',num2str(kp));
set(handles.ki_edit,'String',num2str(ki));
set(handles.kd_edit,'String',num2str(kd));



function maxQLen_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxQLen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxQLen_edit as text
%        str2double(get(hObject,'String')) returns contents of maxQLen_edit as a double


% --- Executes during object creation, after setting all properties.
function maxQLen_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxQLen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lj_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lj_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lj_edit as text
%        str2double(get(hObject,'String')) returns contents of lj_edit as a double


% --- Executes during object creation, after setting all properties.
function lj_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lj_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uj_edit_Callback(hObject, eventdata, handles)
% hObject    handle to uj_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uj_edit as text
%        str2double(get(hObject,'String')) returns contents of uj_edit as a double


% --- Executes during object creation, after setting all properties.
function uj_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uj_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
