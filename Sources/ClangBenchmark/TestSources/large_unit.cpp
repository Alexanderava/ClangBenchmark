#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <algorithm>
#include <numeric>
#include <random>
#include <map>
#include <functional>

inline double func_0(double x) {
    return std::sin(x * (0 * 0.01 + 1.0)) * std::cos(x * (0 * 0.005 + 0.5))
         + std::exp(-x * (0 * 0.001)) * (0 * 0.1);
}

inline double func_1(double x) {
    return std::sin(x * (1 * 0.01 + 1.0)) * std::cos(x * (1 * 0.005 + 0.5))
         + std::exp(-x * (1 * 0.001)) * (1 * 0.1);
}

inline double func_2(double x) {
    return std::sin(x * (2 * 0.01 + 1.0)) * std::cos(x * (2 * 0.005 + 0.5))
         + std::exp(-x * (2 * 0.001)) * (2 * 0.1);
}

inline double func_3(double x) {
    return std::sin(x * (3 * 0.01 + 1.0)) * std::cos(x * (3 * 0.005 + 0.5))
         + std::exp(-x * (3 * 0.001)) * (3 * 0.1);
}

inline double func_4(double x) {
    return std::sin(x * (4 * 0.01 + 1.0)) * std::cos(x * (4 * 0.005 + 0.5))
         + std::exp(-x * (4 * 0.001)) * (4 * 0.1);
}

inline double func_5(double x) {
    return std::sin(x * (5 * 0.01 + 1.0)) * std::cos(x * (5 * 0.005 + 0.5))
         + std::exp(-x * (5 * 0.001)) * (5 * 0.1);
}

inline double func_6(double x) {
    return std::sin(x * (6 * 0.01 + 1.0)) * std::cos(x * (6 * 0.005 + 0.5))
         + std::exp(-x * (6 * 0.001)) * (6 * 0.1);
}

inline double func_7(double x) {
    return std::sin(x * (7 * 0.01 + 1.0)) * std::cos(x * (7 * 0.005 + 0.5))
         + std::exp(-x * (7 * 0.001)) * (7 * 0.1);
}

inline double func_8(double x) {
    return std::sin(x * (8 * 0.01 + 1.0)) * std::cos(x * (8 * 0.005 + 0.5))
         + std::exp(-x * (8 * 0.001)) * (8 * 0.1);
}

inline double func_9(double x) {
    return std::sin(x * (9 * 0.01 + 1.0)) * std::cos(x * (9 * 0.005 + 0.5))
         + std::exp(-x * (9 * 0.001)) * (9 * 0.1);
}

inline double func_10(double x) {
    return std::sin(x * (10 * 0.01 + 1.0)) * std::cos(x * (10 * 0.005 + 0.5))
         + std::exp(-x * (10 * 0.001)) * (10 * 0.1);
}

inline double func_11(double x) {
    return std::sin(x * (11 * 0.01 + 1.0)) * std::cos(x * (11 * 0.005 + 0.5))
         + std::exp(-x * (11 * 0.001)) * (11 * 0.1);
}

inline double func_12(double x) {
    return std::sin(x * (12 * 0.01 + 1.0)) * std::cos(x * (12 * 0.005 + 0.5))
         + std::exp(-x * (12 * 0.001)) * (12 * 0.1);
}

inline double func_13(double x) {
    return std::sin(x * (13 * 0.01 + 1.0)) * std::cos(x * (13 * 0.005 + 0.5))
         + std::exp(-x * (13 * 0.001)) * (13 * 0.1);
}

inline double func_14(double x) {
    return std::sin(x * (14 * 0.01 + 1.0)) * std::cos(x * (14 * 0.005 + 0.5))
         + std::exp(-x * (14 * 0.001)) * (14 * 0.1);
}

inline double func_15(double x) {
    return std::sin(x * (15 * 0.01 + 1.0)) * std::cos(x * (15 * 0.005 + 0.5))
         + std::exp(-x * (15 * 0.001)) * (15 * 0.1);
}

inline double func_16(double x) {
    return std::sin(x * (16 * 0.01 + 1.0)) * std::cos(x * (16 * 0.005 + 0.5))
         + std::exp(-x * (16 * 0.001)) * (16 * 0.1);
}

