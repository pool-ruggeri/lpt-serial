
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   TloadDback Borragan & Slama & Peigneux    %%%%
%%%%%%%%       TRAINING + PRETEST         %%%%%%%%%%%
%%%%%%%%%%%%  Borragan, G. 15/07/2013  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% "Most people say that it is the intellect which makes a great scientist. They are wrong: it is character. " Albert Einstein


% ========================================================================
% 1. INITIALIZING..
% ========================================================================

clear all
close all

mkdir('Results_TloadDback_TRAINING')
mkdir('Results_TloadDback_PRETEST')

% Setting some Matlab parameters
dataNum=[]; % pour enregistrement des data numeriques Test Block
dataNum2=[]; % pour enregistrement des data numeriques Chart
dataStr={}; % pour enregistrement des data string

% Correction randomization
rand('state',sum(100*clock));

% ========================================================================
% 2. METADATA
% ========================================================================

Subject = input('What is participant''s name/code ?  ','s') ;
Subject_number = input('Introduce his/her number? :','s') ;
Age = input('Age? :  ', 's');
Sex = input('Men(1) or Women(2) :  ', 's');

% Creating individual datafiles for training and pretest values
Result = ['Results_TloadDback_TRAINING/TRAINING_' Subject '.txt'] ;
Result2 = ['Results_TloadDback_PRETEST/PRETEST_' Subject '.txt'] ; %
% Checking whether the datafile already exists
if exist(Result,'file')
    Attention = input('Attention! the datafile already exists. Would you like to rewrite it?  [yes] [no] :  ', 's') ;
    if ~strcmp(Attention,'yes')
        disp('Experiment aborted') ;
        return
    end
end

% Preparing datafiles outputs
dataExp = [num2cell(dataNum),dataStr];
dataExp = dataExp';

Data = fopen(Result,'wt') ;
Data_Pretest = fopen(Result2,'wt');
fprintf(Data, ['Subject' '\t', 'Subject_number' '\t', 'Age' '\t', 'Sex' '\t', 'RESPONSE_LETTRE' '\t', 'RESPONSE_NUM1' '\t', 'RESPONSE_NUM2' '\n']); % header
fprintf(Data_Pretest, ['Subject' '\t', 'Subject_number' '\t','Age' '\t','Sex' '\t', 'PRETEST_HCL' '\n']);  % header of the minimal Pretest value to maintain a performance > 85%

% ========================================================================
% 3. PARAMETERS
% ========================================================================

%Opening PTB
Screen('Preference', 'Verbosity', 2); % Output for critical errors and warnings
Screen('Preference', 'SkipSyncTests', 0);
[w, wrect]=Screen('OpenWindow', 0,1);  % 0,1 = black screen --> consume less energy ;)

[width, height] = Screen('WindowSize', w);

cycleRefresh = Screen('GetFlipInterval',w);
display(cycleRefresh)

% Hiding mouse pointer and unifying keyboard in QWERTY
HideCursor;
KbName('UnifyKeyNames') ;

spaceKey = KbName('space'); escKey = KbName('ESCAPE');

% ========================================================================
% 4. INITIALIZATING EXPERIMENT
% ========================================================================

% Defining inital STD (Stimulus Time Duration)
STD= 1.5; % Parameter fixed at 1.5 based on pilot studies. It can be however increased if the population tested presents in general slower learning. I.e: Elderly...
STD = round(STD/cycleRefresh)*cycleRefresh; % To adapt the STD at the screen refreshing rate

%% Definition of initial performance [values weigheted to 70%(letters) - 30% (numbers) based on prior results; see Borragan & Slama, 2017]
trial = [];
items_num = [];
items_let = [];
ANSWER_LETTER_CORRECTED = []; % no push when it does not count
ANSWER_LETTER_TYPE1 = [];     % press when you have to press  70 % over 100% of ANSWER_LETTER
ANSWER_LETTER_TYPE2 = [];     % no press when do not have to press 30% over 100% of ANSWER_LETTER

%------------- INTRUCTIONS -------------%

