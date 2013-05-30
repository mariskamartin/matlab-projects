function varargout = TodoGui(varargin)
% TODOGUI MATLAB code for TodoGui.fig
%      TODOGUI, by itself, creates a new TODOGUI or raises the existing
%      singleton*.
%
%      H = TODOGUI returns the handle to a new TODOGUI or the handle to
%      the existing singleton*.
%
%      TODOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TODOGUI.M with the given input arguments.
%
%      TODOGUI('Property','Value',...) creates a new TODOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TodoGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TodoGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TodoGui

% Last Modified by GUIDE v2.5 30-May-2013 21:37:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TodoGui_OpeningFcn, ...
                   'gui_OutputFcn',  @TodoGui_OutputFcn, ...
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


% --- Executes just before TodoGui is made visible.
function TodoGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TodoGui (see VARARGIN)

% Choose default command line output for TodoGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TodoGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TodoGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in todosListbox.
function todosListbox_Callback(hObject, eventdata, handles)
% hObject    handle to todosListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns todosListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from todosListbox


% --- Executes during object creation, after setting all properties.
function todosListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to todosListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
listbox = ListboxAdapter(handles.todosListbox);
todoText = inputdlg('ukol:','Novy ukol');
listbox.addString(char(todoText));
for k = 2:2:10
    listbox.addString(['for ' num2str(k)]);
end


% --- Executes on button press in getButton.
function getButton_Callback(hObject, eventdata, handles)
% hObject    handle to getButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
listbox = ListboxAdapter(handles.todosListbox);
msgbox(listbox.getSelectedString());


% --- Executes on button press in pushButton.
function pushButton_Callback(hObject, eventdata, handles)
% hObject    handle to pushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
listbox = ListboxAdapter(handles.todosListbox);
listbox.pushString('test',1);


% --- Executes on button press in delkaButton.
function delkaButton_Callback(hObject, eventdata, handles)
% hObject    handle to delkaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
listbox = ListboxAdapter(handles.todosListbox);
msgbox(num2str(listbox.getLength()));
