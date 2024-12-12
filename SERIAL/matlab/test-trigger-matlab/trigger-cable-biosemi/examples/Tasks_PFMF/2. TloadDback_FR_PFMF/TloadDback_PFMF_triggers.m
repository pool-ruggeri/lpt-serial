
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   TloadDback Borragan & Slama&Peigneux      %%%
%%%%%%%%               TASK              %%%%%%%%%%%
%%%%%%%%%%%% Borragan, G. 15/07/2013% %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% "Most people say that it is the intellect which makes a great scientist. They are wrong: it is character. " Albert Einstein


% ========================================================================
% 1. INITIALIZING..
% ========================================================================

clear all
close all

% Data folders
mkdir('Results_TloadDback_R_given')
mkdir('Results_TloadDback_Performance')
mkdir('Results_TloadDback_Performance_Type_answer')
mkdir('Results_TloadDback_Performance_RTs')
mkdir('Results_TloadDback_Performance_Time')

% Setting some Matlab parameters
dataNum=[]; % pour enregistrement des data numeriques Test Block
dataNum2=[]; % pour enregistrement des data numeriques Chart
dataStr={}; % pour enregistrement des data string

% Correction randomization
rand('state',sum(100*clock));

% ========================================================================
% 2. METADATA
% ========================================================================

Subject = input('Quel est le nom/code du participant ?  ','s') ;
Subject_number = input('Introduire son numéro ? :','s') ;
Age = input('Âge? :  ', 's');
Sex = input('Homme(1) or Femme(2) :  ', 's');
Cond = input('HCL','s'); % see Borragán & Slama,2017.
STD = input('Insérer la STD du participant avec les décimales (e.g. 0.9, 1.2): ');

% Creating individual datafiles for the different results
Resultat = ['Results_TloadDback_R_given/TloadDback_REPONSES_TASK_' Subject '' Cond '.txt'] ;   % R given
Resultat2 = ['Results_TloadDback_Performance/TloadDback_PERFORMANCE_TASK_' Subject '' Cond '.txt'] ; % Performance
Resultat3 = ['Results_TloadDback_Performance_Type_answer/TloadDback_PERF_by_TofR_TASK_' Subject '' Cond '.txt'] ; % Performance by type of answer
Resultat4 = ['Results_TloadDback_Performance_RTs/TloadDback_RTs_TASK_' Subject '' Cond '.txt'] ; % RTs
Resultat5 = ['Results_TloadDback_Performance_Time/BEGXP_ENDXP_' Subject '' Cond '.txt'] ; % Beggining - End experiment

% Checking whether the datafile already exists
if exist(Resultat,'file')
    Attention = input('Attention ! Le fichier de données existe déjà. Voulez-vous le réécrire ?  [oui] [non] :  ', 's') ;
    if ~strcmp(Attention,'oui')
        disp('Experiment aborted') ;
        return
    end
end

% Preparing datafiles outputs
dataExp = [num2cell(dataNum),dataStr];
dataExp = dataExp';

Data = fopen(Resultat,'wt') ;
Data_Performance = fopen(Resultat2, 'wt');
Data_by_TofR = fopen(Resultat3, 'wt'); % Data type of answer/response
Data_RTs = fopen(Resultat4, 'wt');
Data_BEGXP_ENDXP = fopen(Resultat5, 'wt');

fprintf(Data, ['Subject' '\t', 'Subject_number' '\t', 'Age' '\t', 'Sex' '\t',  'Lettre Presentee' '\t', 'Chiffre Presentee' '\t', 'REPONSE_LETTRE' '\t', 'REPONSE_NUM1' '\n']);  % header Data
fprintf(Data_Performance, ['Subject' '\t', 'Subject_number' '\t','Age' '\t','Sex' '\t', 'PERFORMANCE' '\n']);  % header Data_Performance
fprintf(Data_by_TofR, ['Subject' '\t', 'Correct_answer' '\t', 'Correct_omSTDon' '\t', 'OmSTDon' '\t', 'FAs' '\t','Correct_answerNUM' '\n']);
fprintf(Data_RTs, ['Subject' '\t', 'Answer_Letter' '\t','Given_Letter' '\t','RTs_Letter' '\t','Given_Num' '\t', 'RTs_Num' '\n']);  % header RTs
fprintf(Data_BEGXP_ENDXP, ['Subject' '\t', 'Time_Hour' '\n']);