Priority(MaxPriority(w)) ;
Screen(w, 'TextFont', 'TimesNewRoman');
Screen(w, 'TextSize', 42);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'BIENVENU','center','center',[255,255,255]);
Screen(w, 'TextSize', 25)
DrawFormattedText(w, 'Appuyez sur une touche pour voir les instructions','center',500,[255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs (1.0);

consigne=imread('General_Instructions.bmp'); % images bmp(image .bmp) --> Tip: Ensure that access path to the images is correctly set
Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

consigne=imread('Digits_Instructions.bmp'); % images bmp(image .bmp) --> Tip: Ensure that access path to the images is correctly set
Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

%% Training the digits..

% Setting visual parameters of the stimuli
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 120);
Screen(w, 'TextStyle', 1);

for num = 1:14
    numeros = ['9','1','2','8','4','6','7','8','9','3','1','6','4','2']; % Number 5 never presented. See Borragán & Slama,2017
    DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
    Screen(w,'Flip');
    WaitSecs(STD)
end

% PAUSE
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'ENCORE UNE FOIS!','center','center',[255,255,255]);
DrawFormattedText(w, 'Appuyez sur une touche pour continuer','center',500,[255,255,255]);

Screen(w, 'Flip');
KbWait;
WaitSecs (1.5);

% Repetion x1
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 120);
Screen(w, 'TextStyle', 1);

for num = 1:14
    numeros = ['3','2','9','3','2','6','8','7','1','2','3','4','6','7'];
    DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
    Screen(w,'Flip');
    WaitSecs(STD)
end

