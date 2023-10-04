extern void time_update(double Est_States_l[7], double dot_delta, double (*A_d)[7], double B_d[7],
                        double Est_States_l_1[7])
{
    double result1[7] = {0, 0, 0, 0, 0, 0, 0};
    double result2[7] = {0, 0, 0, 0, 0, 0, 0};

    // A_d*x
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            result1[i] += A_d[i][j] * Est_States_l[j];
        }
    }

    // B_d*u
    for (int k = 0; k < 7; k++)
    {
        result2[k] = B_d[k] * (dot_delta);
    }

    // Time update
    for (int h = 0; h < 7; h++)
    {
        Est_States_l_1[h] = result1[h] + result2[h];
    }
}

extern void test()
{
    double Est_States_l[7] = {1,1,1,1,1,1,1};
    double A_d[7][7] = {{1,0,0,0,0,0,0.0100000000000000},
                        {0,1,0.0200000000000000,0,0,0.00851987976179224,0},
                        {0,0,1,0,0,0.0171633355394687,0},
                        {0,0,0,1,0.0100000000000000,0,0},
                        {0,0,0,0.188835418671800,1,0.0567855743857228,0},
                        {0,0,0,0,0,1,0},
                        {0,0,0,0,0,0,1}};
    double B_d[7] = {0,0,0,0,0.0174526788578762,0.0100000000000000,0};
    double Est_States_l_1[7] = {0,0,0,0,0,0,0};
    double delta_dot = 1;
    time_update(Est_States_l, delta_dot, A_d, B_d,Est_States_l_1);
}