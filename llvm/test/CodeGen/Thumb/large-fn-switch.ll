; RUN: llc < %s | FileCheck %s
; Make sure we save/restore lr in the prologue of a function that's too large.

; CHECK: push    {lr}
; CHECK: bl      .LBB0_4

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv6m-unknown-unknown-eabi"

define dso_local i32 @a(i32 %x, ptr nocapture %p) {
entry:
  switch i32 %x, label %return [
    i32 0, label %GO2
    i32 1, label %GO3
    i32 999, label %GO3
    i32 3, label %GO3
    i32 998, label %GO3
    i32 5, label %GO3
    i32 6, label %GO2
    i32 7, label %GO2
    i32 8, label %GO2
    i32 9, label %GO2
    i32 10, label %GO2
    i32 11, label %GO3
    i32 996, label %GO3
    i32 995, label %GO2
    i32 993, label %GO3
    i32 15, label %GO2
    i32 16, label %GO3
    i32 991, label %GO2
    i32 18, label %GO3
    i32 19, label %GO2
    i32 20, label %GO2
    i32 21, label %GO2
    i32 22, label %GO2
    i32 990, label %GO2
    i32 24, label %GO3
    i32 989, label %GO2
    i32 987, label %GO3
    i32 27, label %GO2
    i32 28, label %GO3
    i32 29, label %GO3
    i32 30, label %GO2
    i32 985, label %GO3
    i32 32, label %GO2
    i32 984, label %GO3
    i32 34, label %GO2
    i32 35, label %GO2
    i32 36, label %GO2
    i32 982, label %GO2
    i32 38, label %GO3
    i32 981, label %GO3
    i32 40, label %GO2
    i32 41, label %GO2
    i32 980, label %GO3
    i32 43, label %GO2
    i32 44, label %GO2
    i32 979, label %GO2
    i32 46, label %GO2
    i32 47, label %GO3
    i32 978, label %GO2
    i32 49, label %GO2
    i32 977, label %GO2
    i32 51, label %GO3
    i32 976, label %GO3
    i32 972, label %GO3
    i32 54, label %GO3
    i32 971, label %GO2
    i32 970, label %GO2
    i32 57, label %GO3
    i32 58, label %GO2
    i32 59, label %GO3
    i32 60, label %GO3
    i32 61, label %GO2
    i32 62, label %GO3
    i32 63, label %GO2
    i32 64, label %GO3
    i32 65, label %GO2
    i32 969, label %GO3
    i32 968, label %GO3
    i32 966, label %GO2
    i32 69, label %GO2
    i32 70, label %GO3
    i32 965, label %GO3
    i32 72, label %GO3
    i32 73, label %GO2
    i32 74, label %GO2
    i32 964, label %GO2
    i32 76, label %GO2
    i32 963, label %GO3
    i32 78, label %GO3
    i32 79, label %GO2
    i32 962, label %GO2
    i32 81, label %GO2
    i32 82, label %GO2
    i32 83, label %GO2
    i32 960, label %GO2
    i32 85, label %GO2
    i32 959, label %GO2
    i32 958, label %GO3
    i32 957, label %GO3
    i32 89, label %GO3
    i32 90, label %GO3
    i32 956, label %GO3
    i32 955, label %GO2
    i32 93, label %GO2
    i32 94, label %GO2
    i32 95, label %GO3
    i32 96, label %GO3
    i32 97, label %GO2
    i32 98, label %GO3
    i32 99, label %GO2
    i32 100, label %GO3
    i32 954, label %GO3
    i32 102, label %GO2
    i32 103, label %GO3
    i32 104, label %GO2
    i32 105, label %GO2
    i32 952, label %GO2
    i32 107, label %GO2
    i32 108, label %GO3
    i32 109, label %GO3
    i32 110, label %GO3
    i32 111, label %GO2
    i32 112, label %GO3
    i32 113, label %GO3
    i32 114, label %GO3
    i32 115, label %GO2
    i32 116, label %GO3
    i32 951, label %GO2
    i32 950, label %GO2
    i32 948, label %GO2
    i32 120, label %GO3
    i32 121, label %GO3
    i32 122, label %GO2
    i32 123, label %GO2
    i32 946, label %GO3
    i32 945, label %GO3
    i32 126, label %GO3
    i32 127, label %GO3
    i32 943, label %GO2
    i32 942, label %GO3
    i32 130, label %GO3
    i32 131, label %GO3
    i32 941, label %GO3
    i32 133, label %GO3
    i32 134, label %GO3
    i32 135, label %GO2
    i32 940, label %GO2
    i32 137, label %GO2
    i32 138, label %GO3
    i32 139, label %GO2
    i32 140, label %GO3
    i32 939, label %GO3
    i32 142, label %GO2
    i32 938, label %GO3
    i32 144, label %GO3
    i32 937, label %GO3
    i32 936, label %GO2
    i32 147, label %GO2
    i32 148, label %GO3
    i32 935, label %GO3
    i32 150, label %GO2
    i32 151, label %GO2
    i32 152, label %GO3
    i32 153, label %GO3
    i32 154, label %GO2
    i32 155, label %GO2
    i32 934, label %GO3
    i32 157, label %GO3
    i32 933, label %GO3
    i32 159, label %GO3
    i32 160, label %GO3
    i32 161, label %GO2
    i32 162, label %GO2
    i32 163, label %GO2
    i32 164, label %GO3
    i32 165, label %GO3
    i32 932, label %GO3
    i32 167, label %GO2
    i32 931, label %GO3
    i32 169, label %GO3
    i32 170, label %GO2
    i32 171, label %GO2
    i32 172, label %GO2
    i32 930, label %GO2
    i32 929, label %GO2
    i32 928, label %GO3
    i32 176, label %GO2
    i32 927, label %GO3
    i32 926, label %GO3
    i32 925, label %GO2
    i32 924, label %GO2
    i32 923, label %GO2
    i32 920, label %GO2
    i32 183, label %GO3
    i32 184, label %GO2
    i32 185, label %GO2
    i32 186, label %GO2
    i32 187, label %GO3
    i32 188, label %GO2
    i32 189, label %GO2
    i32 918, label %GO3
    i32 191, label %GO3
    i32 917, label %GO2
    i32 193, label %GO3
    i32 194, label %GO3
    i32 916, label %GO3
    i32 196, label %GO3
    i32 197, label %GO2
    i32 198, label %GO2
    i32 199, label %GO3
    i32 915, label %GO3
    i32 201, label %GO2
    i32 202, label %GO2
    i32 203, label %GO3
    i32 914, label %GO3
    i32 913, label %GO2
    i32 206, label %GO2
    i32 207, label %GO2
    i32 208, label %GO3
    i32 911, label %GO3
    i32 210, label %GO3
    i32 211, label %GO2
    i32 212, label %GO2
    i32 213, label %GO2
    i32 214, label %GO2
    i32 215, label %GO2
    i32 909, label %GO3
    i32 908, label %GO2
    i32 218, label %GO3
    i32 907, label %GO3
    i32 905, label %GO2
    i32 221, label %GO2
    i32 222, label %GO2
    i32 904, label %GO3
    i32 224, label %GO3
    i32 225, label %GO2
    i32 226, label %GO2
    i32 903, label %GO2
    i32 228, label %GO2
    i32 229, label %GO2
    i32 230, label %GO3
    i32 231, label %GO3
    i32 232, label %GO3
    i32 233, label %GO3
    i32 234, label %GO3
    i32 235, label %GO3
    i32 902, label %GO2
    i32 237, label %GO3
    i32 238, label %GO3
    i32 239, label %GO3
    i32 240, label %GO3
    i32 241, label %GO3
    i32 242, label %GO2
    i32 243, label %GO2
    i32 901, label %GO2
    i32 245, label %GO3
    i32 899, label %GO2
    i32 247, label %GO3
    i32 248, label %GO3
    i32 249, label %GO3
    i32 898, label %GO3
    i32 251, label %GO2
    i32 897, label %GO3
    i32 253, label %GO3
    i32 896, label %GO2
    i32 255, label %GO2
    i32 256, label %GO2
    i32 257, label %GO2
    i32 258, label %GO2
    i32 259, label %GO3
    i32 260, label %GO3
    i32 261, label %GO3
    i32 262, label %GO3
    i32 894, label %GO3
    i32 264, label %GO2
    i32 265, label %GO3
    i32 266, label %GO2
    i32 267, label %GO2
    i32 893, label %GO3
    i32 269, label %GO3
    i32 891, label %GO3
    i32 271, label %GO3
    i32 890, label %GO2
    i32 273, label %GO3
    i32 274, label %GO3
    i32 888, label %GO3
    i32 886, label %GO2
    i32 277, label %GO3
    i32 278, label %GO3
    i32 279, label %GO2
    i32 280, label %GO3
    i32 281, label %GO3
    i32 282, label %GO2
    i32 883, label %GO2
    i32 284, label %GO3
    i32 285, label %GO3
    i32 286, label %GO2
    i32 881, label %GO2
    i32 879, label %GO2
    i32 877, label %GO3
    i32 876, label %GO3
    i32 875, label %GO3
    i32 874, label %GO2
    i32 293, label %GO3
    i32 294, label %GO2
    i32 295, label %GO2
    i32 296, label %GO3
    i32 297, label %GO2
    i32 298, label %GO3
    i32 299, label %GO3
    i32 300, label %GO2
    i32 873, label %GO2
    i32 872, label %GO2
    i32 871, label %GO2
    i32 870, label %GO3
    i32 305, label %GO3
    i32 306, label %GO3
    i32 869, label %GO3
    i32 308, label %GO2
    i32 868, label %GO2
    i32 310, label %GO3
    i32 311, label %GO2
    i32 867, label %GO2
    i32 313, label %GO2
    i32 314, label %GO3
    i32 315, label %GO3
    i32 865, label %GO3
    i32 317, label %GO2
    i32 318, label %GO2
    i32 319, label %GO3
    i32 320, label %GO3
    i32 321, label %GO2
    i32 864, label %GO2
    i32 323, label %GO2
    i32 324, label %GO2
    i32 863, label %GO2
    i32 862, label %GO3
    i32 327, label %GO3
    i32 328, label %GO2
    i32 329, label %GO3
    i32 330, label %GO3
    i32 331, label %GO2
    i32 332, label %GO3
    i32 333, label %GO3
    i32 856, label %GO3
    i32 335, label %GO2
    i32 336, label %GO3
    i32 854, label %GO3
    i32 338, label %GO3
    i32 339, label %GO2
    i32 340, label %GO3
    i32 852, label %GO2
    i32 342, label %GO2
    i32 343, label %GO2
    i32 851, label %GO2
    i32 345, label %GO2
    i32 849, label %GO3
    i32 847, label %GO3
    i32 348, label %GO3
    i32 846, label %GO3
    i32 350, label %GO2
    i32 845, label %GO3
    i32 352, label %GO2
    i32 353, label %GO3
    i32 354, label %GO2
    i32 355, label %GO2
    i32 844, label %GO2
    i32 357, label %GO3
    i32 843, label %GO2
    i32 359, label %GO3
    i32 360, label %GO3
    i32 842, label %GO3
    i32 362, label %GO2
    i32 841, label %GO2
    i32 840, label %GO2
    i32 839, label %GO3
    i32 837, label %GO2
    i32 367, label %GO3
    i32 368, label %GO3
    i32 369, label %GO3
    i32 835, label %GO3
    i32 834, label %GO3
    i32 833, label %GO3
    i32 373, label %GO3
    i32 374, label %GO3
    i32 375, label %GO2
    i32 832, label %GO3
    i32 377, label %GO2
    i32 378, label %GO2
    i32 831, label %GO2
    i32 380, label %GO3
    i32 381, label %GO2
    i32 382, label %GO2
    i32 383, label %GO2
    i32 830, label %GO3
    i32 828, label %GO2
    i32 826, label %GO2
    i32 387, label %GO3
    i32 388, label %GO3
    i32 389, label %GO2
    i32 390, label %GO3
    i32 391, label %GO2
    i32 392, label %GO2
    i32 393, label %GO3
    i32 824, label %GO3
    i32 395, label %GO2
    i32 396, label %GO3
    i32 823, label %GO3
    i32 398, label %GO3
    i32 399, label %GO2
    i32 400, label %GO2
    i32 401, label %GO2
    i32 822, label %GO2
    i32 820, label %GO3
    i32 404, label %GO3
    i32 819, label %GO3
    i32 406, label %GO2
    i32 407, label %GO3
    i32 408, label %GO2
    i32 818, label %GO3
    i32 817, label %GO3
    i32 411, label %GO2
    i32 412, label %GO2
    i32 413, label %GO3
    i32 414, label %GO3
    i32 814, label %GO2
    i32 813, label %GO3
    i32 811, label %GO3
    i32 810, label %GO3
    i32 419, label %GO3
    i32 420, label %GO3
    i32 421, label %GO3
    i32 809, label %GO2
    i32 423, label %GO3
    i32 424, label %GO3
    i32 425, label %GO3
    i32 808, label %GO3
    i32 427, label %GO2
    i32 807, label %GO3
    i32 806, label %GO3
    i32 430, label %GO2
    i32 805, label %GO3
    i32 432, label %GO2
    i32 433, label %GO3
    i32 804, label %GO3
    i32 435, label %GO3
    i32 802, label %GO2
    i32 801, label %GO3
    i32 800, label %GO2
    i32 439, label %GO3
    i32 440, label %GO2
    i32 441, label %GO3
    i32 442, label %GO2
    i32 443, label %GO2
    i32 799, label %GO2
    i32 797, label %GO3
    i32 446, label %GO3
    i32 795, label %GO2
    i32 794, label %GO2
    i32 449, label %GO2
    i32 450, label %GO2
    i32 451, label %GO2
    i32 452, label %GO3
    i32 453, label %GO3
    i32 454, label %GO3
    i32 455, label %GO2
    i32 456, label %GO3
    i32 457, label %GO3
    i32 793, label %GO3
    i32 792, label %GO2
    i32 460, label %GO2
    i32 791, label %GO2
    i32 462, label %GO2
    i32 789, label %GO3
    i32 785, label %GO2
    i32 784, label %GO2
    i32 783, label %GO2
    i32 780, label %GO3
    i32 468, label %GO3
    i32 469, label %GO3
    i32 470, label %GO2
    i32 471, label %GO3
    i32 472, label %GO3
    i32 473, label %GO2
    i32 779, label %GO2
    i32 778, label %GO3
    i32 476, label %GO3
    i32 477, label %GO2
    i32 777, label %GO3
    i32 775, label %GO3
    i32 480, label %GO2
    i32 481, label %GO2
    i32 774, label %GO2
    i32 483, label %GO2
    i32 484, label %GO3
    i32 773, label %GO2
    i32 772, label %GO3
    i32 487, label %GO2
    i32 488, label %GO2
    i32 489, label %GO3
    i32 771, label %GO2
    i32 770, label %GO3
    i32 492, label %GO3
    i32 493, label %GO2
    i32 769, label %GO2
    i32 495, label %GO2
    i32 496, label %GO3
    i32 497, label %GO3
    i32 498, label %GO3
    i32 766, label %GO2
    i32 500, label %GO2
    i32 501, label %GO3
    i32 765, label %GO2
    i32 503, label %GO3
    i32 764, label %GO2
    i32 505, label %GO3
    i32 506, label %GO2
    i32 507, label %GO3
    i32 508, label %GO2
    i32 509, label %GO3
    i32 510, label %GO2
    i32 511, label %GO3
    i32 763, label %GO2
    i32 761, label %GO2
    i32 514, label %GO2
    i32 515, label %GO3
    i32 516, label %GO3
    i32 760, label %GO2
    i32 518, label %GO3
    i32 519, label %GO3
    i32 759, label %GO2
    i32 521, label %GO2
    i32 522, label %GO3
    i32 523, label %GO3
    i32 758, label %GO2
    i32 525, label %GO3
    i32 757, label %GO3
    i32 756, label %GO2
    i32 528, label %GO3
    i32 529, label %GO2
    i32 530, label %GO2
    i32 531, label %GO3
    i32 755, label %GO2
    i32 533, label %GO3
    i32 754, label %GO3
    i32 535, label %GO2
    i32 536, label %GO3
    i32 537, label %GO3
    i32 538, label %GO3
    i32 539, label %GO3
    i32 540, label %GO2
    i32 753, label %GO2
    i32 542, label %GO2
    i32 752, label %GO3
    i32 544, label %GO2
    i32 545, label %GO2
    i32 546, label %GO2
    i32 547, label %GO3
    i32 751, label %GO2
    i32 549, label %GO2
    i32 550, label %GO3
    i32 750, label %GO3
    i32 552, label %GO2
    i32 553, label %GO2
    i32 749, label %GO3
    i32 555, label %GO2
    i32 556, label %GO3
    i32 748, label %GO3
    i32 746, label %GO2
    i32 744, label %GO2
    i32 560, label %GO3
    i32 741, label %GO3
    i32 562, label %GO3
    i32 740, label %GO2
    i32 564, label %GO3
    i32 565, label %GO3
    i32 739, label %GO2
    i32 737, label %GO3
    i32 568, label %GO2
    i32 734, label %GO2
    i32 733, label %GO3
    i32 571, label %GO2
    i32 572, label %GO2
    i32 573, label %GO2
    i32 732, label %GO3
    i32 575, label %GO3
    i32 731, label %GO3
    i32 577, label %GO3
    i32 578, label %GO2
    i32 730, label %GO3
    i32 580, label %GO2
    i32 581, label %GO2
    i32 582, label %GO3
    i32 729, label %GO2
    i32 584, label %GO3
    i32 585, label %GO2
    i32 586, label %GO3
    i32 587, label %GO3
    i32 728, label %GO3
    i32 726, label %GO2
    i32 590, label %GO2
    i32 591, label %GO2
    i32 592, label %GO3
    i32 593, label %GO2
    i32 594, label %GO3
    i32 595, label %GO2
    i32 596, label %GO2
    i32 597, label %GO2
    i32 598, label %GO3
    i32 599, label %GO2
    i32 725, label %GO3
    i32 601, label %GO2
    i32 602, label %GO3
    i32 603, label %GO3
    i32 604, label %GO3
    i32 605, label %GO3
    i32 723, label %GO2
    i32 607, label %GO2
    i32 608, label %GO2
    i32 722, label %GO3
    i32 610, label %GO3
    i32 611, label %GO3
    i32 721, label %GO3
    i32 613, label %GO2
    i32 720, label %GO2
    i32 615, label %GO2
    i32 616, label %GO3
    i32 719, label %GO2
    i32 717, label %GO2
    i32 716, label %GO3
    i32 620, label %GO2
    i32 621, label %GO3
    i32 622, label %GO2
    i32 623, label %GO3
    i32 624, label %GO2
    i32 715, label %GO2
    i32 626, label %GO2
    i32 627, label %GO2
    i32 714, label %GO2
    i32 629, label %GO2
    i32 630, label %GO2
    i32 712, label %GO3
    i32 632, label %GO3
    i32 711, label %GO2
    i32 634, label %GO2
    i32 710, label %GO3
    i32 707, label %GO2
    i32 637, label %GO3
    i32 638, label %GO3
    i32 639, label %GO2
    i32 706, label %GO3
    i32 641, label %GO3
    i32 705, label %GO3
    i32 643, label %GO3
    i32 644, label %GO3
    i32 645, label %GO2
    i32 703, label %GO2
    i32 647, label %GO3
    i32 648, label %GO2
    i32 649, label %GO3
    i32 702, label %GO2
    i32 701, label %GO2
    i32 652, label %GO2
    i32 653, label %GO3
    i32 654, label %GO2
    i32 655, label %GO3
    i32 699, label %GO3
    i32 698, label %GO2
    i32 658, label %GO2
    i32 659, label %GO2
    i32 660, label %GO2
    i32 661, label %GO2
    i32 696, label %GO3
    i32 695, label %GO3
    i32 664, label %GO3
    i32 665, label %GO3
    i32 666, label %GO3
    i32 667, label %GO2
    i32 668, label %GO2
    i32 669, label %GO3
    i32 693, label %GO3
    i32 671, label %GO3
    i32 692, label %GO3
    i32 673, label %GO3
    i32 674, label %GO3
    i32 675, label %GO2
    i32 676, label %GO3
    i32 677, label %GO2
    i32 691, label %GO3
    i32 679, label %GO3
    i32 680, label %GO3
    i32 681, label %GO3
    i32 690, label %GO3
    i32 689, label %GO3
    i32 688, label %GO2
    i32 685, label %GO3
    i32 686, label %GO2
  ]

GO2:
  br label %return

GO3:
  store i32 3, ptr %p, align 4
  br label %return

return:
  %retval.0 = phi i32 [ 3, %GO3 ], [ 2, %GO2 ], [ 1, %entry ]
  ret i32 %retval.0
}