%% Training the letters..

Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'BON BOULOT!  Allos-y maintenant avec les lettres','center','center',[255,255,255]);
DrawFormattedText(w, 'Appuyez sur une touche pour voir les instructions','center',500,[255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs(0.1);

consigne=imread('Letters_Instructions.bmp');

Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 120);
Screen(w, 'TextStyle', 1);

for j = 1:20
    
    series_lettres_a = [ 'E' 'P' 'P' 'L' 'A' 'P' 'L' 'A' 'A' 'N' 'T' 'N' 'N' 'N' 'U' 'T' 'T' 'P' 'R' 'R' ];
    DrawFormattedText(w,series_lettres_a(j), 'center', 'center',[255,255,255]);
    Screen(w,'Flip');
    WaitSecs(STD)
    t= GetSecs;
    
    for num = 1
        numeros = ['1','2','3','4','6','7','8','9'];
        z= randperm(length(numeros));
        numeros = numeros(z);
        DrawFormattedText(w, numeros(num), 'center', 'center',[0,0,0]);
        Screen(w,'Flip');
        WaitSecs(STD)
    end
end

% PAUSE
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'ENCORE UNE FOIS!','center','center',[255,255,255]);
DrawFormattedText(w, 'Appuyez sur une touche pour continuer','center',500,[255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs (1.5);

% Repetion x1
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 120);
Screen(w, 'TextStyle', 1);

for j = 1:20
    
    series_lettres_b = [ 'C'  'T'  'C'  'C'  'A'  'A'  'R'  'N'  'L'  'L' 'N'  'P'  'P'  'N'  'U'  'R'  'R'  'T'  'R'  'E' ];
    DrawFormattedText(w,series_lettres_b(j), 'center', 'center',[255,255,255]);
    Screen(w,'Flip');
    WaitSecs(STD)
    
    for num = 1
        numeros = ['1','2','3','4','6','7','8','9'];
        z= randperm(length(numeros));
        numeros = numeros(z);
        DrawFormattedText(w, numeros(num), 'center', 'center',[0,0,0]);
        Screen(w,'Flip');
        WaitSecs(STD)
    end
    
end

%*************************************************************************%
%                            LEARNING LOOP
%*************************************************************************%

% Let's now combine both letters and numbers: there is a loop fix this time.
% It only proceed if the participants are able to reach a performance > 85%

STD= 1.4; % STD training and Initial Pretest = 1.4. The parameter is fixed at 1.4 based on prior experience.
STD = round(STD/cycleRefresh)*cycleRefresh; % To adapt the STD at the screen refreshing rate

Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'BIEN FAIT! Allons-y maintenant avec les lettres et les chiffres au même temps','center','center',[255,255,255]);
DrawFormattedText(w, 'Appuyez sur une touche pour voir les instructions','center',500,[255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs(0.1);

consigne=imread('Letters_Digits_Instructions.bmp');

Screen('PutImage', w, consigne);
Screen(w, 'Flip');
KbWait;
WaitSecs(1);

%% 1-BACK combinaisons
%  lettres = [A,C,T,L,N,E,U,P,R];  % Frequence d'apparition dans  la gramaire française >3%. Ref: see Borragán and Slama,2017

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

% Iniziating loop of training with letters and digits. Performance has to be > 85% to go to the next step = real Pretest
PERFORMANCE2= 0.40;

while PERFORMANCE2 <= 0.85
    
    % Stimuli parameters
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextSize', 120);
    Screen(w, 'TextStyle', 1);
    
    series_all = [series1;series2;series3;series4;series5;series6;series7;series8;series9;series10;series11;series12;series13;series14;series15;series16;series17;series18;series19;series20];
    
    % Randomization
    REPONSE_ALL = [REPONSE_SERIES1;REPONSE_SERIES2;REPONSE_SERIES3;REPONSE_SERIES4;REPONSE_SERIES5;REPONSE_SERIES6;REPONSE_SERIES7;REPONSE_SERIES8;REPONSE_SERIES9;REPONSE_SERIES10;REPONSE_SERIES11;REPONSE_SERIES12;REPONSE_SERIES13;REPONSE_SERIES14;REPONSE_SERIES15;REPONSE_SERIES16;REPONSE_SERIES17;REPONSE_SERIES18;REPONSE_SERIES19;REPONSE_SERIES20];
    randorder = randperm(20);
    series = series_all(randorder(1),:);
    REPONSE_SERIE = REPONSE_ALL(randorder(1),:);
    
    % Creating vectors for variables
    DISTRIB_R_LETTRE =[];
    DISTRIB_R_SERIE =[];
    ANSWER_LETTER = [] ;
    ANSWER_NUMBER = [] ;
    REPONSE_LETTRE_CORR = [];
    
    %-------------------- Coding response Letters ---------------------%
    for j = 1:length(series)
        
        DrawFormattedText(w,series(j), 'center', 'center',[255,255,255]);
        Screen(w,'Flip');
        
        t= GetSecs;
        while GetSecs - t < STD
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
        
        % Type of responses
        vector= DISTRIB_R_LETTRE+DISTRIB_R_SERIE;
        busq= find(vector==2);  % 1 type of correct answer. Press when have to press
        busq2= find(DISTRIB_R_SERIE==1);
        ANSWER_LETTER_TYPE1 = length(busq)/length(busq2);
        ANSWER_LETTER_TYPE1(isnan(ANSWER_LETTER_TYPE1))=0;
        busq3= find(vector==0);  % 2 type of correct answer. No press when do not have to press
        busq4= find(DISTRIB_R_SERIE==0);
        ANSWER_LETTER_TYPE2 = length(busq3)/length(busq4);
        ANSWER_LETTER_TYPE2(isnan(ANSWER_LETTER_TYPE2))=0;
        
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
            
            DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
            Screen(w,'Flip');
            
            items_num = [items_num; numeros(num)] ; % Vector of numbers presented
            
            t= GetSecs;
            
            while GetSecs - t < STD
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
            
            if mod(numeros(num),2) == 1
                if strcmp(R_NUM, '2')   % KbDemo: You pressed key 98 which is 2
                    REPONSE_NUM = '0';
                elseif strcmp(R_NUM, '3') % % KbDemo: You pressed key 99 which is 3
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
        
        items_let = [items_let; series(j)] ; % Vector of letters presented
        fprintf(Data,'%s\t%s\t%s\t%s\t%s\t%s\n', Subject, Subject_number, Age, Sex, REPONSE_LETTRE, REPONSE_NUM1);
    end
    
    %% CALCULATING PERFORMANCE2:
    
    % Weighted mean where ANSWER_LETTER = 0.65% and ANSWER_NUMBER = 0.35
    % ANSWER LETTER = ANSWER_LETTER_TYPE2*0.70 + ANSWER_LETTER_TYPE2*0.30
    
    ANSWER_LETTER= ANSWER_LETTER_TYPE1*0.65 + ANSWER_LETTER_TYPE2*0.35;
    PERFORMANCE2= ANSWER_LETTER*0.65 + mean(ANSWER_NUMBER)*0.35;
    
    if PERFORMANCE2(1,1) > 0.85
        break
    end
    
    %% PAUSE each 60 trials to diminish the impact of CF on the training
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextSize', 32);
    Screen(w, 'TextStyle', 0);
    
    DrawFormattedText(w, 'PAUSE: Faisons une pause,', 'center', 'center', [51,51,255]);
    Screen(w, 'Flip');
    KbWait;
    WaitSecs (1.5);
    
    DrawFormattedText(w, 'La tache continuera quand tu touches une touche','center', 'center', [255,255,255]);
    Screen(w, 'Flip');
    KbWait;
    WaitSecs (1.5);
    
end

%*************************************************************************%
%                      TRANSITION Training - Real Pretest
%*************************************************************************%

Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'BRAVO!', 'center', 300, [255,255,255]);
DrawFormattedText(w, 'Tu es prêt pour commencer le Pretest','center', 390, [255,255,255]);
Screen(w, 'Flip');
WaitSecs (3);

DrawFormattedText(w, 'Prende une longue pause ','center', 'center', [255,255,255]);
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 22);
Screen(w, 'TextStyle', 0);
DrawFormattedText(w, 'Touche un touche quand tu te sens frais et prêt à continuer.','center',460, [255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs (1.5);

Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 52);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'PRETEST','center', 'center', [255,255,255]);
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 22);
Screen(w, 'TextStyle', 0);
DrawFormattedText(w, 'Touche deux fois le space pour commencer','center', 460,[255,255,255]);
Screen(w, 'Flip');
WaitSecs(0.1);
KbWait;
WaitSecs(0.5);
KbWait;
WaitSecs(0.5);

