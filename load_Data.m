function [Nsti,Naft,Msti,Maft,b,ID,type,grade]=load_Data(file,flag)
  % Simple function to load in the data.
  %
  % Written by Ryan Schultz.
  
  % Get data.
  system(['awk -F, '' FNR > 1 {print $7, $8, $10, $11, $12}'' ', file, ' > temp.loadBath']);
  data1=load('temp.loadBath');
  system(['awk -F, '' FNR > 1 {print $1}'' ', file, ' > temp.loadBath']);
  data2=importdata('temp.loadBath',',');
  system(['awk -F, '' FNR > 1 {print $3}'' ', file, ' > temp.loadBath']);
  data3=importdata('temp.loadBath',',');
  system(['awk -F, '' FNR > 1 {print $14}'' ', file, ' > temp.loadBath']);
  data4=importdata('temp.loadBath',',');
  system('rm -f temp.loadBath');
  
  % Load data into vectors.
  Nsti=data1(:,1);
  Naft=data1(:,2);
  Msti=data1(:,3);
  Maft=data1(:,4);
  b=data1(:,5);
  ID=data2;
  type=data3;
  grade=data4;
  
  % Remove null count data, if flagged to.
  if(strcmpi(flag,'count')||strcmpi(flag,'all'))
      Nsti(isnan(Naft))=[]; Msti(isnan(Naft))=[]; Maft(isnan(Naft))=[]; b(isnan(Naft))=[]; ID(isnan(Naft))=[]; type(isnan(Naft))=[]; grade(isnan(Naft))=[]; Naft(isnan(Naft))=[];
      Naft(isnan(Nsti))=[]; Msti(isnan(Nsti))=[]; Maft(isnan(Nsti))=[]; b(isnan(Nsti))=[]; ID(isnan(Nsti))=[]; type(isnan(Nsti))=[]; grade(isnan(Nsti))=[]; Nsti(isnan(Nsti))=[];
  end
  
  % Remove null mag data, if flagged to.
  if(strcmpi(flag,'mag')||strcmpi(flag,'all'))
      Nsti(isnan(Maft))=[]; Naft(isnan(Maft))=[]; Msti(isnan(Maft))=[]; b(isnan(Maft))=[]; ID(isnan(Maft))=[]; type(isnan(Maft))=[]; grade(isnan(Maft))=[]; Maft(isnan(Maft))=[];
      Naft(isnan(Msti))=[]; Nsti(isnan(Msti))=[]; Maft(isnan(Msti))=[]; b(isnan(Msti))=[]; ID(isnan(Msti))=[]; type(isnan(Msti))=[]; grade(isnan(Msti))=[]; Msti(isnan(Msti))=[];
  end
  
  % Remove null b-val data, if flagged to.
  if(strcmpi(flag,'b-val')||strcmpi(flag,'all'))
      Naft(isnan(b))=[]; Nsti(isnan(b))=[]; Msti(isnan(b))=[]; Maft(isnan(b))=[]; ID(isnan(b))=[]; type(isnan(b))=[]; grade(isnan(b))=[]; b(isnan(b))=[];
  end
  
return