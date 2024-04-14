close all; clear all; clc;
pkg load signal;

% Altera o tamanho da fonte nos plots para 15
set(0, 'DefaultAxesFontSize', 20);

% Defining the signals amplitude.
A_modulating = 1;
A_carrier = 1;

% Defining the signals frequency
f_modulating_max = 20000;
f_carrier = 80000;

% modulator sensibility for frequency variation (Hz/volts)
k_f = 2000000;
k0 = 2*pi*k_f;

% Delta variable, correponding to max frequency variation.
d_f = k_f*A_modulating;

% Beta variable, correspondig to percentage of frequency variation about the frequency of the modulating.
b = d_f/f_modulating_max;

% Defining the period and frequency of sampling:
fs = 50*f_carrier;
Ts = 1/fs;
T = 1/f_modulating_max;

% Defining the sinal period.
t_inicial = 0;
t_final = 2;

% "t" vector, correspondig to the time period of analysis, on time domain.
t = [t_inicial:Ts:t_final];

% Modulating Singnal for FM modulation
modulating_signal = A_modulating *cos(2*pi*f_modulating_max*t);

% Calculate the number of zeros to be added
num_zeros = length(t) - length(modulating_signal);

% Add the zeros to the end of the modulating_signal vector
modulating_signal = [modulating_signal, zeros(1, num_zeros)];

% Transpose the modulated signal if necessary
modulated_signal = transpose(modulating_signal);

% Creating the FM modulated signal:
phase_argument = 2*pi*k_f*cumsum(modulating_signal)*(Ts);
modulated_signal = A_carrier * cos(2*pi*f_carrier*t + phase_argument);

% Plot signals on time domain:
figure(1)
subplot(311)
plot(t, (modulating_signal),'b', 'LineWidth', 2)
xlim([0.00054 0.00067])
xlabel('Time (s)')
ylabel('Amplitude')
title('Random Sound Signal (Time Domain)')

subplot(312)
plot(t, abs(modulating_signal),'r', 'LineWidth', 2)
xlim([0.00054 0.00067])
xlabel('Time (s)')
ylabel('Amplitude')
title('Random Sound Signal - Absolute (Time Domain)')

subplot(313)
plot(t, modulated_signal,'k', 'LineWidth', 2)
xlim([0.00054 0.00067])
xlabel('Time (s)')
ylabel('Amplitude')
title('Modulated FM Signal (Time Domain)')

% calculating the step of the frequency vector "f" (frequency domain);
f_step = 1/t_final;

% creating the frequency vector "f" (frequency domain);
f = [-fs/2:f_step:fs/2];

% calculating the FFT of the random signal;
modulating_f = fft(modulating_signal)/length(modulating_signal);
modulating_f = fftshift(modulating_f);

% calculating the FFT of the modulated signal;
modulated_f = fft(modulated_signal)/length(modulated_signal);
modulated_f = fftshift(modulated_f);

% Plotting the modulated signal on frequency domain;
figure(2)
subplot(211)
plot(f, abs(modulating_f), 'k', 'LineWidth', 2)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Modulating Signal (Frequency Domain)')
xlim([-f_carrier*1.2 f_carrier*1.2])
ylim([0 A_carrier/1000])


subplot(212)
plot(f, abs(modulated_f), 'k', 'LineWidth', 2)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Modulated Signal (Frequency Domain)')
xlim([-f_carrier*1.2 f_carrier*1.2])
ylim([0 A_carrier/1000])

% Calculating the FM demodulation for the modulated signal
demodulated_signal = diff(modulated_signal) * fs / k0;
demodulated_signal = [demodulated_signal, 0];  % Sinal demodulado

% calculating the FFT of the random signal;
demodulated_f = fft(demodulated_signal)/length(demodulated_signal);
demodulated_f = fftshift(demodulated_f);

% Calculating the signal wrap. 
demodulated_wrap = abs(hilbert(demodulated_signal));

% Plotting the modulated and demodulated signals on time domain:
figure(3)
subplot(311)
plot(t, modulated_signal, 'k', 'LineWidth', 2)
xlim([0.00054 0.00067])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('Sinal Modulado FM (Domínio do Tempo)')

subplot(312)
plot(t, demodulated_signal, 'b', 'LineWidth', 2)
xlim([0.00054 0.00067])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('Sinal Demodulado FM (Domínio do Tempo)')

subplot(313)
plot(t, demodulated_wrap, 'r--', 'LineWidth', 2)
xlim([0.00054 0.00067])
xlabel('Tempo (s)')
ylabel('Amplitude')
title('Envoltória do Sinal Demodulado FM (Domínio do Tempo)')

figure(4)
subplot(211)
plot(f, demodulated_f, 'k', 'LineWidth', 2)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Demodulated Signal (Frequency Domain)')
xlim([-f_carrier*1.2 f_carrier*1.2])
ylim([0 A_carrier/1000])

subplot(212)
plot(f, abs(demodulated_f), 'k', 'LineWidth', 2)
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Absolute Demodulated Signal (Frequency Domain)')
xlim([-f_carrier*1.2 f_carrier*1.2])
ylim([0 A_carrier/1000])
