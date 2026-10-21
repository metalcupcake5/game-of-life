module game (
    input logic clk,
    input logic [5:0] pixel,
    input logic transmit_pixel,
    input logic frame_change,
    output logic [7:0] red_data,
    output logic [7:0] blue_data,
    output logic [7:0] green_data,
    output logic [63:0] board
);
    parameter INTERVAL = 6000000;
    logic [$clog2(INTERVAL) - 1:0] count = 0;
    logic state = 0;

    // blinker
    // logic [63:0] board = {{18{1'b0}}, {3{8'b10000000}}, {22{1'b0}}}; 
    // basic glider
    // logic [63:0] board = {{{1'b0}}, {{1'b1}}, {8{1'b0}}, {{1'b1}}, {5{1'b0}}, {3{1'b1}}, {45{1'b0}}};
    // beacon
    // logic [63:0] board = {{16{1'b0}}, {2{8'b00110000}}, {2{8'b00001100}}, {16{1'b0}}}; 
    // lightweight spaceship
    // logic [63:0] board = {{16{1'b0}}, {{8'b00011000}}, {{8'b00111100}}, {{8'b01101100}}, {{8'b00110000}}, {16{1'b0}}}; 

    logic [63:0] new_board = 64'b0;

    logic [1:0] red_count = 1;
    logic [1:0] green_count = 2;
    logic [1:0] blue_count = 0;

    logic red_on = 1'b0;
    logic blue_on = 1'b1;
    logic green_on = 1'b1;

    initial begin
        board <= {{16{1'b0}}, {{8'b00011000}}, {{8'b00111100}}, {{8'b01101100}}, {{8'b00110000}}, {16{1'b0}}}; 
    end


    logic row;
    logic col;

    initial begin
        // board[19] <= 1;
        // board[27] <= 1;
        // board[35] <= 1;
        // new_board[19] <= 1;
        // new_board[27] <= 1;
        // new_board[35] <= 1;
    end

    always_ff @(posedge frame_change) begin
        for (int i = 0; i < 64; i = i + 1) begin
            // row, col
            case (
                board[{i[5:3] - 1'b1, i[2:0] - 1'b1}] + // top left
                board[{i[5:3] - 1'b1, i[2:0]}] + // top
                board[{i[5:3] - 1'b1, i[2:0] + 1'b1}] + // top right
                board[{i[5:3], i[2:0] - 1'b1}] + // left
                board[{i[5:3], i[2:0] + 1'b1}] + // right
                board[{i[5:3] + 1'b1, i[2:0] - 1'b1}] + // bottom left
                board[{i[5:3] + 1'b1, i[2:0]}] + // bottom
                board[{i[5:3] + 1'b1, i[2:0] + 1'b1}]// bottom right
            )
                0,
                1:
                    new_board[i] <= 0;
                2:
                    new_board[i] <= board[i];
                3:
                    new_board[i] <= 1;
                4,
                5,
                6,
                7,
                8:
                    new_board[i] <= 0;
            endcase
            // new_board[i] <= 
            //     board[{i[5:3] + 1'b1, i[2:0]}] 
            //     ? 1 : 0;
        end
        // out <= test[2:0];
        // out2 <= test[5:3];
    end

    always_ff @(negedge frame_change) begin
        board <= new_board;
        if (red_count == 2) begin
            red_on <= ~red_on;
        end

        if (green_count == 2) begin
            green_on <= ~green_on;
        end
        
        if (blue_count == 2) begin
            blue_on <= ~blue_on;
        end

        red_count = red_count == 2 ? 0 : red_count + 1;
        green_count = green_count == 2 ? 0 : green_count + 1;
        blue_count = blue_count == 2 ? 0 : blue_count + 1;
    end

    always_comb begin
        // out = board[63];
        // red_data = board[pixel] ? 8'b11000000 : 8'b0;
        red_data = (board[pixel] && red_on) ? '1 : 8'b0;
        blue_data = (board[pixel] && blue_on) ? '1 : 8'b0;
        green_data = (board[pixel] && green_on) ? '1 : 8'b0;
    end
endmodule 