inline double func_17(double x) {
    return std::sin(x * (17 * 0.01 + 1.0)) * std::cos(x * (17 * 0.005 + 0.5))
         + std::exp(-x * (17 * 0.001)) * (17 * 0.1);
}

inline double func_18(double x) {
    return std::sin(x * (18 * 0.01 + 1.0)) * std::cos(x * (18 * 0.005 + 0.5))
         + std::exp(-x * (18 * 0.001)) * (18 * 0.1);
}

inline double func_19(double x) {
    return std::sin(x * (19 * 0.01 + 1.0)) * std::cos(x * (19 * 0.005 + 0.5))
         + std::exp(-x * (19 * 0.001)) * (19 * 0.1);
}

inline double func_20(double x) {
    return std::sin(x * (20 * 0.01 + 1.0)) * std::cos(x * (20 * 0.005 + 0.5))
         + std::exp(-x * (20 * 0.001)) * (20 * 0.1);
}

inline double func_21(double x) {
    return std::sin(x * (21 * 0.01 + 1.0)) * std::cos(x * (21 * 0.005 + 0.5))
         + std::exp(-x * (21 * 0.001)) * (21 * 0.1);
}

inline double func_22(double x) {
    return std::sin(x * (22 * 0.01 + 1.0)) * std::cos(x * (22 * 0.005 + 0.5))
         + std::exp(-x * (22 * 0.001)) * (22 * 0.1);
}

inline double func_23(double x) {
    return std::sin(x * (23 * 0.01 + 1.0)) * std::cos(x * (23 * 0.005 + 0.5))
         + std::exp(-x * (23 * 0.001)) * (23 * 0.1);
}

inline double func_24(double x) {
    return std::sin(x * (24 * 0.01 + 1.0)) * std::cos(x * (24 * 0.005 + 0.5))
         + std::exp(-x * (24 * 0.001)) * (24 * 0.1);
}

inline double func_25(double x) {
    return std::sin(x * (25 * 0.01 + 1.0)) * std::cos(x * (25 * 0.005 + 0.5))
         + std::exp(-x * (25 * 0.001)) * (25 * 0.1);
}

inline double func_26(double x) {
    return std::sin(x * (26 * 0.01 + 1.0)) * std::cos(x * (26 * 0.005 + 0.5))
         + std::exp(-x * (26 * 0.001)) * (26 * 0.1);
}

inline double func_27(double x) {
    return std::sin(x * (27 * 0.01 + 1.0)) * std::cos(x * (27 * 0.005 + 0.5))
         + std::exp(-x * (27 * 0.001)) * (27 * 0.1);
}

inline double func_28(double x) {
    return std::sin(x * (28 * 0.01 + 1.0)) * std::cos(x * (28 * 0.005 + 0.5))
         + std::exp(-x * (28 * 0.001)) * (28 * 0.1);
}

inline double func_29(double x) {
    return std::sin(x * (29 * 0.01 + 1.0)) * std::cos(x * (29 * 0.005 + 0.5))
         + std::exp(-x * (29 * 0.001)) * (29 * 0.1);
}

inline double func_30(double x) {
    return std::sin(x * (30 * 0.01 + 1.0)) * std::cos(x * (30 * 0.005 + 0.5))
         + std::exp(-x * (30 * 0.001)) * (30 * 0.1);
}

inline double func_31(double x) {
    return std::sin(x * (31 * 0.01 + 1.0)) * std::cos(x * (31 * 0.005 + 0.5))
         + std::exp(-x * (31 * 0.001)) * (31 * 0.1);
}

inline double func_32(double x) {
    return std::sin(x * (32 * 0.01 + 1.0)) * std::cos(x * (32 * 0.005 + 0.5))
         + std::exp(-x * (32 * 0.001)) * (32 * 0.1);
}

inline double func_33(double x) {
    return std::sin(x * (33 * 0.01 + 1.0)) * std::cos(x * (33 * 0.005 + 0.5))
         + std::exp(-x * (33 * 0.001)) * (33 * 0.1);
}

inline double func_34(double x) {
    return std::sin(x * (34 * 0.01 + 1.0)) * std::cos(x * (34 * 0.005 + 0.5))
         + std::exp(-x * (34 * 0.001)) * (34 * 0.1);
}

