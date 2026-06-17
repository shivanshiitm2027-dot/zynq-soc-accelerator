module apb_gpio_pwm (
    input  wire        PCLK,
    input  wire        PRESETn,

    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [7:0]  PADDR,
    input  wire [31:0] PWDATA,

    output reg  [31:0] PRDATA,
    output wire        PREADY,

    output reg  [7:0]  gpio_out,
    output reg         pwm_out
);

    localparam GPIO_OUT_ADDR   = 8'h00;
    localparam PWM_PERIOD_ADDR = 8'h04;
    localparam PWM_DUTY_ADDR   = 8'h08;
    localparam PWM_ENABLE_ADDR = 8'h0C;

    reg [31:0] pwm_period;
    reg [31:0] pwm_duty;
    reg        pwm_enable;
    reg [31:0] pwm_counter;

    assign PREADY = 1'b1;

    wire apb_write = PSEL && PENABLE && PWRITE;
    wire apb_read  = PSEL && PENABLE && !PWRITE;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            gpio_out   <= 8'h00;
            pwm_period <= 32'd20;
            pwm_duty   <= 32'd5;
            pwm_enable <= 1'b0;
        end else begin
            if (apb_write) begin
                case (PADDR)
                    GPIO_OUT_ADDR:   gpio_out   <= PWDATA[7:0];
                    PWM_PERIOD_ADDR: pwm_period <= PWDATA;
                    PWM_DUTY_ADDR:   pwm_duty   <= PWDATA;
                    PWM_ENABLE_ADDR: pwm_enable <= PWDATA[0];
                    default: ;
                endcase
            end
        end
    end

    always @(*) begin
        PRDATA = 32'h00000000;

        if (apb_read) begin
            case (PADDR)
                GPIO_OUT_ADDR:   PRDATA = {24'h0, gpio_out};
                PWM_PERIOD_ADDR: PRDATA = pwm_period;
                PWM_DUTY_ADDR:   PRDATA = pwm_duty;
                PWM_ENABLE_ADDR: PRDATA = {31'h0, pwm_enable};
                default:         PRDATA = 32'hDEADBEEF;
            endcase
        end
    end

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            pwm_counter <= 32'd0;
            pwm_out     <= 1'b0;
        end else begin
            if (pwm_enable) begin
                if (pwm_counter >= pwm_period - 1)
                    pwm_counter <= 32'd0;
                else
                    pwm_counter <= pwm_counter + 1;

                if (pwm_counter < pwm_duty)
                    pwm_out <= 1'b1;
                else
                    pwm_out <= 1'b0;
            end else begin
                pwm_counter <= 32'd0;
                pwm_out     <= 1'b0;
            end
        end
    end

endmodule