% define things for biosemi trigger cable 
port_num = input('Quel numero de port com pour le trigger ','s') ;
port = ['COM',port_num];
usb = serial(port,'BaudRate',115200,'DataBits',8, 'StopBits', 1, 'Parity', 'none');
get(usb);
fopen(usb);

% rectangle white on tr screen
baseRect = [0 0 70 70];
newRect = CenterRectOnPoint([0 0 70 70],1920-70/2,70/2); % put it on top right
flag_black_screen = 0;
%% SOME INSTRUCCTIONS:

% Correct answer = press when you have to  /  100 = perfect
% Correct omSTDon = no press when you dont have to / 100 = perfect
% OmSTDon = NO press when you have to  / 0 = perfect ; no Om
% FAs = press when you DONT have to  / 0 = perfect ; no FAS

% when RTs = 100 --> R has been given at the very end of the interval; i.e,
% the closer the value is to 0, the faster the answer has been
% To compute RTs only on the correct answers
% for letters = REPONSE_SERIE(1,j) = REPONSE_LETTRE ---> take PERC_time_appuiLet
% for numbers = REPONSE_NUM1 = 1 ---> take PERC_time_appuiNum

% ========================================================================
% 3. PARAMETERS
% ========================================================================

%Opening PTB
Screen('Preference', 'Verbosity', 2); % Output for critical errors and warnings
Screen('Preference', 'SkipSyncTests', 1);
[w, wrect]=Screen('OpenWindow', 0,1);  % 0,1 = black screen --> consume less energy ;)

[width, height] = Screen('WindowSize', w);

cycleRefresh = Screen('GetFlipInterval',w);
display(cycleRefresh)

% Hiding mouse pointer and unifying keyboard in QWERTY
HideCursor;
KbName('UnifyKeyNames') ;

spaceKey = KbName('space'); escKey = KbName('ESCAPE');

% Measure the vertical refresh rate of the monitor
% ifi = Screen('GetFlipInterval', window); %framerate
% hz = Screen('NominalFrameRate', window); %refreshrate
% if hz ~= 60 %stop the program if the refreshrate is not 60 Hz!
%     disp('Display is not 60 Hz! Exit.')
%     sca
%     return
% end

% ========================================================================
% 4. INITIALIZATING EXPERIMENT
% ========================================================================

% Defining inital STD (Stimulus Time Duration)
STD = round(STD/cycleRefresh)*cycleRefresh; % To adapt the STD at the screen refreshing rate

% Definition of initial performance parameters
PERFORMANCE = 0.3;
trial = [];
items_num = [];
items_let = [];
ANSWER_LETTER_TYPE1 = [];     % press when have to press  70 % over 100% of ANSWER_LETTER
ANSWER_LETTER_TYPE2 = [];     % no press when do not have to press 30% over 100% of ANSWER_LETTER
PERFORMANCE_TOTAL = [];       % Total performance achieved in every 60 trials

%------------- INTRUCTIONS -------------%
consigne=imread('Instructions_1.bmp');
Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

consigne=imread('Instructions_2.bmp');
Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

consigne=imread('Instructions_3.bmp');
Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