%*************************************************************************%
%                               PRETEST
%*************************************************************************%

%% Variables Definition
STD= 1.3; % -0.1 because they were able to pass the learning loop at 1.4
STD = round(STD/cycleRefresh)*cycleRefresh; % To adapt the STD at the screen refreshing rate
RTsLet = [];
PERC_time_appui_TOTLet = [];
PERC_time_appuiLet  = [];
RTsNum =[];
PERC_time_appuiNum= [];
PERC_time_appui_TOTNum=[];

error = 0;
accumu_error = 0;
PERFORMANCE_TOTAL = [];
%try
PERFORMANCE = 0.99;

while PERFORMANCE  >= 0.01 % if performance fall down from 85% == STD
    
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextSize', 120);
    Screen(w, 'TextStyle', 1);
    series_all = [series1;series2;series3;series4;series5;series6;series7;series8;series9;series10;series11;series12;series13;series14;series15;series16;series17;series18;series19;series20];
    
    % Randomization
    REPONSE_ALL = [REPONSE_SERIES1;REPONSE_SERIES2;REPONSE_SERIES3;REPONSE_SERIES4;REPONSE_SERIES5;REPONSE_SERIES6;REPONSE_SERIES7;REPONSE_SERIES8;REPONSE_SERIES9;REPONSE_SERIES10;REPONSE_SERIES11;REPONSE_SERIES12;REPONSE_SERIES13;REPONSE_SERIES14;REPONSE_SERIES15;REPONSE_SERIES16;REPONSE_SERIES17;REPONSE_SERIES18;REPONSE_SERIES19;REPONSE_SERIES20];
    randorder = randperm(20);
    series = series_all(randorder(1),:);
    REPONSE_SERIE = REPONSE_ALL(randorder(1),:);
    
    % Creating vectors for variables
    DISTRIB_R_LETTRE =[];
    DISTRIB_R_SERIE =[];
    ANSWER_LETTER = [] ;
    ANSWER_NUMBER = [] ;
    REPONSE_LETTRE_CORR = [];
    
    %-------------------- Coding response Letters ---------------------%
    
    for j = 1:length(series)
        DrawFormattedText(w,series(j), 'center', 'center',[255,255,255]);
        Screen(w,'Flip');
        t= GetSecs;
        
        while GetSecs - t < STD
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
        
        vector= DISTRIB_R_LETTRE+DISTRIB_R_SERIE;
        busq= find(vector==2);  % 1 type of correct answer. Press when have to press
        busq2= find(DISTRIB_R_SERIE==1);
        ANSWER_LETTER_TYPE1 = length(busq)/length(busq2);
        ANSWER_LETTER_TYPE1(isnan(ANSWER_LETTER_TYPE1))=0;
        busq3= find(vector==0);  % 2 type of correct answer. No press when do not have to press
        busq4= find(DISTRIB_R_SERIE==0);
        ANSWER_LETTER_TYPE2 = length(busq3)/length(busq4);
        ANSWER_LETTER_TYPE2(isnan(ANSWER_LETTER_TYPE2))=0;
        
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
            
            DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
            Screen(w,'Flip');
            items_num = [items_num; numeros(num)] ;
            
            t= GetSecs;
            while GetSecs - t < STD
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
        
        items_let = [items_let; series(j)] ;
        fprintf(Data,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', Subject, Subject_number, Age, Sex, REPONSE_LETTRE, REPONSE_NUM1);
        
    end
    
    %% CALCULATING TEST PERFORMANCE:
    
    % Weighted mean where ANSWER_LETTER = 0.65% and ANSWER_NUMBER = 0.35
    % ANSWER LETTER = ANSWER_LETTER_TYPE2*0.70 + ANSWER_LETTER_TYPE2*0.30
    
    ANSWER_LETTER = ANSWER_LETTER_TYPE1*0.65 + ANSWER_LETTER_TYPE2*0.35;
    PERFORMANCE= ANSWER_LETTER*0.65 + mean(ANSWER_NUMBER)*0.35;
    
    PERFORMANCE_TOTAL = [PERFORMANCE_TOTAL; PERFORMANCE];
    
    if PERFORMANCE < 0.85
        
        error = error +1;
        accumu_error = accumu_error+1;
        
        STD = STD;                            % STD does not increase --> repeat block
        %% Break each 60 trials
        
        Screen(w, 'TextFont', 'Arial');
        Screen(w, 'TextSize', 32);
        Screen(w, 'TextStyle', 0);
        DrawFormattedText(w, 'PAUSE: Reposez-vous,', 'center', 'center', [51,51,255]);
        Screen(w, 'Flip');
        KbWait;
        WaitSecs (1.5);
        
        DrawFormattedText(w, 'L''expérience redémarrera dès que vous appuyez sur une touche','center', 'center', [255,255,255]);
        Screen(w, 'Flip');
        KbWait;
        WaitSecs (1.5);
        
    else
        
        STD= STD -0.10;
        STD = round(STD/cycleRefresh)*cycleRefresh; % To adapt the STD at the screen refreshing rate
        error = 0;
        
        Screen(w, 'TextFont', 'Arial');
        Screen(w, 'TextSize', 32);
        Screen(w, 'TextStyle', 0);
        DrawFormattedText(w, 'PAUSE: Reposez-vous', 'center', 300, [51,51,255]);
        Screen(w, 'Flip');
        KbWait;
        WaitSecs (1.5);
        
        DrawFormattedText(w, 'L''expérience redémarrera dès que vous appuyez sur une touche','center', 'center', [255,255,255]);
        Screen(w, 'Flip');
        KbWait;
        WaitSecs (1.5);
        
    end
    %% Loop repetition
    if error == 3
        PRETEST_HCL= STD+0.10;
        break
    end
    
    if accumu_error == 5; % Altough this value is fixed to 3 in Borragan & Slama,2017, increasing it at 5 might increase the pretest calibration
        PRETEST_HCL= STD;
        break
    end
    
end

fprintf(Data_Pretest,'%s\t%s\t%s\t%s\t%.10f\n', Subject, Subject_number, Age, Sex, PRETEST_HCL );  %




%********************************************************************************************************************%
%                      ADDING ONE FINAL BLOCK OF PRACTICE WITH LAST STD - TO SETTLE DOWN LEARNING
%********************************************************************************************************************%


Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'BIEN JOUÉ!', 'center', 300, [255,255,255]);
DrawFormattedText(w, 'Tu as fait du bon travail', 'center', 390, [255,255,255]);
% DrawFormattedText(w, 'Répétons-le une dernière fois','center', 390, [255,255,255]);
Screen(w, 'Flip');
WaitSecs (3);

