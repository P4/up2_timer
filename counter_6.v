module counter_6 (
    // wejscia aktywowane zboczem narastajacym
    // w chwili aktywacji jednego wejscia
    // drugie musi byc w stanie wysokim

    INC, // Q = Q+1
    DEC, // Q = Q-1

    // zerowanie, niezaleznie od wejsc INC,DEC
    CLR, // zerowanie stanem niskim

    Q,   // aktualny stan Q, wartosci 0..5

    // flagi zachowuja sie jak wejscia INC, DEC
    CARRY, // przeniesienie
    BORROW // pozyczka
);

input INC; wire U = ~INC;
input DEC; wire D = ~DEC;
input CLR;

output reg [2:0] Q;

output CARRY = ~&{U,Q[2],Q[0]}; // U , Q=1_1
output BORROW = ~&{D,~Q};       // D , Q=000

// choose which bits to toggle
wire [2:0] T; //inputs for toggles
wire X = |Q[2:1];               // Q != 00_
assign T[0] = ~( U | D );
assign T[1] = ~| {
    (U & ~Q[2] & Q[0]),         // U , Q = 0_1
    (D & ~Q[0] & X)             // D , Q = __0 != 00_
};
assign T[2] = ~| {
    ( U & Q[1] & Q[0] ),        // U , Q = _11
    ( U & Q[2] & Q[0] ),        // U , Q = 1_1
    ( D & ~Q[1] & ~Q[0] )       // D , Q = _00
};

//toggle based on T
always @(posedge T[0], negedge CLR) Q[0] <= (~CLR) ? 1'b0 : ~Q[0];
always @(posedge T[1], negedge CLR) Q[1] <= (~CLR) ? 1'b0 : ~Q[1];
always @(posedge T[2], negedge CLR) Q[2] <= (~CLR) ? 1'b0 : ~Q[2];

endmodule
