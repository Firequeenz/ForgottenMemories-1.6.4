extends Node




static var enemy_decks_data = {
    "Simon Muran": {
        "difficulty": "Easy", 
        "deck": {





            9: 3, 
            17: 1, 
            18: 1, 
            19: 1, 
            20: 1, 
            21: 1, 
            24: 3, 
            167: 3, 
            192: 3, 
            289: 3, 
            338: 2, 
            343: 3, 
            387: 3, 
            504: 3, 
            547: 3, 
            548: 3, 
            635: 3
        }, 
        "drops": {
            "common": [2, 9, 10, 16, 24, 25, 30, 41, 
            46, 47, 48, 58, 59, 65, 102, 105, 123, 130, 137, 167, 
            192, 197, 202, 237, 238, 289, 381, 387, 397, 402, 410, 411, 422, 
            436, 444, 469, 484, 485, 488, 504, 516, 547, 548, 558, 
            563, 548, 635], 
            "rare": [], 
            "super_rare": [17, 18, 19, 20, 21, 301, 313, 314, 333, 336, 
            338, 343, 676, 677, 681, 682, 690], 
            "epic": [], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Unknown": {
        "difficulty": "Hard", 
        "deck": {}, 
        "drops": {}, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Teana": {
        "difficulty": "Easy", 
        "deck": {
            24: 3, 
            58: 3, 
            395: 3, 
            393: 3, 
            399: 3, 
            338: 3, 
            344: 2, 
            9: 2, 
            56: 2, 
            105: 2, 
            197: 2, 
            167: 2, 
            192: 2, 
            289: 2, 
            387: 2, 
            123: 2, 
            278: 2
        }, 
        "drops": {"common": [9, 24, 56, 58, 102, 105, 123, 167, 192, 197, 278, 
        289, 338, 344, 387, 393, 395, 398, 399, 402, 469, 475, 527, 543, 
        566, 570, 580], 
            "rare": [], 
            "super_rare": [302, 312, 313, 330, 336, 345, 350, 681, 682, 690, 699], 
            "epic": [], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Jono": {
        "difficulty": "Easy", 
        "deck": {
            547: 3, 
            558: 3, 
            548: 3, 
            504: 3, 
            387: 3, 
            289: 3, 
            192: 3, 
            167: 3, 
            16: 3, 
            339: 3, 
            9: 2, 
            29: 2, 
            100: 2, 
            4: 2, 
            344: 2
        }, 
        "drops": {"common": [4, 9, 16, 29, 50, 61, 100, 104, 105, 122, 
        123, 130, 135, 137, 152, 154, 
        174, 182, 185, 191, 192, 197, 202, 207, 210, 214, 237, 
        242, 245, 268, 289, 339, 344, 387, 397, 410, 411, 
        420, 422, 428, 436, 444, 448, 484, 485, 486, 488, 489, 492, 501, 
        504, 516, 524, 547, 548, 549, 558, 
        563, 570, 579, 580, 581, 588, 589, 598, 607, 611, 616, 635], 
            "rare": [], 
            "super_rare": [301, 302, 310, 311, 333, 336, 343, 
            344, 651, 654, 677, 679, 681, 683, 690], 
            "epic": [], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Joseph": {
        "difficulty": "Easy", 
        "deck": {
            24: 3, 
            58: 3, 
            395: 3, 
            393: 3, 
            399: 3, 
            167: 3, 
            469: 3, 
            475: 3, 
            527: 3, 
            350: 3, 
            207: 2, 
            402: 2, 
            516: 2, 
            485: 2, 
            339: 2
        }, 
        "drops": {"common": [9, 24, 58, 112, 123, 146, 
        153, 165, 167, 192, 207, 
        234, 241, 289, 339, 
        350, 387, 393, 395, 397, 398, 399, 
        402, 411, 435, 450, 469, 475, 480, 484, 485, 488, 502, 504, 
        516, 527, 547, 548, 558, 563, 570, 580, 
        635], 
            "rare": [], 
            "super_rare": [307, 308, 309, 312, 323, 
            327, 332, 336, 338, 339, 340, 345, 350, 665, 655, 671, 673, 674, 676, 
            677, 678, 679, 680, 681, 690, 691, 
            692, 694, 695, 697, 699, 700], 
            "epic": [666], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Noah": {
        "difficulty": "Easy", 
        "deck": {
            97: 3, 
            139: 3, 
            606: 3, 
            610: 3, 
            108: 3, 
            503: 3, 
            451: 3, 
            96: 3, 
            45: 3, 
            345: 3, 
            199: 2, 
            205: 2, 
            206: 2, 
            367: 2, 
            339: 2
        }, 
        "drops": {"common": [9, 10, 23, 24, 25, 30, 34, 36, 40, 
            45, 53, 59, 61, 65, 80, 96, 97, 98, 102, 103, 
            108, 109, 110, 115, 118, 119, 120, 121, 
            132, 135, 138, 139, 140, 
            141, 152, 154, 162, 164, 167, 169, 171, 
            172, 177, 181, 191, 196, 197, 199, 201, 
            203, 205, 206, 211, 215, 219, 220, 221, 225, 
            227, 228, 231, 233, 236, 237, 238, 243, 244, 246, 
            248, 250, 251, 256, 257, 258, 259, 262, 
            263, 265, 269, 270, 272, 273, 274, 276, 280, 289, 290, 
            291, 292, 293, 294, 296, 339, 
            345, 367, 393, 394, 398, 406, 414, 432, 444, 446, 451, 452, 461, 
            463, 484, 496, 503, 514, 516, 524, 548, 549, 552, 556, 558, 
            567, 576, 584, 591, 592, 601, 602, 605, 606, 608, 
            610, 620, 629, 642, 643], 
            "rare": [], 
            "super_rare": [304, 305, 316, 319, 321, 326, 330, 333, 
            335, 336, 338, 339, 340, 345, 350, 683, 684, 
            687, 688, 690], 
            "epic": [693], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Issam": {
        "difficulty": "Medium", 
        "deck": {
            61: 3, 
            59: 3, 
            47: 3, 
            30: 3, 
            4: 3, 
            435: 3, 
            445: 3, 
            98: 3, 
            430: 3, 
            339: 3, 
            647: 2, 
            96: 2, 
            97: 2, 
            367: 2, 
            345: 2
        }, 
        "drops": {"common": [4, 9, 23, 24, 30, 34, 40, 45, 47, 53, 59, 61, 65, 
            96, 97, 98, 103, 108, 109, 110, 118, 119, 
            120, 132, 133, 135, 138, 
            139, 140, 141, 142, 152, 154, 155, 162, 167, 
            169, 171, 172, 177, 
            178, 180, 181, 190, 191, 196, 197, 199, 201, 203, 
            205, 206, 211, 215, 219, 221, 225, 227, 228, 231, 236, 237, 243, 
            244, 246, 248, 250, 251, 256, 257, 
            258, 260, 262, 263, 264, 265, 269, 270, 272, 273, 
            274, 276, 279, 282, 283, 289, 290, 292, 
            293, 294, 295, 296, 298, 339, 345, 
            367, 393, 394, 398, 414, 430, 432, 435, 444, 446, 451, 452, 461, 
            463, 478, 484, 496, 503, 516, 524, 548, 
            549, 552, 556, 558, 567, 576, 584, 585, 588, 591, 592, 
            601, 602, 605, 606, 620, 629, 642, 647], 
            "rare": [], 
            "super_rare": [306, 317, 319, 326, 331, 334, 335, 336, 
            338, 339, 340, 345, 350, 683, 684, 687, 688, 690], 
            "epic": [], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Seto 1": {
        "difficulty": "Medium", 
        "deck": {
            23: 3, 
            402: 3, 
            469: 3, 
            567: 3, 
            133: 3, 
            91: 3, 
            26: 3, 
            27: 3, 
            58: 3, 
            38: 3, 
            379: 2, 
            377: 2, 
            333: 2, 
            349: 2, 
            670: 2
        }, 
        "drops": {"common": [8, 23, 26, 27, 40, 50, 58, 75, 76, 91, 98, 
            101, 104, 107, 122, 123, 130, 133, 134, 135, 137, 
            145, 152, 154, 157, 158, 159, 
            174, 176, 179, 180, 182, 183, 185, 191, 195, 198, 200, 
            202, 203, 207, 209, 210, 
            211, 212, 214, 222, 227, 229, 232, 237, 242, 245, 
            254, 261, 268, 273, 274, 285, 291, 
            292, 377, 379, 402, 420, 
            452, 469, 476, 486, 488, 492, 501, 
            506, 510, 524, 536, 540, 544, 
            547, 549, 556, 567, 579, 589, 591, 598, 602, 609, 611, 620], 
            "rare": [], 
            "super_rare": [38, 349, 302, 308, 310, 324, 328, 
            330, 333, 336, 337, 343, 344, 345, 670, 
            677, 682, 683, 684, 687, 688, 690], 
            "epic": [], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Heishin 1": {
        "difficulty": "Medium", 
        "deck": {
            453: 3, 
            500: 3, 
            715: 3, 
            645: 3, 
            369: 3, 
            390: 3, 
            370: 3, 
            373: 3, 
            58: 3, 
            337: 3, 
            217: 2, 
            713: 2, 
            57: 2, 
            661: 2, 
            689: 2
        }, 
        "drops": {"common": [2, 30, 34, 36, 44, 74, 96, 97, 
            98, 104, 108, 114, 115, 129, 132, 135, 139, 142, 143, 
            144, 145, 154, 174, 179, 183, 184, 190, 203, 
            213, 215, 220, 228, 237, 244, 253, 257, 259, 263, 268, 
            455, 457, 470, 505, 532, 599, 
            623, 631, 634, 646], 
            "rare": [42, 79, 90, 99, 106, 223, 
            366, 368, 401, 407, 442, 453, 
            465, 467, 471, 500, 509, 518, 522, 525, 
            529, 531, 564, 571, 572, 593, 594, 627, 632, 645, 
            714], 
            "super_rare": [35, 37, 57, 303, 313, 315, 320, 322, 323, 331, 336, 
            342, 343, 344, 345, 347, 360, 370, 
            371, 372, 373, 385, 386, 390, 391, 426, 427, 613, 657, 672, 676, 682, 683, 684, 
            686, 687, 688, 689, 690, 695, 703, 
            705, 707, 708], 
            "epic": [217, 661], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Commentator": {
        "difficulty": "Medium", 
        "deck": {
            660: 3, 
            7: 3, 
            10: 3, 
            31: 3, 
            168: 3, 
            23: 3, 
            47: 3, 
            61: 3, 
            753: 3, 
            337: 3, 
            94: 2, 
            357: 2, 
            740: 2, 
            315: 2, 
            723: 2
        }, 
        "drops": {"common": [4, 23, 27, 47, 53, 
            91, 98, 142, 149, 179, 203, 226, 
            227, 235, 247, 263, 265, 266, 
            271, 282, 296, 354, 431, 490, 
            527, 537, 542, 579, 607, 634, 660, 
            720, 724, 725, 728], 
            "rare": [92, 357, 
            366, 388, 403, 423, 473, 483, 545, 
            621, 719, 726, 727, 729, 
            730, 731, 732, 733, 735, 737, 738, 739, 753], 
            "super_rare": [315, 350, 652, 658, 664, 674, 688, 696, 704, 705, 718, 723, 740, 736, 
            741, 742, 743, 744], 
            "epic": [613], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Tea Gardner": {
        "difficulty": "Medium", 
        "deck": {
            762: 3, 
            761: 3, 
            540: 3, 
            760: 3, 
            759: 3, 
            253: 3, 
            198: 3, 
            208: 3, 
            756: 3, 
            757: 3, 
            608: 2, 
            763: 2, 
            758: 2, 
            312: 2, 
            749: 2
        }, 
        "drops": {"common": [30, 31, 44, 83, 107, 123, 
            138, 159, 163, 198, 199, 202, 203, 213, 
            208, 253, 285, 298, 411, 422, 430, 433, 
            459, 466, 479, 485, 505, 540, 546, 547, 553, 
            605, 608, 615, 616, 642, 646, 742, 759, 760, 762], 
            "rare": [11, 150, 383, 396, 
            409, 443, 471, 543, 594, 
            749, 756, 757, 758], 
            "super_rare": [312, 314, 347, 427, 667, 709, 741, 761], 
            "epic": [763], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Yugi Muto": {
        "difficulty": "Medium", 
        "deck": {
            28: 3, 
            74: 3, 
            773: 3, 
            772: 3, 
            771: 3, 
            770: 3, 
            769: 3, 
            768: 3, 
            767: 3, 
            764: 3, 
            775: 2, 
            774: 2, 
            766: 2, 
            765: 2, 
            731: 2
        }, 
        "drops": {"common": [25, 28, 72, 74, 105, 142, 145, 159, 
            185, 221, 212, 244, 250, 264, 272, 273, 351, 354, 
            384, 402, 450, 452, 456, 478, 501, 515, 549, 559, 
            561, 584, 589, 603, 611, 612, 630, 642, 766, 769, 
            770, 771, 772, 774], 
            "rare": [73, 388, 453, 491, 533, 
            719, 731, 764, 767], 
            "super_rare": [302, 308, 328, 330, 390, 639, 676, 694, 736, 768, 773, 765], 
            "epic": [775], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Rex Raptor": {
        "difficulty": "Medium", 
        "deck": {
            784: 3, 
            781: 3, 
            780: 3, 
            783: 3, 
            782: 3, 
            785: 3, 
            509: 3, 
            81: 3, 
            777: 3, 
            779: 3, 
            79: 2, 
            80: 2, 
            32: 2, 
            776: 2, 
            778: 2
        }, 
        "drops": {"common": [32, 48, 61, 80, 81, 105, 143, 
            195, 234, 242, 255, 294, 296, 306, 310, 330, 
            367, 379, 387, 412, 431, 450, 476, 485, 489, 534, 
            558, 574, 587, 606, 629, 631, 725, 769, 780, 783, 785], 
            "rare": [14, 79, 87, 111, 127, 382, 509, 572, 622, 
            735, 767, 776, 777, 
            778, 779, 782], 
            "super_rare": [670, 674, 679, 710, 781], 
            "epic": [82, 784], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Weevil Underwood": {
        "difficulty": "Medium", 
        "deck": {
            57: 3, 
            788: 3, 
            786: 3, 
            787: 3, 
            790: 3, 
            478: 3, 
            792: 3, 
            55: 3, 
            306: 3, 
            791: 3, 
            789: 2, 
            72: 2, 
            67: 2, 
            661: 2, 
            749: 2
        }, 
        "drops": {"common": [6, 13, 25, 40, 55, 66, 72, 76, 115, 121, 
            140, 158, 175, 205, 209, 227, 233, 243, 250, 254, 280, 
            284, 287, 290, 298, 367, 440, 447, 478, 505, 547, 556, 
            558, 590, 604, 629, 715, 771, 774, 786, 787, 789, 790, 792], 
            "rare": [396, 572, 624, 627, 
            641, 749, 788], 
            "super_rare": [57, 306, 310, 314, 322, 343, 678, 679, 791], 
            "epic": [67], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Bandit Keith": {
        "difficulty": "Medium", 
        "deck": {
            747: 3, 
            793: 3, 
            794: 3, 
            795: 3, 
            797: 3, 
            275: 3, 
            514: 3, 
            283: 3, 
            337: 3, 
            796: 3, 
            406: 2, 
            392: 2, 
            407: 2, 
            658: 2, 
            686: 2
        }, 
        "drops": {"common": [10, 24, 34, 48, 97, 102, 120, 137, 143, 
            165, 168, 179, 197, 214, 224, 225, 232, 239, 242, 243, 
            260, 273, 275, 281, 283, 288, 359, 377, 393, 406, 430, 
            462, 502, 514, 527, 539, 568, 574, 576, 603, 620, 629, 
            630, 724, 797], 
            "rare": [84, 150, 286, 355, 357, 389, 407, 439, 
            449, 520, 543, 572, 582, 617, 714, 745, 755, 
            758, 793, 794], 
            "super_rare": [329, 344, 371, 392, 673, 680, 716, 744, 747, 795], 
            "epic": [796], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 
    "Bonz": {
        "difficulty": "Medium", 
        "deck": {
            798: 3, 
            799: 3, 
            800: 3, 
            802: 3, 
            801: 3, 
            803: 3, 
            24: 3, 
            98: 3, 
            805: 3, 
            804: 3, 
            719: 2, 
            596: 2, 
            564: 2, 
            752: 2, 
            755: 2
        }, 
        "drops": {"common": [24, 31, 32, 54, 59, 98, 108, 
            117, 137, 149, 162, 168, 182, 192, 197, 201, 
            211, 236, 248, 261, 262, 272, 275, 277, 295, 
            299, 395, 402, 415, 416, 455, 456, 480, 484, 
            502, 516, 570, 584, 589, 591, 596, 597, 734, 
            759, 776, 798, 799, 800], 
            "rare": [124, 366, 375, 465, 471, 482, 557, 564, 639, 
            712, 719, 737, 738, 752, 755, 802, 804, 805], 
            "super_rare": [35, 303, 320, 326, 327, 328, 330, 343, 
            347, 360, 369, 370, 426, 659, 
            671, 678, 680, 704, 705, 706, 
            717, 801], 
            "epic": [803], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }
    }, 



    "Amon": {
        "difficulty": "Hard", 
        "deck": {
            191: 3, 
            45: 3, 
            227: 3, 
            103: 3, 
            402: 3, 
            661: 3, 
            109: 3, 
            555: 3, 
            712: 3, 
            321: 3, 
            571: 2, 
            495: 2, 
            1: 2, 
            99999: 2, 
            693: 2
        }, 
        "drops": {
            "common": [2, 3, 6, 7, 10, 13, 23, 25, 26, 27, 28, 29, 31, 32, 34, 45, 103, 109, 191, 227, 402], 
            "rare": [495, 555, 571, 712], 
            "super_rare": [1], 
            "epic": [99999], 
            "legendary": []
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }, 
    }, 
    "Jonathan Bicalho": {
        "difficulty": "Hard", 
        "deck": {
            380: 3, 
            374: 3, 
            675: 2, 
            67: 2, 
            713: 2, 
            99999: 2, 
            217: 2, 
            1: 2, 
            364: 1, 
            392: 1, 
            708: 1, 
            722: 1, 
            672: 2, 
            337: 2, 
            657: 3, 
            665: 3, 
            661: 2, 
            723: 2, 
            726: 1, 
            698: 1, 
            304: 1, 
            348: 1
        }, 
        "drops": {
            "common": [2, 3, 6, 7, 8, 10, 13, 23, 25, 26, 
            27, 28, 29, 31, 32, 34, 64, 65, 81, 100, 116, 125, 
            212, 249, 270, 367, 416, 457, 504, 535, 539, 541, 575, 
            610, 774], 
            "rare": [348, 672, 687, 691, 692, 695, 698, 699, 
            702, 726], 
            "super_rare": [1, 364, 392, 708, 718, 722, 713], 
            "epic": [], 
            "legendary": [374]
        }, 
        "drop_rates": {
            "common": 0.89, 
            "rare": 0.094, 
            "super_rare": 0.01, 
            "epic": 0.005, 
            "legendary": 0.001
        }, 
    }
}


const DEFAULT_DIFFICULTY = "Easy"
const EXPECTED_DECK_SIZE = 40
const MAX_CARD_COPIES = 3



static func get_match_profile(deck_key: String) -> Dictionary:
    if deck_key == "Unknown":
        return _create_unknown_profile()

    if not enemy_decks_data.has(deck_key):
        push_error("Deck não encontrado para a chave: " + deck_key)
        return _create_empty_profile()

    var enemy_data = enemy_decks_data[deck_key]
    var difficulty = enemy_data.get("difficulty", DEFAULT_DIFFICULTY)
    var deck_recipe = enemy_data.get("deck", {})

    var final_deck_pile = _build_deck_from_recipe(deck_recipe)
    final_deck_pile.shuffle()

    return {
        "name": deck_key, 
        "difficulty": difficulty, 
        "deck": final_deck_pile
    }



static func _build_deck_from_recipe(recipe: Dictionary) -> Array[CardData]:
    var deck: Array[CardData] = []

    for card_id in recipe.keys():
        var quantity = recipe[card_id]
        var card_obj = CardDatabase.get_card(card_id)

        if card_obj:
            for i in range(quantity):
                deck.append(card_obj)
        else:
            push_warning("Carta ID %d não encontrada no CardDatabase" % card_id)

    return deck



static func get_deck_list(enemy_name: String) -> Array[int]:
    if enemy_name == "Unknown":
        var tree = Engine.get_main_loop()
        if tree and tree.root.has_node("Global"):
            var global = tree.root.get_node("Global")
            return global.player_deck.duplicate()
        return []

    if not enemy_decks_data.has(enemy_name):
        push_error("Deck do inimigo '" + enemy_name + "' não encontrado no Database!")
        return []

    var enemy_data = enemy_decks_data[enemy_name]
    var deck_recipe = enemy_data.get("deck", {})

    var final_deck: Array[int] = []

    for card_id in deck_recipe:
        var quantity = deck_recipe[card_id]


        if quantity > MAX_CARD_COPIES:
            push_warning("Deck de %s tem %d cópias da carta ID %d (máx: %d)" % [
                enemy_name, quantity, card_id, MAX_CARD_COPIES
            ])

        for i in range(quantity):
            final_deck.append(card_id)


    if final_deck.size() != EXPECTED_DECK_SIZE:
        push_error("Deck de %s possui %d cartas (esperado: %d)" % [
            enemy_name, final_deck.size(), EXPECTED_DECK_SIZE
        ])

    return final_deck



static func _create_empty_profile() -> Dictionary:
    return {
        "name": "Unknown", 
        "difficulty": DEFAULT_DIFFICULTY, 
        "deck": []
    }

static func _create_unknown_profile() -> Dictionary:
    var final_deck: Array[CardData] = []


    var tree = Engine.get_main_loop()
    if tree and tree.root.has_node("Global"):
        var global = tree.root.get_node("Global")
        if global.player_deck.size() > 0:
            for card_id in global.player_deck:
                var card_obj = CardDatabase.get_card(card_id)
                if card_obj:
                    final_deck.append(card_obj)
        else:

            push_warning("Player deck is empty for Unknown enemy copy!")

    final_deck.shuffle()

    return {
        "name": "Unknown", 
        "difficulty": "Hard", 
        "deck": final_deck
    }


static func get_available_enemies() -> Array[String]:
    var enemies: Array[String] = []
    for key in enemy_decks_data.keys():
        enemies.append(key)
    return enemies


static func has_enemy(enemy_name: String) -> bool:
    return enemy_decks_data.has(enemy_name)


static func get_enemy_difficulty(enemy_name: String) -> String:
    if not enemy_decks_data.has(enemy_name):
        return DEFAULT_DIFFICULTY

    var enemy_data = enemy_decks_data[enemy_name]
    return enemy_data.get("difficulty", DEFAULT_DIFFICULTY)


static func get_deck_info(enemy_name: String) -> Dictionary:
    if enemy_name == "Unknown":
        var tree = Engine.get_main_loop()
        if tree and tree.root.has_node("Global"):
            var global = tree.root.get_node("Global")
            var p_deck = global.player_deck
            var unique = []
            for id in p_deck:
                if not id in unique:
                    unique.append(id)

            return {
                "total_cards": p_deck.size(), 
                "unique_cards": unique.size(), 
                "difficulty": "Hard", 
                "is_valid": p_deck.size() == EXPECTED_DECK_SIZE
            }
        return {"total_cards": 0, "unique_cards": 0, "difficulty": "Normal", "is_valid": false}

    if not enemy_decks_data.has(enemy_name):
        return {}

    var enemy_data = enemy_decks_data[enemy_name]
    var deck_recipe = enemy_data.get("deck", {})

    var total_cards = 0
    var unique_cards = deck_recipe.size()

    for quantity in deck_recipe.values():
        total_cards += quantity

    return {
        "total_cards": total_cards, 
        "unique_cards": unique_cards, 
        "difficulty": enemy_data.get("difficulty", DEFAULT_DIFFICULTY), 
        "is_valid": total_cards == EXPECTED_DECK_SIZE
    }



static func get_enemy_drops(enemy_name: String) -> Dictionary:
    if not enemy_decks_data.has(enemy_name):
        return {}


    if enemy_name == "Unknown":
        return _build_unknown_drops()

    return enemy_decks_data[enemy_name].get("drops", {})


static var _unknown_drops_cache: Dictionary = {}


static func _build_unknown_drops() -> Dictionary:

    if not _unknown_drops_cache.is_empty():
        return _unknown_drops_cache

    var common = []
    var rare = []
    var super_rare = []
    var epic = []
    var legendary = []

    for card_id in CardDatabase.cards:
        var card = CardDatabase.cards[card_id]


        if card.category in [CardData.CardCategory.MAGIC, CardData.CardCategory.TRAP]:
            rare.append(card_id)
        elif card.level <= 4:
            common.append(card_id)
        elif card.level <= 6:
            rare.append(card_id)
        elif card.level <= 8:
            super_rare.append(card_id)
        elif card.level <= 10:
            epic.append(card_id)
        else:
            legendary.append(card_id)

    _unknown_drops_cache = {
        "common": common, 
        "rare": rare, 
        "super_rare": super_rare, 
        "epic": epic, 
        "legendary": legendary
    }

    return _unknown_drops_cache


static func get_enemy_drop_rates(enemy_name: String) -> Dictionary:
    if not enemy_decks_data.has(enemy_name):
        return {"common": 0.75, "rare": 0.2, "super_rare": 0.05}

    return enemy_decks_data[enemy_name].get("drop_rates", {"common": 0.89, "rare": 0.094, "super_rare": 0.01, "epic": 0.005, "legendary": 0.001})


static func has_drops(enemy_name: String) -> bool:
    if not enemy_decks_data.has(enemy_name):
        return false


    if enemy_name == "Unknown":
        return true

    return enemy_decks_data[enemy_name].has("drops")
