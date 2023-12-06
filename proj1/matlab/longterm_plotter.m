clear
load("all_long.mat")
close all; clf

lineWid = 1.4;
fontS = 24;




limit = 1200;
figure(1)
plot(ave1(1:limit));hold on; plot(ave2(1:limit)),plot(ave3(1:limit));plot(ave4(1:limit))
ylabel("Average BPM")
xlabel("Time [minutes]")
set(gca,'DefaultLineLineWidth',lineWid)
set(gca,"FontSize", fontS)
legend("Trace " + (1:4))


figure(2)
plot(std1(1:limit));hold on; plot(std2(1:limit)),plot(std3(1:limit));plot(std4(1:limit))
ylabel("Size of standard deviation")
xlabel("Time [minutes]")
set(gca,'DefaultLineLineWidth',lineWid)
set(gca,"FontSize", fontS)
legend("Trace " + (1:4))
