//the probability of the population of Gbg reaching 50 within 20 s
//P(G_bg -> 50 |20s) 3. results = 1.2e-6
ctmc

const double k1 = .0038;
const double k2 = .0004;
const double k3 = .0420;
const double k4 = .0100;
const double k5 = .0110;
const double k6 = .1000;
const double k7 = 1050;
const double k8 = 3.21;


const int MAX_AMOUNT = 150;

module R_def

    R_ : [0..MAX_AMOUNT] init 50;

    [R1] R_<=MAX_AMOUNT-1    -> (R_' = R_ + 1);
    [R2] R_>0                -> (R_' = R_ - 1);
    [R3] R_>0                -> (R_' = R_ - 1);
    [R4] R_<=MAX_AMOUNT-1    -> (R_' = R_ + 1);
endmodule

module L
    L : [0..MAX_AMOUNT] init 2;

    [R3] L<=MAX_AMOUNT-1        -> (L' = L);
endmodule

module RL
    RL : [0..MAX_AMOUNT] init 0;

    [R3] RL<=MAX_AMOUNT-1   -> (RL' = RL + 1);
    [R4] RL>0               -> (RL' = RL - 1);
    [R5] RL>0               -> (RL' = RL - 1);
    [R8] RL<=MAX_AMOUNT-1   -> (RL' = RL + 1);
endmodule

module G_def
    G_ : [0..MAX_AMOUNT] init 50;

    [R5] G_>0                -> (G_' = G_ - 1);
    [R7] G_<=MAX_AMOUNT-1    -> (G_' = G_ + 1);
endmodule

module G_a
    G_a : [0..MAX_AMOUNT] init 0;

    [R5] G_a<=MAX_AMOUNT-1  -> (G_a' = G_a + 1);
    [R6] G_a>0              -> (G_a' = G_a - 1);
endmodule

module G_bg
    G_bg : [0..MAX_AMOUNT] init 0;

    [R5] G_bg<=MAX_AMOUNT-1 -> (G_bg' = G_bg + 1);
    [R7] G_bg>0             -> (G_bg' = G_bg - 1);
endmodule

module G_d
    G_d : [0..MAX_AMOUNT] init 0;

    [R6] G_d<=MAX_AMOUNT-1  -> (G_d' = G_d + 1);
    [R7] G_d>0              -> (G_d' = G_d - 1);
endmodule

// Empty set rate reaction represented by 1??
module reactionRates
    [R1] k1>0               -> k1 : true;
    [R2] (k2*R_)>0       -> (k2*R_) : true;
    [R3] (k3*R_*L)>0     -> (k3*R_*L) : true;
    [R4] (k4*RL)>0      -> (k4*RL) : true;
    [R5] (k5*RL*G_)>0      -> (k5*RL*G_) : true;
    [R6] (k6*G_a)>0     -> (k6*G_a) : true;
    [R7] (k7 * G_bg * G_d)>0    -> (k7 * G_bg * G_d) : true;
    [R8] k8>0           -> k8 : true;
endmodule


// Suppress R6 to shutoff the cycle
label "constraint" = G_d=0;

// Objective: G_bg reaches 50
label "objective" = G_bg=50; 