inline double func_35(double x) {
    return std::sin(x * (35 * 0.01 + 1.0)) * std::cos(x * (35 * 0.005 + 0.5))
         + std::exp(-x * (35 * 0.001)) * (35 * 0.1);
}

inline double func_36(double x) {
    return std::sin(x * (36 * 0.01 + 1.0)) * std::cos(x * (36 * 0.005 + 0.5))
         + std::exp(-x * (36 * 0.001)) * (36 * 0.1);
}

inline double func_37(double x) {
    return std::sin(x * (37 * 0.01 + 1.0)) * std::cos(x * (37 * 0.005 + 0.5))
         + std::exp(-x * (37 * 0.001)) * (37 * 0.1);
}

inline double func_38(double x) {
    return std::sin(x * (38 * 0.01 + 1.0)) * std::cos(x * (38 * 0.005 + 0.5))
         + std::exp(-x * (38 * 0.001)) * (38 * 0.1);
}

inline double func_39(double x) {
    return std::sin(x * (39 * 0.01 + 1.0)) * std::cos(x * (39 * 0.005 + 0.5))
         + std::exp(-x * (39 * 0.001)) * (39 * 0.1);
}

inline double func_40(double x) {
    return std::sin(x * (40 * 0.01 + 1.0)) * std::cos(x * (40 * 0.005 + 0.5))
         + std::exp(-x * (40 * 0.001)) * (40 * 0.1);
}

inline double func_41(double x) {
    return std::sin(x * (41 * 0.01 + 1.0)) * std::cos(x * (41 * 0.005 + 0.5))
         + std::exp(-x * (41 * 0.001)) * (41 * 0.1);
}

inline double func_42(double x) {
    return std::sin(x * (42 * 0.01 + 1.0)) * std::cos(x * (42 * 0.005 + 0.5))
         + std::exp(-x * (42 * 0.001)) * (42 * 0.1);
}

inline double func_43(double x) {
    return std::sin(x * (43 * 0.01 + 1.0)) * std::cos(x * (43 * 0.005 + 0.5))
         + std::exp(-x * (43 * 0.001)) * (43 * 0.1);
}

inline double func_44(double x) {
    return std::sin(x * (44 * 0.01 + 1.0)) * std::cos(x * (44 * 0.005 + 0.5))
         + std::exp(-x * (44 * 0.001)) * (44 * 0.1);
}

inline double func_45(double x) {
    return std::sin(x * (45 * 0.01 + 1.0)) * std::cos(x * (45 * 0.005 + 0.5))
         + std::exp(-x * (45 * 0.001)) * (45 * 0.1);
}

inline double func_46(double x) {
    return std::sin(x * (46 * 0.01 + 1.0)) * std::cos(x * (46 * 0.005 + 0.5))
         + std::exp(-x * (46 * 0.001)) * (46 * 0.1);
}

inline double func_47(double x) {
    return std::sin(x * (47 * 0.01 + 1.0)) * std::cos(x * (47 * 0.005 + 0.5))
         + std::exp(-x * (47 * 0.001)) * (47 * 0.1);
}

inline double func_48(double x) {
    return std::sin(x * (48 * 0.01 + 1.0)) * std::cos(x * (48 * 0.005 + 0.5))
         + std::exp(-x * (48 * 0.001)) * (48 * 0.1);
}

inline double func_49(double x) {
    return std::sin(x * (49 * 0.01 + 1.0)) * std::cos(x * (49 * 0.005 + 0.5))
         + std::exp(-x * (49 * 0.001)) * (49 * 0.1);
}

inline double func_50(double x) {
    return std::sin(x * (50 * 0.01 + 1.0)) * std::cos(x * (50 * 0.005 + 0.5))
         + std::exp(-x * (50 * 0.001)) * (50 * 0.1);
}

inline double func_51(double x) {
    return std::sin(x * (51 * 0.01 + 1.0)) * std::cos(x * (51 * 0.005 + 0.5))
         + std::exp(-x * (51 * 0.001)) * (51 * 0.1);
}

inline double func_52(double x) {
    return std::sin(x * (52 * 0.01 + 1.0)) * std::cos(x * (52 * 0.005 + 0.5))
         + std::exp(-x * (52 * 0.001)) * (52 * 0.1);
}

