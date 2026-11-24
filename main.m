pkg load image;
clc;
clear;
close all;

% =========================
% INPUT GAMBAR
% =========================
img = imread('unsplash/noise.jpeg');

figure;
imshow(img);
title('Citra Asli');

% =========================
% PILIH PAKAI NOISE ATAU TIDAK
% =========================
pakai_noise = true;

if pakai_noise

    % Tambahkan Gaussian Noise
    noise_img = imnoise(img, 'gaussian', 0, 0.01);

    figure;
    imshow(noise_img);
    title('Citra dengan Gaussian Noise');

    % Input Gaussian Filtering dari noise
    gaussian_input = noise_img;

else

    % Langsung gunakan citra asli
    gaussian_input = img;

end

% ======================================================
% GAUSSIAN FILTERING + HISTOGRAM EQUALIZATION
% ======================================================

gaussian_img = imgaussfilt(gaussian_input, 2);

figure;
imshow(gaussian_img);
title('Gaussian Filtering');

% Convert grayscale
gray_img = rgb2gray(gaussian_img);

figure;
imshow(gray_img);
title('Grayscale Gaussian');

% Histogram Equalization
hist_img = histeq(gray_img);

% Normalisasi intensitas
hist_img = im2uint8(mat2gray(hist_img));

figure;
imshow(hist_img);
title('Histogram Gaussian');

% ======================================================
% BILATERAL FILTERING + HISTOGRAM EQUALIZATION
% ======================================================

% NOTE:
% Jika imsmooth error di Octave,
% comment bagian bilateral ini

bilateral_img = imsmooth(gaussian_input, "Bilateral");

figure;
imshow(bilateral_img);
title('Bilateral Filtering');

% Convert grayscale
bilateral_gray = rgb2gray(bilateral_img);

figure;
imshow(bilateral_gray);
title('Grayscale Bilateral');

% Histogram Equalization
bilateral_hist = histeq(bilateral_gray);

% Normalisasi intensitas
bilateral_hist = im2uint8(mat2gray(bilateral_hist));

figure;
imshow(bilateral_hist);
title('Histogram Bilateral');

% ======================================================
% EVALUASI
% ======================================================

% Convert original image ke grayscale
original_gray = rgb2gray(img);

% Samakan tipe data
original_gray = uint8(original_gray);

hist_img = uint8(hist_img);
bilateral_hist = uint8(bilateral_hist);

% ======================================================
% MSE & PSNR GAUSSIAN
% ======================================================

mse_gaussian = mean((double(original_gray(:)) - double(hist_img(:))).^2);

MAX = 255;
psnr_gaussian = 10 * log10((MAX^2) / mse_gaussian);

% ======================================================
% MSE & PSNR BILATERAL
% ======================================================

mse_bilateral = mean((double(original_gray(:)) - double(bilateral_hist(:))).^2);

psnr_bilateral = 10 * log10((MAX^2) / mse_bilateral);

% ======================================================
% OUTPUT EVALUASI
% ======================================================

fprintf('\n=== GAUSSIAN FILTERING ===\n');
fprintf('MSE  : %.4f\n', mse_gaussian);
fprintf('PSNR : %.4f dB\n', psnr_gaussian);

fprintf('\n=== BILATERAL FILTERING ===\n');
fprintf('MSE  : %.4f\n', mse_bilateral);
fprintf('PSNR : %.4f dB\n', psnr_bilateral);

% ======================================================
% TAMPILKAN SEMUA HASIL
% ======================================================

figure;

subplot(2,3,1);
imshow(img);
title('Citra Asli');

subplot(2,3,2);

if pakai_noise
    imshow(noise_img);
    title('Gaussian Noise');
else
    imshow(gaussian_input);
    title('Tanpa Noise');
end

subplot(2,3,3);
imshow(gaussian_img);
title('Gaussian Filtering');

subplot(2,3,4);
imshow(hist_img, []);
title('Histogram Gaussian');

subplot(2,3,5);
imshow(bilateral_img);
title('Bilateral Filtering');

subplot(2,3,6);
imshow(bilateral_hist, []);
title('Histogram Bilateral');

% =========================
% SIMPAN HASIL
% =========================

if ~exist('hasil', 'dir')
    mkdir('hasil');
end

imwrite(uint8(hist_img), 'hasil/hasilnoise_gaussian.jpg');

imwrite(uint8(bilateral_hist), 'hasil/hasilnoise_bilateral.jpg');
