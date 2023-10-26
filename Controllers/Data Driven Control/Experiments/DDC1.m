% From / inspired by FORMULAS FOR DATA-DRIVEN CONTROL: STABILIZATION,
% OPTIMALITY, AND ROBUSTNESS by Claudio De Persis and Pietro Tesi

%% Example 1
A = [1.178 0.001 0.511 -0.403;
    -0.051 0.661 -0.011 0.061;
    0.076 0.335 0.560 0.382;
    0 0.335 0.089 0.849];
B = [0.004 -0.087;
    0.467 0.001;
    0.213 -0.235;
    0.213 -0.016];

[A B]

inputSequenceLengthT = 15;