inline double func_53(double x) {
    return std::sin(x * (53 * 0.01 + 1.0)) * std::cos(x * (53 * 0.005 + 0.5))
         + std::exp(-x * (53 * 0.001)) * (53 * 0.1);
}

inline double func_54(double x) {
    return std::sin(x * (54 * 0.01 + 1.0)) * std::cos(x * (54 * 0.005 + 0.5))
         + std::exp(-x * (54 * 0.001)) * (54 * 0.1);
}

inline double func_55(double x) {
    return std::sin(x * (55 * 0.01 + 1.0)) * std::cos(x * (55 * 0.005 + 0.5))
         + std::exp(-x * (55 * 0.001)) * (55 * 0.1);
}

inline double func_56(double x) {
    return std::sin(x * (56 * 0.01 + 1.0)) * std::cos(x * (56 * 0.005 + 0.5))
         + std::exp(-x * (56 * 0.001)) * (56 * 0.1);
}

inline double func_57(double x) {
    return std::sin(x * (57 * 0.01 + 1.0)) * std::cos(x * (57 * 0.005 + 0.5))
         + std::exp(-x * (57 * 0.001)) * (57 * 0.1);
}

inline double func_58(double x) {
    return std::sin(x * (58 * 0.01 + 1.0)) * std::cos(x * (58 * 0.005 + 0.5))
         + std::exp(-x * (58 * 0.001)) * (58 * 0.1);
}

inline double func_59(double x) {
    return std::sin(x * (59 * 0.01 + 1.0)) * std::cos(x * (59 * 0.005 + 0.5))
         + std::exp(-x * (59 * 0.001)) * (59 * 0.1);
}

inline double func_60(double x) {
    return std::sin(x * (60 * 0.01 + 1.0)) * std::cos(x * (60 * 0.005 + 0.5))
         + std::exp(-x * (60 * 0.001)) * (60 * 0.1);
}

inline double func_61(double x) {
    return std::sin(x * (61 * 0.01 + 1.0)) * std::cos(x * (61 * 0.005 + 0.5))
         + std::exp(-x * (61 * 0.001)) * (61 * 0.1);
}

inline double func_62(double x) {
    return std::sin(x * (62 * 0.01 + 1.0)) * std::cos(x * (62 * 0.005 + 0.5))
         + std::exp(-x * (62 * 0.001)) * (62 * 0.1);
}

inline double func_63(double x) {
    return std::sin(x * (63 * 0.01 + 1.0)) * std::cos(x * (63 * 0.005 + 0.5))
         + std::exp(-x * (63 * 0.001)) * (63 * 0.1);
}

inline double func_64(double x) {
    return std::sin(x * (64 * 0.01 + 1.0)) * std::cos(x * (64 * 0.005 + 0.5))
         + std::exp(-x * (64 * 0.001)) * (64 * 0.1);
}

inline double func_65(double x) {
    return std::sin(x * (65 * 0.01 + 1.0)) * std::cos(x * (65 * 0.005 + 0.5))
         + std::exp(-x * (65 * 0.001)) * (65 * 0.1);
}

inline double func_66(double x) {
    return std::sin(x * (66 * 0.01 + 1.0)) * std::cos(x * (66 * 0.005 + 0.5))
         + std::exp(-x * (66 * 0.001)) * (66 * 0.1);
}

inline double func_67(double x) {
    return std::sin(x * (67 * 0.01 + 1.0)) * std::cos(x * (67 * 0.005 + 0.5))
         + std::exp(-x * (67 * 0.001)) * (67 * 0.1);
}

inline double func_68(double x) {
    return std::sin(x * (68 * 0.01 + 1.0)) * std::cos(x * (68 * 0.005 + 0.5))
         + std::exp(-x * (68 * 0.001)) * (68 * 0.1);
}

inline double func_69(double x) {
    return std::sin(x * (69 * 0.01 + 1.0)) * std::cos(x * (69 * 0.005 + 0.5))
         + std::exp(-x * (69 * 0.001)) * (69 * 0.1);
}

inline double func_70(double x) {
    return std::sin(x * (70 * 0.01 + 1.0)) * std::cos(x * (70 * 0.005 + 0.5))
         + std::exp(-x * (70 * 0.001)) * (70 * 0.1);
}

inline double func_71(double x) {
    return std::sin(x * (71 * 0.01 + 1.0)) * std::cos(x * (71 * 0.005 + 0.5))
         + std::exp(-x * (71 * 0.001)) * (71 * 0.1);
}

