clc
clear all
%% Carga de audio y calibración %%
[FileName,PathName,FilterIndex] = uigetfile('*.wav','Seleccione el archivo de audio a comparar con Ruido','MultiSelect','off');
[Audio,fs] = audioread([PathName,FileName]);%Audio_cell2mat));
Audio = Audio(:,1);
signal = Audio';
[FileName2,PathName2,FilterIndex2] = uigetfile('*.wav','Seleccione el archivo de ruido de fondo','MultiSelect','off');
[Audio2,fs2] = audioread([PathName2,FileName2]);%Audio_cell2mat));
Audio2 = Audio2(:,1);
ruidofondo = Audio2';
[FileName3,PathName3,FilterIndex3] = uigetfile('*.wav','Seleccione el archivo de calibración','MultiSelect','off');
[cal,fsc] = audioread([PathName3,FileName3]);%Audio_cell2mat));
cal = cal(:,1);
C = rms(cal); % calculo el valor eficaz


%% Filtros 1/3 octava %%
f = fdesign.octave(3,'Class 0','N,F0',6,1000,48000);
F0 = validfrequencies(f);
Nfc = length(F0);
%%
enBandasSignal= zeros(length(signal),Nfc);%Creamos esta matriz para ubicar las 30 señales filtradas
enBandasRF= zeros(length(ruidofondo),Nfc);%Creamos esta matriz para ubicar las 30 señales filtradas
for i=1:Nfc
     f.F0 = F0(i);
     Hd(i) = design(f,'butter');
     enBandasSignal(:,i) = filter(Hd(i),signal);
     enBandasRF(:,i) = filter(Hd(i),ruidofondo);
     total(i,1) = 20*log10((rms(enBandasSignal(:,i))/C)/2e-5);
     totalRF(i,1) = 20*log10((rms(enBandasRF(:,i))/C)/2e-5);
end
total = total';
totalRF = totalRF';
Resta = total - totalRF;
%% Grafico

%Para Matlab 2016
%set(gca,'XTick',x)
%set(gca,'XTickLabel', cellstr(num2str(x(:), '%3.4f')))
%set(gca,'YTick',y)
%set(gca,'YTickLabel', cellstr(num2str(y(:), '%+1.2f')) )

fig = figure('name','Sonometro','NumberTitle','off');
subplot(3,1,1)
bar(total)
title('Señal','position',[2 52 0]);grid on; grid minor;
ylim([0 80]);

%yticks([0 20 40 60 80])
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30])
%xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30])
set(gca, 'XTickLabel', ({'25','31.5','40','50','63','80','100','125','160','200','250','315','400'...
    ,'500','630','800','1K','1250','1.6K','2K','2.5K','3150','4K','5K','6.3K','8K','10K'...
    ,'12.5K','16K','20K'})) 
%xticklabels({'25','31.5','40','50','63','80','100','125','160','200','250','315','400'...
    %,'500','630','800','1K','1250','1.6K','2K','2.5K','3150','4K','5K','6.3K','8K','10K'...
    %,'12.5K','16K','20K'})
xlabel('Frec. [Hz]','FontSize',8);
ylabel('dBZ');



subplot(3,1,2)
bar(totalRF)
% t = title('hi')
% set(t, 'horizontalAlignment', 'right')
ylim([0 80]);
title('Ruido de fondo','position',[4 48 0]);grid on; grid minor;
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30])
%xticks([1 2 3 4 5 6 7 8, 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30])
set(gca, 'YTick', [0 20 40 60 80])
%yticks([0 20 40 60 80])
set(gca, 'XTickLabel', ({'25','31.5','40','50','63','80','100','125','160','200','250','315','400'...
    ,'500','630','800','1K','1250','1.6K','2K','2.5K','3150','4K','5K','6.3K','8K','10K'...
    ,'12.5K','16K','20K'})) 
%xticklabels({'25','31.5','40','50','63','80','100','125','160','200','250','315','400'...
    %,'500','630','800','1K','1250','1.6K','2K','2.5K','3150','4K','5K','6.3K','8K','10K'...
    %,'12.5K','16K','20K'})
xlabel('Frec. [Hz]','FontSize',8);
ylabel('dBZ');



subplot(3,1,3)
bar(Resta)
ylim([-20 80]);
title('Diferencia','position',[3 30 0]);
grid on; grid minor;
set(gca, 'YTick', [-20 0 20 40 60 80])
%yticks([-20 0 20 40 60 80])
set(gca, 'XTick', [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30])
%xticks([1 2 3 4 5 6 7 8, 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30])
set(gca, 'XTickLabel', ({'25','31.5','40','50','63','80','100','125','160','200','250','315','400'...
    ,'500','630','800','1K','1250','1.6K','2K','2.5K','3150','4K','5K','6.3K','8K','10K'...
    ,'12.5K','16K','20K'})) 
%xticklabels({'25','31.5','40','50','63','80','100','125','160','200','250','315','400'...
    %,'500','630','800','1K','1250','1.6K','2K','2.5K','3150','4K','5K','6.3K','8K','10K'...
    %,'12.5K','16K','20K'})
xlabel('Frec. [Hz]','FontSize',8);
ylabel('dBZ');