DrawFormattedText(w, 'Fais d''abord une longue pause','center', 'center', [255,255,255]);
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 22);
Screen(w, 'TextStyle', 0);
DrawFormattedText(w, 'Appuie sur n''importe quelle touche lorsque tu te sens reposé et prêt à continuer.','center',460, [255,255,255]);
Screen(w, 'Flip');
KbWait;
WaitSecs (1.5);

Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 52);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'Appuie deux fois sur l''espace pour démarrer','center', 460,[255,255,255]);
Screen(w, 'Flip');
WaitSecs(0.1);
KbWait;
WaitSecs(0.5);
KbWait;
WaitSecs(0.5);


% LET'S GO
    
    % Stimuli parameters
    Screen(w, 'TextFont', 'Arial');
    Screen(w, 'TextSize', 120);
    Screen(w, 'TextStyle', 1);
    
    series_all = [series1;series2;series3;series4;series5;series6;series7;series8;series9;series10;series11;series12;series13;series14;series15;series16;series17;series18;series19;series20];
    
    % Randomization
    REPONSE_ALL = [REPONSE_SERIES1;REPONSE_SERIES2;REPONSE_SERIES3;REPONSE_SERIES4;REPONSE_SERIES5;REPONSE_SERIES6;REPONSE_SERIES7;REPONSE_SERIES8;REPONSE_SERIES9;REPONSE_SERIES10;REPONSE_SERIES11;REPONSE_SERIES12;REPONSE_SERIES13;REPONSE_SERIES14;REPONSE_SERIES15;REPONSE_SERIES16;REPONSE_SERIES17;REPONSE_SERIES18;REPONSE_SERIES19;REPONSE_SERIES20];
    randorder = randperm(20);
    series = series_all(randorder(1),:);
    REPONSE_SERIE = REPONSE_ALL(randorder(1),:);
    
    % Creating vectors for variables
    ANSWER_LETTER = [] ;
    ANSWER_NUMBER = [] ;
    REPONSE_LETTRE_CORR = [];
    
    %-------------------- Coding response Letters ---------------------%
    for j = 1:length(series)
        
        DrawFormattedText(w,series(j), 'center', 'center',[255,255,255]);
        Screen(w,'Flip');
        t= GetSecs;
        
        while GetSecs - t < STD
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
            
            DrawFormattedText(w, numeros(num), 'center', 'center',[255,255,255]);
            Screen(w,'Flip');
            
            t= GetSecs;
            
            while GetSecs - t < STD
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
        
        ANSWER_LETTER = ANSWER_LETTER_TYPE1*0.65 + ANSWER_LETTER_TYPE2*0.35
        PERFORMANCE = ANSWER_LETTER*0.65 + mean(ANSWER_NUMBER)*0.35;
        TOT_NUM = mean(ANSWER_NUMBER)
    end   
        
disp(PERFORMANCE) % For the researcher to see the last performance here on the screen 


%****************************************************************************%
%                                 FINAL MESSAGE
%****************************************************************************%

% Final message
Screen(w, 'TextFont', 'Arial');
Screen(w, 'TextSize', 32);
Screen(w, 'TextStyle', 0);

DrawFormattedText(w, 'FÉLICITATIONS!', 'center', 'center', [51,51,255]);
DrawFormattedText(w, 'LE PRETEST EST TERMINÉ','center', 460, [255,255,255]);

Screen(w, 'Flip');
WaitSecs (6);

ShowCursor;
Screen('CloseAll') ;

display(PRETEST_HCL)