inline double func_72(double x) {
    return std::sin(x * (72 * 0.01 + 1.0)) * std::cos(x * (72 * 0.005 + 0.5))
         + std::exp(-x * (72 * 0.001)) * (72 * 0.1);
}

inline double func_73(double x) {
    return std::sin(x * (73 * 0.01 + 1.0)) * std::cos(x * (73 * 0.005 + 0.5))
         + std::exp(-x * (73 * 0.001)) * (73 * 0.1);
}

inline double func_74(double x) {
    return std::sin(x * (74 * 0.01 + 1.0)) * std::cos(x * (74 * 0.005 + 0.5))
         + std::exp(-x * (74 * 0.001)) * (74 * 0.1);
}

inline double func_75(double x) {
    return std::sin(x * (75 * 0.01 + 1.0)) * std::cos(x * (75 * 0.005 + 0.5))
         + std::exp(-x * (75 * 0.001)) * (75 * 0.1);
}

inline double func_76(double x) {
    return std::sin(x * (76 * 0.01 + 1.0)) * std::cos(x * (76 * 0.005 + 0.5))
         + std::exp(-x * (76 * 0.001)) * (76 * 0.1);
}

inline double func_77(double x) {
    return std::sin(x * (77 * 0.01 + 1.0)) * std::cos(x * (77 * 0.005 + 0.5))
         + std::exp(-x * (77 * 0.001)) * (77 * 0.1);
}

inline double func_78(double x) {
    return std::sin(x * (78 * 0.01 + 1.0)) * std::cos(x * (78 * 0.005 + 0.5))
         + std::exp(-x * (78 * 0.001)) * (78 * 0.1);
}

inline double func_79(double x) {
    return std::sin(x * (79 * 0.01 + 1.0)) * std::cos(x * (79 * 0.005 + 0.5))
         + std::exp(-x * (79 * 0.001)) * (79 * 0.1);
}

inline double func_80(double x) {
    return std::sin(x * (80 * 0.01 + 1.0)) * std::cos(x * (80 * 0.005 + 0.5))
         + std::exp(-x * (80 * 0.001)) * (80 * 0.1);
}

inline double func_81(double x) {
    return std::sin(x * (81 * 0.01 + 1.0)) * std::cos(x * (81 * 0.005 + 0.5))
         + std::exp(-x * (81 * 0.001)) * (81 * 0.1);
}

inline double func_82(double x) {
    return std::sin(x * (82 * 0.01 + 1.0)) * std::cos(x * (82 * 0.005 + 0.5))
         + std::exp(-x * (82 * 0.001)) * (82 * 0.1);
}

inline double func_83(double x) {
    return std::sin(x * (83 * 0.01 + 1.0)) * std::cos(x * (83 * 0.005 + 0.5))
         + std::exp(-x * (83 * 0.001)) * (83 * 0.1);
}

inline double func_84(double x) {
    return std::sin(x * (84 * 0.01 + 1.0)) * std::cos(x * (84 * 0.005 + 0.5))
         + std::exp(-x * (84 * 0.001)) * (84 * 0.1);
}

inline double func_85(double x) {
    return std::sin(x * (85 * 0.01 + 1.0)) * std::cos(x * (85 * 0.005 + 0.5))
         + std::exp(-x * (85 * 0.001)) * (85 * 0.1);
}

inline double func_86(double x) {
    return std::sin(x * (86 * 0.01 + 1.0)) * std::cos(x * (86 * 0.005 + 0.5))
         + std::exp(-x * (86 * 0.001)) * (86 * 0.1);
}

inline double func_87(double x) {
    return std::sin(x * (87 * 0.01 + 1.0)) * std::cos(x * (87 * 0.005 + 0.5))
         + std::exp(-x * (87 * 0.001)) * (87 * 0.1);
}

inline double func_88(double x) {
    return std::sin(x * (88 * 0.01 + 1.0)) * std::cos(x * (88 * 0.005 + 0.5))
         + std::exp(-x * (88 * 0.001)) * (88 * 0.1);
}

inline double func_89(double x) {
    return std::sin(x * (89 * 0.01 + 1.0)) * std::cos(x * (89 * 0.005 + 0.5))
         + std::exp(-x * (89 * 0.001)) * (89 * 0.1);
}