% Initializing..
Priority(MaxPriority(w)) ;
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'PRÊT?','center','center',[255,255,255]);
DrawFormattedText(w, 'Appuyez sur une touche pour démarrer le test','center',500,[255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs (1);

% trigger onset task
fwrite(usb,10);

%%%%%%%%%%%%
%  BEG XP  %
%%%%%%%%%%%%

BEGXP = round(clock);

%%%%%%%%%%%%
% ONSET XP %
%%%%%%%%%%%%


%% 1-BACK combinaisons

series1         = [ 'L'  'A'  'A'  'R'  'N'  'N'  'R'  'T'  'E'  'E'  'N'  'U'  'N'  'N'  'N'  'P'  'P'  'R'  'E'  'E'  'T'  'U'  'T'  'R'  'R'  'A'  'L'  'L'  'P'  'P' ];%10/30
REPONSE_SERIES1 = [ '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1' ];%10/30

series2         = [ 'A'  'C'  'C'  'L'  'N'  'R'  'R'  'L'  'E'  'E'  'A'  'P'  'P'  'T'  'N'  'T'  'U'  'T'  'C'  'C'  'R'  'R'  'E'  'L'  'L'  'A'  'A'  'A'  'U'  'U' ];%10/30
REPONSE_SERIES2 = [ '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '1'  '0'  '1' ];%10/30

series3         = [ 'C'  'R'  'R'  'E'  'E'  'N'  'L'  'L'  'T'  'U'  'R'  'C'  'C'  'E'  'E'  'N'  'U'  'C'  'L'  'L'  'P'  'R'  'R'  'A'  'A'  'T'  'L'  'L'  'P'  'P' ];%10/30
REPONSE_SERIES3 = [ '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1' ];%10/30

series4         = [ 'N'  'N'  'E'  'L'  'L'  'C'  'U'  'C'  'C'  'R'  'L'  'P'  'P'  'A'  'A'  'N'  'R'  'R'  'L'  'U'  'U'  'L'  'C'  'E'  'C'  'C'  'P'  'P'  'N'  'N' ];%10/30
REPONSE_SERIES4 = [ '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1' ];%10/30

series5         = [ 'A'  'T'  'U'  'U'  'R'  'R'  'R'  'C'  'N'  'N'  'L'  'L'  'R'  'E'  'E'  'A'  'T'  'T'  'C'  'C'  'U'  'L'  'U'  'P'  'T'  'R'  'C'  'C'  'P'  'P' ];%10/30
REPONSE_SERIES5 = [ '0'  '0'  '0'  '1'  '0'  '1'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '1'  '0'  '1' ];%10/30

series6         = [ 'T'  'T'  'E'  'R'  'R'  'N'  'A'  'C'  'T'  'L'  'L'  'C'  'C'  'E'  'U'  'U'  'L'  'L'  'C'  'R'  'C'  'C'  'T'  'R'  'R'  'A'  'A'  'N'  'A'  'A' ];%10/30
REPONSE_SERIES6 = [ '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1' ];%10/30

series7         = [ 'L'  'C'  'C'  'E'  'E'  'A'  'C'  'L'  'L'  'U'  'R'  'N'  'N'  'P'  'A'  'T'  'P'  'P'  'C'  'C'  'U'  'U'  'L'  'E'  'R'  'R'  'T'  'T'  'A'  'A' ];%10/30
REPONSE_SERIES7 = [ '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1' ];%10/30

series8         = [ 'R'  'R'  'L'  'P'  'P'  'A'  'C'  'C'  'E'  'E'  'C'  'E'  'N'  'N'  'P'  'T'  'T'  'A'  'C'  'U'  'L'  'L'  'U'  'U'  'R'  'T'  'T'  'P'  'R'  'R' ];%10/30
REPONSE_SERIES8 = [ '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1' ];%10/30

series9         = [ 'U'  'L'  'L'  'A'  'T'  'T'  'E'  'E'  'R'  'R'  'R'  'C'  'C'  'R'  'A'  'U'  'U'  'A'  'A'  'L'  'P'  'P'  'C'  'U'  'R'  'R'  'T'  'E'  'U'  'N' ];%10/30
REPONSE_SERIES9 = [ '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0' ];%10/30

series10        = [ 'C'  'E'  'C'  'C'  'R'  'T'  'A'  'U'  'N'  'N'  'P'  'P'  'A'  'P'  'P'  'U'  'T'  'T'  'R'  'R'  'U'  'U'  'C'  'E'  'E'  'L'  'A'  'A'  'L'  'L' ];%10/30
REPONSE_SERIES10= [ '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1' ];%10/30

series11        = [ 'A'  'L'  'R'  'R'  'T'  'U'  'C'  'U'  'U'  'U'  'U'  'A'  'E'  'A'  'P'  'P'  'R'  'N'  'N'  'L'  'C'  'E'  'E'  'R'  'R'  'L'  'U'  'U'  'E'  'E' ];
REPONSE_SERIES11= [ '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '1'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1' ];%10/30

series12        = [ 'T'  'C'  'C'  'A'  'A'  'T'  'L'  'L'  'E'  'U'  'P'  'P'  'A'  'A'  'T'  'T'  'N'  'E'  'U'  'U'  'R'  'A'  'C'  'T'  'L'  'L'  'L'  'U'  'P'  'P' ];
REPONSE_SERIES12= [ '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '1'  '1'  '0'  '0'  '1' ];%10/30

series13        = [ 'A'  'A'  'R'  'R'  'T'  'U'  'U'  'E'  'E'  'N'  'P'  'A'  'A'  'A'  'P'  'T'  'T'  'T'  'N'  'N'  'C'  'E'  'N'  'N'  'P'  'L'  'U'  'C'  'C'  'C' ];
REPONSE_SERIES13= [ '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0' ];%10/30

series14        = [ 'E'  'E'  'T'  'A'  'U'  'U'  'T'  'R'  'R'  'R'  'L'  'L'  'U'  'E'  'T'  'P'  'P'  'A'  'L'  'P'  'A'  'A'  'C'  'A'  'A'  'C'  'C'  'N'  'R'  'R' ];
REPONSE_SERIES14= [ '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1' ];%10/30

series15        = [ 'U'  'C'  'R'  'R'  'C'  'C'  'L'  'N'  'N'  'U'  'U'  'R'  'A'  'A'  'T'  'L'  'L'  'E'  'U'  'U'  'R'  'A'  'C'  'T'  'T'  'N'  'N'  'U'  'U'  'E' ];
REPONSE_SERIES15= [ '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0' ];%10/30

series16         = [ 'U'  'T'  'L'  'L'  'A'  'C'  'C'  'A'  'E'  'E'  'R'  'C'  'R'  'R'  'P'  'P'  'N'  'A'  'T'  'T'  'N'  'U'  'U'  'E'  'N'  'N'  'N'  'A'  'C'  'C' ];%10/30
REPONSE_SERIES16 = [ '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '1'  '0'  '0'  '1' ];%10/30

series17         = [ 'E'  'E'  'U'  'A'  'A'  'R'  'R'  'N'  'P'  'N'  'E'  'E'  'T'  'E'  'T'  'T'  'C'  'A'  'A'  'T'  'C'  'C'  'T'  'R'  'R'  'L'  'E'  'N'  'N'  'L' ];%10/30
REPONSE_SERIES17 = [ '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '1' ];%10/30

series18         = [ 'T'  'C'  'C'  'T'  'C'  'A'  'E'  'E'  'N'  'N'  'R'  'P'  'P'  'A'  'A'  'U'  'A'  'A'  'C'  'T'  'T'  'L'  'C'  'C'  'E'  'E'  'T'  'C'  'C'  'R' ];%10/30
REPONSE_SERIES18 = [ '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0' ];%10/30

series19         = [ 'N'  'N'  'L'  'A'  'N'  'U'  'U'  'T'  'R'  'R'  'A'  'A'  'R'  'P'  'L'  'T'  'T'  'E'  'A'  'U'  'U'  'N'  'A'  'T'  'T'  'N'  'C'  'C'  'C'  'C' ];%10/30
REPONSE_SERIES19 = [ '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '1'  '1' ];%10/30

series20         = [ 'C'  'T'  'T'  'E'  'R'  'E'  'E'  'U'  'U'  'N'  'P'  'P'  'A'  'C'  'C'  'A'  'T'  'R'  'R'  'N'  'N'  'P'  'U'  'U'  'L'  'L'  'P'  'L'  'L'  'E' ];%10/30
REPONSE_SERIES20 = [ '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0' ];%10/30

series21         = [ 'T'  'N'  'N'  'N'  'P'  'P'  'T'  'C'  'A'  'R'  'A'  'A'  'A'  'R'  'R'  'U'  'L'  'R'  'A'  'A'  'T'  'T'  'L'  'A'  'L'  'L'  'P'  'N'  'N'  'E' ];
REPONSE_SERIES21 = [ '0'  '0'  '1'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '1'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0' ];%10/30

series22         = [ 'P', 'C', 'C', 'A', 'A', 'E', 'N', 'L', 'L', 'T', 'T', 'U', 'A', 'A', 'E', 'N', 'C', 'P', 'P', 'N', 'E', 'E', 'U', 'A', 'C', 'C', 'C', 'C', 'T', 'U' ];
REPONSE_SERIES22 = [ '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '1'  '1'  '0'  '0' ];%10/30

series23         = [ 'C', 'T', 'T', 'A', 'A', 'E', 'E', 'N', 'T', 'U', 'U', 'C', 'N', 'N', 'N', 'A', 'C', 'C', 'A', 'E', 'U', 'T', 'P', 'L', 'L', 'L', 'U', 'A', 'P', 'P'];
REPONSE_SERIES23 = [ '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '0'  '1'  '1'  '0'  '0'  '0'  '1' ];%10/30

series24         = [ 'E', 'E', 'P', 'P', 'C', 'U', 'U', 'A', 'C', 'U', 'P', 'P', 'A', 'A', 'T', 'N', 'U', 'L', 'L', 'L', 'T', 'N', 'C', 'C', 'E', 'E', 'L', 'A', 'A', 'T'];
REPONSE_SERIES24 = [ '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0' ];%10/30

series25         = [ 'C', 'N', 'N', 'N', 'A', 'U', 'U', 'L', 'L', 'T', 'A', 'A', 'C', 'P', 'P', 'L', 'L', 'P', 'P', 'U', 'U', 'A', 'A', 'L', 'E', 'C', 'L', 'T', 'A', 'N'];
REPONSE_SERIES25 = [ '0'  '0'  '1'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '0'  '0'  '0' ];%10/30

series26         = [ 'C', 'C', 'P', 'T', 'T', 'E', 'E', 'U', 'U', 'A', 'P', 'L', 'T', 'T', 'E', 'C', 'C', 'A', 'A', 'N', 'U', 'C', 'C', 'P', 'C', 'T', 'T', 'U', 'E', 'E'];
REPONSE_SERIES26 = [ '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '1' ];%10/30

series27         = [ 'U', 'T', 'T', 'A', 'E', 'P', 'P', 'L', 'T', 'L', 'L', 'C', 'A', 'N', 'E', 'E', 'A', 'U', 'U', 'N', 'P', 'P', 'P', 'L', 'N', 'T', 'T', 'T', 'P', 'P'];
REPONSE_SERIES27 = [ '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '1'  '0'  '0'  '0'  '1'  '1'  '0'  '1' ];%10/30

series28         = [ 'P', 'C', 'C', 'L', 'L', 'N', 'N', 'E', 'E', 'L', 'C', 'C', 'N', 'A', 'A', 'U', 'E', 'E', 'A', 'U', 'U', 'T', 'P', 'P', 'L', 'T', 'A', 'C', 'C', 'P'];
REPONSE_SERIES28 = [ '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0' ];%10/30

series29         = [ 'E', 'L', 'N', 'N', 'C', 'U', 'P', 'P', 'C', 'C', 'E', 'E', 'T', 'L', 'A', 'U', 'U', 'L', 'U', 'N', 'N', 'A', 'A', 'P', 'P', 'T', 'C', 'L', 'L', 'L'];
REPONSE_SERIES29 = [ '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '1' ];%10/30

series30         = [ 'A', 'C', 'T', 'U', 'N', 'P', 'P', 'E', 'E', 'C', 'U', 'A', 'A', 'A', 'P', 'P', 'C', 'C', 'T', 'N', 'U', 'U', 'E', 'E', 'P', 'E', 'T', 'T', 'C', 'C'];
REPONSE_SERIES30 = [ '0'  '0'  '0'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '1'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1'  '0'  '0'  '0'  '1'  '0'  '1' ];%10/30

% Draft to add more %%
% seriesx         = [ ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  ''  '' ];%10/30
% REPONSE_SERIESx = [ '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0' '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0'  '0' ];%10/30

%% LOOP of stimuli

% Variables Definition
RTsLet = [];
PERC_time_appui_TOTLet = [];
RTsNum = [];
PERC_time_appui_TOTNum = [];

% Calculating # of repetitions Aqui
REPE = round(300/STD); % the task duration vary slightly with the STD values

for repetition = 1:REPE
    
    % Stimuli parameters
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextSize', 120);
    Screen(w, 'TextStyle', 1);
    
    series_all = [series1;series2;series3;series4;series5;series6;series7;series8;series9;series10;series11;series12;series13;series14;series15;series16;series17;series18;series19;series20;series21;series22;series23;series24;series25;series26;series27;series28;series29;series30];
    
    % Randomization
    REPONSE_ALL = [REPONSE_SERIES1;REPONSE_SERIES2;REPONSE_SERIES3;REPONSE_SERIES4;REPONSE_SERIES5;REPONSE_SERIES6;REPONSE_SERIES7;REPONSE_SERIES8;REPONSE_SERIES9;REPONSE_SERIES10;REPONSE_SERIES11;REPONSE_SERIES12;REPONSE_SERIES13;REPONSE_SERIES14;REPONSE_SERIES15;REPONSE_SERIES16;REPONSE_SERIES17;REPONSE_SERIES18;REPONSE_SERIES19;REPONSE_SERIES20;REPONSE_SERIES21;REPONSE_SERIES22;REPONSE_SERIES23;REPONSE_SERIES24;REPONSE_SERIES25;REPONSE_SERIES26;REPONSE_SERIES27;REPONSE_SERIES28;REPONSE_SERIES29;REPONSE_SERIES30];
    randorder = randperm(30);
    series = series_all(randorder(1),:);
    REPONSE_SERIE = REPONSE_ALL(randorder(1),:);
    
    % Creating vectors for variables
    ANSWER_LETTER = [] ;
    ANSWER_NUMBER = [] ;
    REPONSE_LETTRE_CORR = [];
    
    %-------------------- Coding response Letters ---------------------%
    for j = 1:length(series)
        flag_black_screen = 0;
        DrawFormattedText(w,series(j), 'center', 'center',[255,255,255]);
        Screen('FillRect',w,[255,255,255],newRect)
        Screen(w,'Flip');
        
        % send trigger
        fwrite(usb,50);

        t= GetSecs;
        
        
        
        while GetSecs - t < STD
            
            
            if and(GetSecs - t > 0.4, flag_black_screen == 0)
                DrawFormattedText(w,series(j), 'center', 'center',[255,255,255]);
                Screen('FillRect',w,[0,0,0],newRect)
                Screen(w,'Flip');
                flag_black_screen = 1;
            end
            
            
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(0);
            if keyIsDown ==  1
                R_LETTRE = '1';
                WaitSecs(STD+t-secs);
                break
            else
                R_LETTRE = '0' ;
            end
            WaitSecs(0.001);
        end
        
        RTsLet = [RTsLet;secs-t]
        time_appuiLet = secs-t;
        PERC_time_appuiLet = time_appuiLet/STD;
        PERC_time_appui_TOTLet= [PERC_time_appui_TOTLet; PERC_time_appuiLet ];
        
        if strcmp(R_LETTRE, REPONSE_SERIE(1,j))
            REPONSE_LETTRE = '1';
        else
            REPONSE_LETTRE = '0';
        end
        ANSWER_LETTER(j, 1) = str2num(REPONSE_LETTRE) ;
        
        if R_LETTRE + REPONSE_SERIE(1,j)==2
            trial = '1';
        else
            trial = '0';
        end
        
        DISTRIB_R_LETTRE(j,1) =  str2num(R_LETTRE);
        DISTRIB_R_SERIE(j,1) =  str2num(REPONSE_SERIE(1,j));
        
        vector= [DISTRIB_R_LETTRE+DISTRIB_R_SERIE]; % DISTRIB_R_LETTRE = subject answer  // DISTRIB_R_SERIE = correct answer
        vector2= [DISTRIB_R_SERIE DISTRIB_R_LETTRE];
        % correct answers
        busq= find(vector==2);  % 1 type of correct answer. press when have to press
        busq2= find(DISTRIB_R_SERIE==1);   % total of possible answers
        ANSWER_LETTER_TYPE1 = length(busq)/length(busq2);
        ANSWER_LETTER_TYPE1(isnan(ANSWER_LETTER_TYPE1))=0;
        
        busq3= find(vector==0);  % 2 type of correct answer. no press when do not have to press
        busq4= find(DISTRIB_R_SERIE==0);   % total of no answers
        
        ANSWER_LETTER_TYPE2 = length(busq3)/length(busq4);
        ANSWER_LETTER_TYPE2(isnan(ANSWER_LETTER_TYPE2))=0;
        % ERRORS
        % OmSTDon
        busq5a= find(vector2(:,1) > vector2(:,2)); % 3 type OmSTDon
        busq5b= find(DISTRIB_R_SERIE==1); % total of possible OmSTDon
        ANSWER_LETTER_TYPE3 = length(busq5a)/length(busq5b);
        ANSWER_LETTER_TYPE3(isnan(ANSWER_LETTER_TYPE3))=0;
        % FAs
        busq6a= find(vector2(:,1) < vector2(:,2)); % 3 type FA
        busq6b= find(DISTRIB_R_SERIE==0); % total of possible FAs
        ANSWER_LETTER_TYPE4 = length(busq6a)/length(busq6b);
        ANSWER_LETTER_TYPE4(isnan(ANSWER_LETTER_TYPE4))=0;
        
        NUMTEST = '0';
        
        %-------------------- Coding response Digits ---------------------%
        
        for num = 1
            
            numeros = ['1','2','3','4','6','7','8','9'];
            z= randperm(length(numeros));
            numeros = numeros(z);
            
            if num == 2
                if strcmp(NUMTEST, numeros(num))
                    XXX = str2num(numeros(num)) ;
                    if XXX < 9
                        XXX = XXX + 1 ;
                    else
                        XXX = XXX - 1 ;
                    end
                    numeros(num) = num2str(XXX) ;
                end
            end
            
            flag_black_screen = 0;
            DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
            Screen('FillRect',w,[255,255,255],newRect)
            Screen(w,'Flip');
            
            % trigger
            fwrite(usb,60);
          
            t= GetSecs;
            
            while GetSecs - t < STD
                

                
                if and(GetSecs - t > 0.4,flag_black_screen == 0)
                    DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
                    Screen('FillRect',w,[0,0,0],newRect)
                    Screen(w,'Flip');
                    flag_black_screen = 1;
                end
                
                [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(0);
                if keyIsDown == 1
                    R_NUM = KbName(keyCode) ;
                    WaitSecs(STD+t-secs);
                    break
                else
                    R_NUM = '0' ;
                end
                WaitSecs(0.001);
            end
            
            RTsNum = [RTsNum;secs-t]
            time_appuiNum = secs-t;
            PERC_time_appuiNum = time_appuiNum/STD;
            PERC_time_appui_TOTNum= [PERC_time_appui_TOTNum; PERC_time_appuiNum ];
            
            if mod(numeros(num),2) == 1
                if strcmp(R_NUM, '2')
                    REPONSE_NUM = '0';
                elseif strcmp(R_NUM, '3')
                    REPONSE_NUM = '1';
                else
                    REPONSE_NUM = '0';
                end
            elseif mod(numeros(num),2) == 0
                if strcmp(R_NUM, '2')
                    REPONSE_NUM = '1';
                elseif strcmp(R_NUM, '3')
                    REPONSE_NUM = '0';
                else
                    REPONSE_NUM = '0';
                end
            end
            
            if num == 1
                REPONSE_NUM1 = REPONSE_NUM ;
            elseif num == 2
                REPONSE_NUM2 = REPONSE_NUM ;
            end
            
            NUMTEST = numeros(num);
            ANSWER_NUMBER(j, num) = str2num(REPONSE_NUM) ;
        end
        
        % Registering the items presented: cheking tool
        items_let = [items_let; series(j)] ; % for letters
        items_num = [items_num; numeros(num)] ; % for digits
        
        % CALCULATING PERFORMANCE:
        
        % Enregistrant all answers
        fprintf(Data,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', Subject, Subject_number, Age, Sex, series(j),numeros(num), REPONSE_LETTRE, REPONSE_NUM1);
        fprintf(Data_RTs,'%s\t%s\t%s\t%.10f\t%s\t%.10f\n' , Subject, REPONSE_SERIE(1,j), REPONSE_LETTRE, PERC_time_appuiLet, REPONSE_NUM1,PERC_time_appuiNum);
        
        ANSWER_LETTER = ANSWER_LETTER_TYPE1*0.65 + ANSWER_LETTER_TYPE2*0.35
        PERFORMANCE = ANSWER_LETTER*0.65 + mean(ANSWER_NUMBER)*0.35;
        TOT_NUM = mean(ANSWER_NUMBER)
        
    end
    
    PERFORMANCE_TOTAL = [PERFORMANCE_TOTAL; PERFORMANCE];
    
    fprintf(Data_Performance,'%s\t%s\t%s\t%s\t%.10f\n', Subject, Subject_number, Age, Sex, PERFORMANCE );
    fprintf(Data_by_TofR,'%s\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\n' , Subject, ANSWER_LETTER_TYPE1, ANSWER_LETTER_TYPE2, ANSWER_LETTER_TYPE3, ANSWER_LETTER_TYPE4,TOT_NUM );
    
     if length(PERFORMANCE_TOTAL) > 4
        % BREAK LOOP IF PERFORMANCE UNDER CHANCE LEVEL
        %         for g = 1:length(PERFORMANCE_TOTAL)
        % Select the last four scores
        last_four = PERFORMANCE_TOTAL(end-3:end);
        last_four_mean = mean(last_four);
        
        if last_four_mean(1,1) < 0.50 % considering the task a binary classification problem = "press or not press" -> chance level is established at 50%
            break
            %             end
            
        end
    end
    
    
    
end


%%%%%%%%%%%%
%  END XP  %
%%%%%%%%%%%%

ENDXP = round(clock)

BEGXP = num2str(BEGXP)
ENDXP = num2str(ENDXP)
fprintf(Data_BEGXP_ENDXP, '%s\t%s\t%s\n', Subject, BEGXP, ENDXP);

% Final message
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'LE TEST EST TERMINÉ','center', 'center', [255,255,255]);
Screen(w, 'Flip');
% trigger offset task
fwrite(usb,90);

WaitSecs (6);

ShowCursor;
Screen('CloseAll') ;
Priority(0) ;
fclose(Data) ;
psychrethrow(psychlasterror) ;

% close COM port
fclose(usb);

