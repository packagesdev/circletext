#ifndef __PAWN__
#define __PAWN__


extern unsigned char * fontImageData;

#define MAX_TEXT_LEN 100

typedef struct
{
  char text[MAX_TEXT_LEN];
  int x, y;
  int speed;
  int scale;
  int radius;
} circ_def;


#define NUMBER_OF_GLYPHS	26
#define FONT_LETTERS NUMBER_OF_GLYPHS*2+2

typedef struct
{
	float tx1, ty1, tx2, ty2;
	float width;
} char_def;

class scene
{
	private:
	
		unsigned long long _startTime;
		static unsigned char * _fontTextureData;
	
		static char_def _fontTable[FONT_LETTERS];
	
		static void _initializeFont(void);
	
		static char_def *_getCharDef(char inChar);
	
		static void _drawLetter(char inLetter);
		static void _drawCircleText(char *inText, float inRadius, float inScale);
	
	public:
	
		static unsigned char * getTextureData();
		static void setTextureData(unsigned char * inTextureData,size_t inSize);
	
		uint32_t numberOfCircleDefinitions;
		circ_def * circleDefinitions;
		
		scene();
		virtual ~scene();
		
		void create();
		
		void resize(int inWidth,int inHeight);
		
		void draw(void);
};

#endif