inline double func_90(double x) {
    return std::sin(x * (90 * 0.01 + 1.0)) * std::cos(x * (90 * 0.005 + 0.5))
         + std::exp(-x * (90 * 0.001)) * (90 * 0.1);
}

inline double func_91(double x) {
    return std::sin(x * (91 * 0.01 + 1.0)) * std::cos(x * (91 * 0.005 + 0.5))
         + std::exp(-x * (91 * 0.001)) * (91 * 0.1);
}

inline double func_92(double x) {
    return std::sin(x * (92 * 0.01 + 1.0)) * std::cos(x * (92 * 0.005 + 0.5))
         + std::exp(-x * (92 * 0.001)) * (92 * 0.1);
}

inline double func_93(double x) {
    return std::sin(x * (93 * 0.01 + 1.0)) * std::cos(x * (93 * 0.005 + 0.5))
         + std::exp(-x * (93 * 0.001)) * (93 * 0.1);
}

inline double func_94(double x) {
    return std::sin(x * (94 * 0.01 + 1.0)) * std::cos(x * (94 * 0.005 + 0.5))
         + std::exp(-x * (94 * 0.001)) * (94 * 0.1);
}

inline double func_95(double x) {
    return std::sin(x * (95 * 0.01 + 1.0)) * std::cos(x * (95 * 0.005 + 0.5))
         + std::exp(-x * (95 * 0.001)) * (95 * 0.1);
}

inline double func_96(double x) {
    return std::sin(x * (96 * 0.01 + 1.0)) * std::cos(x * (96 * 0.005 + 0.5))
         + std::exp(-x * (96 * 0.001)) * (96 * 0.1);
}

inline double func_97(double x) {
    return std::sin(x * (97 * 0.01 + 1.0)) * std::cos(x * (97 * 0.005 + 0.5))
         + std::exp(-x * (97 * 0.001)) * (97 * 0.1);
}

inline double func_98(double x) {
    return std::sin(x * (98 * 0.01 + 1.0)) * std::cos(x * (98 * 0.005 + 0.5))
         + std::exp(-x * (98 * 0.001)) * (98 * 0.1);
}

inline double func_99(double x) {
    return std::sin(x * (99 * 0.01 + 1.0)) * std::cos(x * (99 * 0.005 + 0.5))
         + std::exp(-x * (99 * 0.001)) * (99 * 0.1);
}

template<typename T>
struct Processor_0 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(0 + 1) / static_cast<T>(0 + 2);
    }
};

template<typename T>
struct Processor_1 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(1 + 1) / static_cast<T>(1 + 2);
    }
};

template<typename T>
struct Processor_2 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(2 + 1) / static_cast<T>(2 + 2);
    }
};

template<typename T>
struct Processor_3 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(3 + 1) / static_cast<T>(3 + 2);
    }
};

template<typename T>
struct Processor_4 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(4 + 1) / static_cast<T>(4 + 2);
    }
};

template<typename T>
struct Processor_5 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(5 + 1) / static_cast<T>(5 + 2);
    }
};

template<typename T>
struct Processor_6 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(6 + 1) / static_cast<T>(6 + 2);
    }
};

template<typename T>
struct Processor_7 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(7 + 1) / static_cast<T>(7 + 2);
    }
};

template<typename T>
struct Processor_8 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(8 + 1) / static_cast<T>(8 + 2);
    }
};

template<typename T>
struct Processor_9 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(9 + 1) / static_cast<T>(9 + 2);
    }
};

template<typename T>
struct Processor_10 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(10 + 1) / static_cast<T>(10 + 2);
    }
};

template<typename T>
struct Processor_11 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(11 + 1) / static_cast<T>(11 + 2);
    }
};

template<typename T>
struct Processor_12 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(12 + 1) / static_cast<T>(12 + 2);
    }
};

template<typename T>
struct Processor_13 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(13 + 1) / static_cast<T>(13 + 2);
    }
};

template<typename T>
struct Processor_14 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(14 + 1) / static_cast<T>(14 + 2);
    }
};

template<typename T>
struct Processor_15 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(15 + 1) / static_cast<T>(15 + 2);
    }
};

template<typename T>
struct Processor_16 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(16 + 1) / static_cast<T>(16 + 2);
    }
};

