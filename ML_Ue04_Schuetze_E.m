function [] = ML_Ue04_Schuetze_Eve() 
  cars = dlmread("cars.csv", ",", 1, 1);

  #x0 = cyliner (row 1 of cars)
  x0 = initializeData(1, cars);
  #x1 = displacement (row 2 of cars)
  x1 = initializeData(2, cars);
  #x2 = horsepower (row 3 of cars)
  x2 = initializeData(3, cars);
  #x3 = weight (row 4 of cars)
  x3 = initializeData(4, cars);
  #x4 = acceleration (row 5 of cars)
  x4 = initializeData(5, cars);
  #x5 = year (row 6 of cars)
  x5 = initializeData(6, cars);
  
  #y
  y = initializeData(7, cars);
  
  
  #randomize the first k's
  k = randomK();
  x = [x0,x1,x2,x3,x4,x5];
  #which dimentions am I expecting?
  
  #first generation
  yN = x(:,1)*k(1) +  x(:,2)*k(2) + x(:,3)*k(3) + x(:,4)*k(4) + x(:,5)*k(5) +  x(:,6)*k(6);  
  denormY = denormalize(y, cars(:,7));
  denormYN = denormalize(yN, cars(:,7));  
  rmse = sqrt(sum((denormYN .- denormY) .^ 2)/length(denormY));
  firstK = k;



rounds = 300;
kCopy = firstK;
kRmse = rmse;

for i= 0:rounds
    #copy previous best to all 
    kElter = kCopy;
    elterR = kRmse;
    k1 = kCopy;
    k2 = kCopy;
    k3 = kCopy;
    
    
    #calculate rmse and children
    
    
    [childR1, k1] = giveMutatedRmse(k1,x,y,cars);
    [childR2, k2] = giveMutatedRmse(k2,x,y,cars);
    [childR3, k3] = giveMutatedRmse(k3,x,y,cars);
  
    childrenRMSE = [childR1, childR2, childR3];
    childrenK = [k1;k2;k3];
    
    
    #compare children rmse & elter rmse
    #only keep the information of the best
    for j = 1: length(childrenRMSE);
      if(childrenRMSE(j) < elterR)
        kRmse = childrenRMSE(j);
        kCopy = childrenK(j,:);
      else
        kRmse = elterR;
        kCopy = kElter;
        endif
    endfor
  endfor
  

  yNew = x(:,1)*kCopy(1) +  x(:,2)*kCopy(2) + x(:,3)*kCopy(3) + x(:,4)*kCopy(4) + x(:,5)*kCopy(5) +  x(:,6)*kCopy(6);  
  denormYNew = denormalize(yNew, cars(:,7));  
  
  
  #pickLines
  #4
  line4=cars(4,7);
  lineNorm4=denormYNew(4);
  #57
  line57 = cars(57,7);
  lineNorm57=denormYNew(57);
  #117
  line117 = cars(117,7);
  lineNorm117=denormYNew(117);
  #219
  line219 = cars(219,7);
  lineNorm219=denormYNew(219);
  
  
  
#the print should print out the predictions 
#but I don't know how that would function
printf("initial RMSE: %d\n", rmse);
printf("Run %d rounds ES(children:3 parents:1) ...\n", rounds);
printf("best RMSE: %d\n",kRmse);
printf("Line 4: mpg is %d, prefdicion was %d \n", line4 , lineNorm4);
printf("Line 57: mpg is %d, prefdicion was %d \n", line57, lineNorm57);
printf("Line 117: mpg is %d, prefdicion was %d \n", line117, lineNorm117);
printf("Line 219: mpg is %d, prefdicion was %d \n", line219, lineNorm219);

endfunction

function[msg] = findmsg (line, collection)
  msg = collection(line,7);
endfunction

function[rmseK, kNew] = giveMutatedRmse (k,x,y,collection)
  yN=0;
  kNew = (k + -0.1 + (0.1+0.1)*rand(1,6));
  yN = x *kNew';
    #ganz x muss extrahiert werden
  #x = 193x6 * kNew' = 6x1
  #Octave verrechnet das automatisch per Zeile
  denormY = denormalize(y, collection(:,7));
  denormYN = denormalize(yN, collection(:,7));  
  rmseK = sqrt(sum((denormYN .- denormY) .^ 2)/length(denormY));
endfunction

function [normData] = initializeData (row, collection)
  rowData = collection(:,row);
  normData = normalize(rowData);

endfunction

function[k] = randomK()
    k = -1 + (1+1)*rand(1,6);
endfunction

function [denormA] = denormalize (a, beforeA)
  denormA = (a * (max(beforeA) - min(beforeA)) + min(beforeA));
endfunction
  
 function [normA] = normalize (a)
  
  normA = (a - min(a))/(max(a)- min(a));
endfunction
