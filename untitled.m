function varargout = untitled(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

handles.ROOT = varargin{1}.root;
handles.im_folder = varargin{1}.im_folder;
handles.maskim_folder = varargin{1}.maskim_folder;
handles.list = varargin{2};
handles.image_id = varargin{3};
handles.maskim_id = varargin{4};

guidata(hObject, handles);

update(handles);
% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label = 0;
set(handles.text5, 'String', ['current segment label: ' num2str(handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label)]);
guidata(hObject, handles);

% --- Executes on button press in button2.
function button2_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label = 1;
set(handles.text5, 'String', ['current segment label: ' num2str(handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label)]);
guidata(hObject, handles);

% --- Executes on button press in button3.
function button3_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label = 2;
set(handles.text5, 'String', ['current segment label: ' num2str(handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label)]);
guidata(hObject, handles);

% --- Executes on button press in button4.
function button4_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label = 3;
set(handles.text5, 'String', ['current segment label: ' num2str(handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label)]);
guidata(hObject, handles);


% --- Executes on button press in button5.
function button5_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.imgattr_label = 0;
set(handles.text6, 'String', ['current image label: ' num2str(handles.list{handles.image_id}.imgattr_label)]);
guidata(hObject, handles);

% --- Executes on button press in button6.
function button6_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.imgattr_label = 1;
set(handles.text6, 'String', ['current image label: ' num2str(handles.list{handles.image_id}.imgattr_label)]);
guidata(hObject, handles);


% --- Executes on button press in button7.
function button7_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.imgattr_label = 2;
set(handles.text6, 'String', ['current image label: ' num2str(handles.list{handles.image_id}.imgattr_label)]);
guidata(hObject, handles);


% --- Executes on button press in button8.
function button8_Callback(hObject, eventdata, handles)
handles.list{handles.image_id}.imgattr_label = 3;
set(handles.text6, 'String', ['current image label: ' num2str(handles.list{handles.image_id}.imgattr_label)]);
guidata(hObject, handles);


function buttonPrev_Callback(hObject, eventdata, handles)
handles.maskim_id = handles.maskim_id-1;
if handles.maskim_id>0
    update(handles);
else
    if handles.image_id>1
        handles.image_id = handles.image_id-1;
        handles.maskim_id = handles.list{handles.image_id}.obj_num;
        update(handles);
    else
        handles.maskim_id = 1;
    end
end
guidata(hObject, handles);

% --- Executes on button press in buttonNext.
function buttonNext_Callback(hObject, eventdata, handles)
handles.maskim_id = handles.maskim_id+1;
if handles.maskim_id<=handles.list{handles.image_id}.obj_num
    update(handles);
else
    flag = 0;
    for i=1:handles.list{handles.image_id}.obj_num
        if ~isfield(handles.list{handles.image_id}.mask_obj{i}, 'attr_label')
            flag = 1;
        end
    end
    if ~isfield(handles.list{handles.image_id}, 'imgattr_label') | flag==1
        if flag==1
            msgbox('You miss answering part of the question 2.', 'warn');
        else
            msgbox('You miss answering the question 1.', 'warn');
        end
        handles.maskim_id = handles.maskim_id-1;
    else
        if handles.image_id<length(handles.list)
            handles.maskim_id = 1;
            handles.image_id = handles.image_id+1;
            update(handles);
        else
            handles.maskim_id = handles.list{handles.image_id}.obj_num;
        end
    end
end
guidata(hObject, handles);

% --- Executes on button press in buttonsave.
function buttonsave_Callback(hObject, eventdata, handles)
% keyboard
list = handles.list;
image_id = handles.image_id;
maskim_id = handles.maskim_id;
if handles.image_id == length(handles.list)
    save labeldata.mat list image_id maskim_id;
    save labeldata_tmp.mat list image_id maskim_id;
else
    save labeldata_tmp.mat list image_id maskim_id;
end
guidata(hObject, handles);


function update(handles)
    set(handles.text1, 'String', [num2str(handles.image_id) '/' num2str(length(handles.list))]);
    set(handles.text2, 'String', [num2str(handles.maskim_id) '/' num2str(handles.list{handles.image_id}.obj_num)]);
    set(handles.text3, 'String', handles.list{handles.image_id}.name);
    set(handles.text4, 'String', ['current segment_id(1:car, 2:bike, 3:human): ' num2str(handles.list{handles.image_id}.mask_obj{handles.maskim_id}.class)]);
    if ~isfield(handles.list{handles.image_id}.mask_obj{handles.maskim_id}, 'attr_label')
        set(handles.text5, 'String', 'current segment label: non');
    else
        set(handles.text5, 'String', ['current segment label: ' num2str(handles.list{handles.image_id}.mask_obj{handles.maskim_id}.attr_label)]);
    end
    if ~isfield(handles.list{handles.image_id}, 'imgattr_label')
        set(handles.text6, 'String', 'current image label: non');
    else
        set(handles.text6, 'String', ['current image label: ' num2str(handles.list{handles.image_id}.imgattr_label)]);
    end
    axes(handles.axes1);     
    imshow(imread([handles.ROOT handles.im_folder handles.list{handles.image_id}.name]));     
    axes(handles.axes2);     
    imshow(imread([handles.ROOT handles.maskim_folder handles.list{handles.image_id}.mask_obj{handles.maskim_id}.name]));