template<typename T>
struct Processor_17 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(17 + 1) / static_cast<T>(17 + 2);
    }
};

template<typename T>
struct Processor_18 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(18 + 1) / static_cast<T>(18 + 2);
    }
};

template<typename T>
struct Processor_19 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(19 + 1) / static_cast<T>(19 + 2);
    }
};

template<typename T>
struct Processor_20 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(20 + 1) / static_cast<T>(20 + 2);
    }
};

template<typename T>
struct Processor_21 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(21 + 1) / static_cast<T>(21 + 2);
    }
};

template<typename T>
struct Processor_22 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(22 + 1) / static_cast<T>(22 + 2);
    }
};

template<typename T>
struct Processor_23 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(23 + 1) / static_cast<T>(23 + 2);
    }
};

template<typename T>
struct Processor_24 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(24 + 1) / static_cast<T>(24 + 2);
    }
};

template<typename T>
struct Processor_25 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(25 + 1) / static_cast<T>(25 + 2);
    }
};

template<typename T>
struct Processor_26 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(26 + 1) / static_cast<T>(26 + 2);
    }
};

template<typename T>
struct Processor_27 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(27 + 1) / static_cast<T>(27 + 2);
    }
};

template<typename T>
struct Processor_28 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(28 + 1) / static_cast<T>(28 + 2);
    }
};

template<typename T>
struct Processor_29 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(29 + 1) / static_cast<T>(29 + 2);
    }
};

template<typename T>
struct Processor_30 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(30 + 1) / static_cast<T>(30 + 2);
    }
};

template<typename T>
struct Processor_31 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(31 + 1) / static_cast<T>(31 + 2);
    }
};

template<typename T>
struct Processor_32 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(32 + 1) / static_cast<T>(32 + 2);
    }
};

template<typename T>
struct Processor_33 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(33 + 1) / static_cast<T>(33 + 2);
    }
};

template<typename T>
struct Processor_34 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(34 + 1) / static_cast<T>(34 + 2);
    }
};

template<typename T>
struct Processor_35 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(35 + 1) / static_cast<T>(35 + 2);
    }
};

template<typename T>
struct Processor_36 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(36 + 1) / static_cast<T>(36 + 2);
    }
};

template<typename T>
struct Processor_37 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(37 + 1) / static_cast<T>(37 + 2);
    }
};

template<typename T>
struct Processor_38 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(38 + 1) / static_cast<T>(38 + 2);
    }
};

template<typename T>
struct Processor_39 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(39 + 1) / static_cast<T>(39 + 2);
    }
};

template<typename T>
struct Processor_40 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(40 + 1) / static_cast<T>(40 + 2);
    }
};

template<typename T>
struct Processor_41 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(41 + 1) / static_cast<T>(41 + 2);
    }
};

template<typename T>
struct Processor_42 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(42 + 1) / static_cast<T>(42 + 2);
    }
};

template<typename T>
struct Processor_43 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(43 + 1) / static_cast<T>(43 + 2);
    }
};

template<typename T>
struct Processor_44 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(44 + 1) / static_cast<T>(44 + 2);
    }
};

template<typename T>
struct Processor_45 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(45 + 1) / static_cast<T>(45 + 2);
    }
};

template<typename T>
struct Processor_46 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(46 + 1) / static_cast<T>(46 + 2);
    }
};

template<typename T>
struct Processor_47 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(47 + 1) / static_cast<T>(47 + 2);
    }
};

template<typename T>
struct Processor_48 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(48 + 1) / static_cast<T>(48 + 2);
    }
};

template<typename T>
struct Processor_49 {
    T value;
    T process(T input) const {
        return input * static_cast<T>(49 + 1) / static_cast<T>(49 + 2);
    }
};

#define CALL_FUNC(i, val) val = func_##i(val)

