clear all;
clc;

load('gTruthAcf.mat');
load('Detector.mat');
GTruth = selectLabels(gTruthAcf,'kendim');
 trainingData = objectDetectorTrainingData(GTruth,'SamplingFactor',1,...
 'WriteLocation','TrainingData');
 detector = trainACFObjectDetector(trainingData,'NumStages',2); 
 
save('Detector.mat','detector');

% [dosya,dosyaYolu] = uigetfile({'*.jpg; *.bmp; *.png; *.tif'},'Bir resim seçin');
% img = imread([dosyaYolu,dosya]);
% a=imresize(img,[420,420]);
ortalama=0;
dosyayeri = 'Photos\';
dosyaturu='.jpg';
icerik = dir([dosyayeri,'*',dosyaturu]);
Rsayisi = size(icerik,1);

for k=1:Rsayisi
    string = [dosyayeri,icerik(k,1).name];
    img = imread(string);
    a=imresize(img,[440,440]);
    
    results = struct('Boxes',[],'Scores',[]);
    [bboxes, scores] = detect(detector,a,'Threshold',1);
  
    % Select strongest detection 
    [~,idx] = max(scores);
    results.Boxes = bboxes;
    results.Scores = scores;
    
    % VISUALIZESQASA VCDF
    annotation = sprintf('%s , Sonuç=%4.2f',detector.ModelName,scores(idx));
    I = insertObjectAnnotation(a,'rectangle',bboxes(idx,:),annotation);
    
  figure, imshow(I);  
end