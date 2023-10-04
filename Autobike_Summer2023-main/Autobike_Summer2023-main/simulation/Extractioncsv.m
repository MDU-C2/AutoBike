clc
close all
clear all
% Specify the path to your CSV file
csvFilePath = 'trajectorymat_asta0_infinite.csv';

% Read the CSV file into a table
dataTable = readtable(csvFilePath);