int main() {
    std::vector<double> results;
    results.reserve(100);
    for (int i = 0; i < 100; ++i) {
        results.push_back(func_0(static_cast<double>(i)));
        double& v = results.back();
        CALL_FUNC(0, v);
        CALL_FUNC(1, v);
        CALL_FUNC(2, v);
        CALL_FUNC(3, v);
        CALL_FUNC(4, v);
        CALL_FUNC(5, v);
        CALL_FUNC(6, v);
        CALL_FUNC(7, v);
        CALL_FUNC(8, v);
        CALL_FUNC(9, v);
        CALL_FUNC(10, v);
        CALL_FUNC(11, v);
        CALL_FUNC(12, v);
        CALL_FUNC(13, v);
        CALL_FUNC(14, v);
        CALL_FUNC(15, v);
        CALL_FUNC(16, v);
        CALL_FUNC(17, v);
        CALL_FUNC(18, v);
        CALL_FUNC(19, v);
        CALL_FUNC(20, v);
        CALL_FUNC(21, v);
        CALL_FUNC(22, v);
        CALL_FUNC(23, v);
        CALL_FUNC(24, v);
        CALL_FUNC(25, v);
        CALL_FUNC(26, v);
        CALL_FUNC(27, v);
        CALL_FUNC(28, v);
        CALL_FUNC(29, v);
        CALL_FUNC(30, v);
        CALL_FUNC(31, v);
        CALL_FUNC(32, v);
        CALL_FUNC(33, v);
        CALL_FUNC(34, v);
        CALL_FUNC(35, v);
        CALL_FUNC(36, v);
        CALL_FUNC(37, v);
        CALL_FUNC(38, v);
        CALL_FUNC(39, v);
        CALL_FUNC(40, v);
        CALL_FUNC(41, v);
        CALL_FUNC(42, v);
        CALL_FUNC(43, v);
        CALL_FUNC(44, v);
        CALL_FUNC(45, v);
        CALL_FUNC(46, v);
        CALL_FUNC(47, v);
        CALL_FUNC(48, v);
        CALL_FUNC(49, v);
        CALL_FUNC(50, v);
        CALL_FUNC(51, v);
        CALL_FUNC(52, v);
        CALL_FUNC(53, v);
        CALL_FUNC(54, v);
        CALL_FUNC(55, v);
        CALL_FUNC(56, v);
        CALL_FUNC(57, v);
        CALL_FUNC(58, v);
        CALL_FUNC(59, v);
        CALL_FUNC(60, v);
        CALL_FUNC(61, v);
        CALL_FUNC(62, v);
        CALL_FUNC(63, v);
        CALL_FUNC(64, v);
        CALL_FUNC(65, v);
        CALL_FUNC(66, v);
        CALL_FUNC(67, v);
        CALL_FUNC(68, v);
        CALL_FUNC(69, v);
        CALL_FUNC(70, v);
        CALL_FUNC(71, v);
        CALL_FUNC(72, v);
        CALL_FUNC(73, v);
        CALL_FUNC(74, v);
        CALL_FUNC(75, v);
        CALL_FUNC(76, v);
        CALL_FUNC(77, v);
        CALL_FUNC(78, v);
        CALL_FUNC(79, v);
        CALL_FUNC(80, v);
        CALL_FUNC(81, v);
        CALL_FUNC(82, v);
        CALL_FUNC(83, v);
        CALL_FUNC(84, v);
        CALL_FUNC(85, v);
        CALL_FUNC(86, v);
        CALL_FUNC(87, v);
        CALL_FUNC(88, v);
        CALL_FUNC(89, v);
        CALL_FUNC(90, v);
        CALL_FUNC(91, v);
        CALL_FUNC(92, v);
        CALL_FUNC(93, v);
        CALL_FUNC(94, v);
        CALL_FUNC(95, v);
        CALL_FUNC(96, v);
        CALL_FUNC(97, v);
        CALL_FUNC(98, v);
        CALL_FUNC(99, v);
    }

    double total = std::accumulate(results.begin(), results.end(), 0.0);
    std::cout << "Total: " << total << std::endl;

    Processor_0<double> p0; p0.value = 0.0;
    Processor_10<double> p10; p10.value = 10.0;
    Processor_20<double> p20; p20.value = 20.0;
    Processor_30<double> p30; p30.value = 30.0;
    Processor_40<double> p40; p40.value = 40.0;
    Processor_49<double> p49; p49.value = 49.0;

    std::cout << p0.process(p0.value) << " "
              << p10.process(p10.value) << " "
              << p20.process(p20.value) << " "
              << p30.process(p30.value) << " "
              << p40.process(p40.value) << " "
              << p49.process(p49.value) << std::endl;

    return 0;
}
