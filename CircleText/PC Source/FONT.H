#define FONT_UTOP 6
#define FONT_UBOTTOM 58
#define FONT_LTOP 60
#define FONT_LBOTTOM 112
#define FONT_IMG_WIDTH 1024
#define FONT_IMG_HEIGHT 128

#pragma pack(4)

struct
{ int left, top, right, bottom; } font_pos_table[]=
{{6, FONT_UTOP, 54, FONT_UBOTTOM},
{54, FONT_UTOP, 92, FONT_UBOTTOM},
{92, FONT_UTOP, 129, FONT_UBOTTOM},
{129, FONT_UTOP, 165, FONT_UBOTTOM},
{165, FONT_UTOP, 205, FONT_UBOTTOM},
{205, FONT_UTOP, 239, FONT_UBOTTOM},
{239, FONT_UTOP, 280, FONT_UBOTTOM},
{280, FONT_UTOP, 319, FONT_UBOTTOM},
{319, FONT_UTOP, 336, FONT_UBOTTOM},
{336, FONT_UTOP, 362, FONT_UBOTTOM},
{362, FONT_UTOP, 398, FONT_UBOTTOM},
{398, FONT_UTOP, 436, FONT_UBOTTOM},
{436, FONT_UTOP, 491, FONT_UBOTTOM},
{491, FONT_UTOP, 531, FONT_UBOTTOM},
{531, FONT_UTOP, 570, FONT_UBOTTOM},
{570, FONT_UTOP, 604, FONT_UBOTTOM},
{604, FONT_UTOP, 643, FONT_UBOTTOM},
{643, FONT_UTOP, 682, FONT_UBOTTOM},
{682, FONT_UTOP, 722, FONT_UBOTTOM},
{722, FONT_UTOP, 768, FONT_UBOTTOM},
{768, FONT_UTOP, 807, FONT_UBOTTOM},
{807, FONT_UTOP, 855, FONT_UBOTTOM},
{855, FONT_UTOP, 905, FONT_UBOTTOM},
{905, FONT_UTOP, 943, FONT_UBOTTOM},
{943, FONT_UTOP, 982, FONT_UBOTTOM},
{982, FONT_UTOP, 1020, FONT_UBOTTOM},

/* lower case */
{6, FONT_LTOP, 36, FONT_LBOTTOM},
{36, FONT_LTOP, 65, FONT_LBOTTOM},
{65, FONT_LTOP, 92, FONT_LBOTTOM},
{92, FONT_LTOP, 120, FONT_LBOTTOM},
{120, FONT_LTOP, 148, FONT_LBOTTOM},
{148, FONT_LTOP, 178, FONT_LBOTTOM},
{178, FONT_LTOP, 220, FONT_LBOTTOM},
{220, FONT_LTOP, 251, FONT_LBOTTOM},
{251, FONT_LTOP, 268, FONT_LBOTTOM},
{268, FONT_LTOP, 290, FONT_LBOTTOM},
{290, FONT_LTOP, 322, FONT_LBOTTOM},
{322, FONT_LTOP, 341, FONT_LBOTTOM},
{341, FONT_LTOP, 377, FONT_LBOTTOM},
{377, FONT_LTOP, 407, FONT_LBOTTOM},
{407, FONT_LTOP, 437, FONT_LBOTTOM},
{437, FONT_LTOP, 463, FONT_LBOTTOM},
{463, FONT_LTOP, 490, FONT_LBOTTOM},
{490, FONT_LTOP, 517, FONT_LBOTTOM},
{517, FONT_LTOP, 542, FONT_LBOTTOM},
{542, FONT_LTOP, 564, FONT_LBOTTOM},
{564, FONT_LTOP, 594, FONT_LBOTTOM},
{594, FONT_LTOP, 627, FONT_LBOTTOM},
{627, FONT_LTOP, 663, FONT_LBOTTOM},
{663, FONT_LTOP, 696, FONT_LBOTTOM},
{696, FONT_LTOP, 729, FONT_LBOTTOM},
{729, FONT_LTOP, 758, FONT_LBOTTOM},

/* puncuation */
{758, FONT_LTOP, 768, FONT_LBOTTOM},
{768, FONT_LTOP, 779, FONT_LBOTTOM}

};

#pragma pack()