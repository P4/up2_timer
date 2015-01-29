module counter_10 (
    // wejscia aktywowane zboczem narastajacym
    // w chwili aktywacji jednego wejscia
    // drugie musi byc w stanie wysokim

    INC, // Q = Q+1
    DEC, // Q = Q-1

    // zerowanie, niezaleznie od wejsc INC,DEC
    CLR, // zerowanie stanem wysokim

    Q,   // aktualny stan Q, wartosci 0..9

    // flagi zachowuja sie jak wejscia INC, DEC
    CARRY, // przeniesienie
    BORROW // pozyczka
);

input INC; wire U = ~INC;
input DEC; wire D = ~DEC;
input CLR;

output reg [3:0] Q;

output CARRY = ~( U & Q[0] & Q[3] ); // U , Q=1__1
output BORROW = ~&{D,~Q};            // D , Q=0000

// choose which bits to toggle
wire [3:0] T; //inputs for toggles
wire X = |Q[3:1];                    // Q != 000_
assign T[0] = ~( U | D );
assign T[1] = ~| {
    (U & ~Q[3] & Q[0]),              // U , Q = 0__1
    (D & ~Q[0] & X)                  // D , Q = ___0 != 000_
};
assign T[2] = ~| {
    ( U & Q[0] & Q[1] ),             // U , Q = __11
    ( D & X & ~Q[0] & ~Q[1] )        // D , Q = __00 != 000_
};
assign T[3] = ~| {
    ( U & Q[2] & Q[1] & Q[0] ),      // U , Q = _111
    ( U & Q[3] & Q[0] ),             // U , Q = 1__1
    ( D & ~Q[2] & ~Q[0] & ~Q[1])     // D , Q = _000
};

//toggle based on T
always @(posedge T[0], negedge CLR) Q[0] <= (~CLR) ? 1'b0 : ~Q[0];
always @(posedge T[1], negedge CLR) Q[1] <= (~CLR) ? 1'b0 : ~Q[1];
always @(posedge T[2], negedge CLR) Q[2] <= (~CLR) ? 1'b0 : ~Q[2];
always @(posedge T[3], negedge CLR) Q[3] <= (~CLR) ? 1'b0 : ~Q[3];

endmodule
