function [b, a] = getBiquadCoeff(typ, sr, cf, Q, GdB)


    omega = 2 * pi * cf/sr;
    sn = sin(omega);
    cs = cos(omega);
    alpha = sn / (2 * Q);

    b = [1,0,0];
    a = [1,0,0];

    switch typ
        case 'BP1'
            b = [alpha, 0, -alpha];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'BP2'
            b = [Q*alpha, 0, -Q*alpha];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'LP'
            t1 = 1-cs; t2 = t1/2;
            b = [t2, t1, t2];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'HP'
            t1 = 1+cs; t2 = t1/2;
            b = [t2, -t1, t2];    
            a = [1+alpha, -2*cs, 1-alpha];
        case 'NC'
            t1 = -2*cs;
            b = [1, t1, 1];
            a = [1+alpha, t1, 1-alpha];
        case 'AP'
            b = [1-alpha, -2*cs, 1+alpha];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'PK'
            G = 10^(GdB/40);
            t1 = alpha * G;
            t2 = alpha / G;
            t3 = -2*cs;
            b = [1+t1, t3, 1-t1];
            a = [1+t2, t3, 1-t2];
        case 'LS1'
            G = 10^(GdB/40);
            beta = sqrt(2 * G) * sn;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t1+beta), 2*G*t2, G*(t1-beta)];
            a = [t3+beta, -2*t4, t3-beta];
        case 'HS1'
            G = 10^(GdB/40);
            beta = sqrt(2 * G) * sn;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t3+beta), -2*G*t4, G*(t3-beta)];
            a = [t1+beta, 2*t2, t1-beta];
        case 'LS2'
            G = 10^(GdB/40);
            beta = sn * sqrt(G) / Q;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t1+beta), 2*G*t2, G*(t1-beta)];
            a = [t3+beta, -2*t4, t3-beta];
        case 'HS2'
            G = 10^(GdB/40);
            beta = sn * sqrt(G) / Q;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t3+beta), -2*G*t4, G*(t3-beta)];
            a = [t1+beta, 2*t2, t1-beta];
        otherwise
    end

    b = b./a(1);
    a = a./a(1);

end

%         center_freq = cf;
%         gain_abs = Math.pow(10, gainDB / 40);
%         double omega = 2 * Math.PI * cf / sample_rate;
%         double sn = Math.sin(omega);
%         double cs = Math.cos(omega);
%         double alpha = sn / (2 * Q);
%         double beta = Math.sqrt(gain_abs + gain_abs);

%             case BANDPASS:
%                 b0 = alpha;
%                 b1 = 0;
%                 b2 = -alpha;
%                 a0 = 1 + alpha;
%                 a1 = -2 * cs;
%                 a2 = 1 - alpha;
%                 break;
%             case LOWPASS:
%                 b0 = (1 - cs) / 2;
%                 b1 = 1 - cs;
%                 b2 = (1 - cs) / 2;
%                 a0 = 1 + alpha;
%                 a1 = -2 * cs;
%                 a2 = 1 - alpha;
%                 break;
%             case HIGHPASS:
%                 b0 = (1 + cs) / 2;
%                 b1 = -(1 + cs);
%                 b2 = (1 + cs) / 2;
%                 a0 = 1 + alpha;
%                 a1 = -2 * cs;
%                 a2 = 1 - alpha;
%                 break;
%             case NOTCH:
%                 b0 = 1;
%                 b1 = -2 * cs;
%                 b2 = 1;
%                 a0 = 1 + alpha;
%                 a1 = -2 * cs;
%                 a2 = 1 - alpha;
%                 break;
%             case PEAK:
%                 b0 = 1 + (alpha * gain_abs);
%                 b1 = -2 * cs;
%                 b2 = 1 - (alpha * gain_abs);
%                 a0 = 1 + (alpha / gain_abs);
%                 a1 = -2 * cs;
%                 a2 = 1 - (alpha / gain_abs);
%                 break;
%             case LOWSHELF:
%                 b0 = gain_abs * ((gain_abs + 1) - (gain_abs - 1) * cs + beta * sn);
%                 b1 = 2 * gain_abs * ((gain_abs - 1) - (gain_abs + 1) * cs);
%                 b2 = gain_abs * ((gain_abs + 1) - (gain_abs - 1) * cs - beta * sn);
%                 a0 = (gain_abs + 1) + (gain_abs - 1) * cs + beta * sn;
%                 a1 = -2 * ((gain_abs - 1) + (gain_abs + 1) * cs);
%                 a2 = (gain_abs + 1) + (gain_abs - 1) * cs - beta * sn;
%                 break;
%             case HIGHSHELF:
%                 b0 = gain_abs * ((gain_abs + 1) + (gain_abs - 1) * cs + beta * sn);
%                 b1 = -2 * gain_abs * ((gain_abs - 1) + (gain_abs + 1) * cs);
%                 b2 = gain_abs * ((gain_abs + 1) + (gain_abs - 1) * cs - beta * sn);
%                 a0 = (gain_abs + 1) - (gain_abs - 1) * cs + beta * sn;
%                 a1 = 2 * ((gain_abs - 1) - (gain_abs + 1) * cs);
%                 a2 = (gain_abs + 1) - (gain_abs - 1) * cs - beta * sn;
%                 break;


