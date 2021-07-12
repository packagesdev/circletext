#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include "pawnres.h"
#include "FONT.H"
#include <sys/time.h>
#include "Pawn.h"
#include <strings.h>

#define CLIP_NEAR 9.9
#define CLIP_FAR 10000.0
#define OPTION_BUFFER 1

#define TEXTURE_COUNT 1
#define FONT_TEXTURE texture_names[0]

#define HIGH_QUALITY 1

int options=HIGH_QUALITY;

/* new window size or exposure */

GLuint texture_names[TEXTURE_COUNT];

char_def scene::_fontTable[FONT_LETTERS]={};

unsigned char * scene::_fontTextureData=NULL;

void scene::_initializeFont(void)
{
	int length=0;
	
	for(int i=0;i<NUMBER_OF_GLYPHS;i++)
		length+=font_pos_table[i].right-font_pos_table[i].left;
	
	float avg_width=(float)length/(float)NUMBER_OF_GLYPHS;
	
	for(int i=0;i<FONT_LETTERS;i++)
	{
		scene::_fontTable[i].tx1=(float)font_pos_table[i].left/(float)FONT_IMG_WIDTH;
		scene::_fontTable[i].tx2=(float)font_pos_table[i].right/(float)FONT_IMG_WIDTH;
		scene::_fontTable[i].ty1=(float)font_pos_table[i].top/(float)FONT_IMG_HEIGHT;
		scene::_fontTable[i].ty2=(float)font_pos_table[i].bottom/(float)FONT_IMG_HEIGHT;
		
		scene::_fontTable[i].width=(float)(font_pos_table[i].right-font_pos_table[i].left)/avg_width;
	}
}

char_def * scene::_getCharDef(char inChar)
{
	if(isalpha(inChar))
	{
		if(isupper(inChar))
			return scene::_fontTable+(inChar-'A');
		else
			return scene::_fontTable+NUMBER_OF_GLYPHS+(inChar-'a');
	}
	else
	{
		if(inChar=='.')
			return scene::_fontTable+NUMBER_OF_GLYPHS*2;
		else if(inChar==',')
			return scene::_fontTable+NUMBER_OF_GLYPHS*2+1;
	}
	
	return NULL;
}

#pragma mark -

scene::scene()
{
}

scene::~scene()
{
	if (circleDefinitions!=NULL)
	{
		free(circleDefinitions);
		circleDefinitions=NULL;
	}
	
	glDeleteTextures(1, &FONT_TEXTURE);
}

#pragma mark -

unsigned char * scene::getTextureData()
{
	return _fontTextureData;
}

void scene::setTextureData(unsigned char * inTextureData,size_t inSize)
{
	if (inTextureData!=NULL && inSize>0)
	{
		_fontTextureData=(unsigned char *)malloc(inSize*sizeof(unsigned char));
		
		if (_fontTextureData!=NULL)
			memcpy(_fontTextureData,inTextureData,inSize*sizeof(unsigned char));
	}
}

#pragma mark -

void scene::_drawLetter(char inLetter)
{
	float aspect=.7;
	
	char_def *cd=scene::_getCharDef(inLetter);
	if(!cd)
		return;
	
	float width=cd->width*aspect;
	
	glBegin(GL_POLYGON);
		glTexCoord2f(cd->tx1, cd->ty2);
		glVertex3f(-width/2.0,-.5,0);
		glTexCoord2f(cd->tx2, cd->ty2);
		glVertex3f(width/2.0,-.5,0);
		glTexCoord2f(cd->tx2, cd->ty1);
		glVertex3f(width/2.0,.5,0);
		glTexCoord2f(cd->tx1, cd->ty1);
		glVertex3f(-width/2.0,.5,0);
	glEnd();
}


void scene::_drawCircleText(char *inString, float inRadius, float inScale)
{
	size_t length=strlen(inString);
	
	if (length>0)
	{
		float rot=360.0/length;
		
		for(int i=0;inString[i];i++)
		{
			glPushMatrix();
			
				glRotatef(rot*i,0,0,-1.0);
				glTranslatef(-inRadius,0,0);
				
				glScalef(inScale, inScale, inScale);
				glRotatef(90.0,0,0,1.0);
				
				scene::_drawLetter(inString[i]);
			
			glPopMatrix();
		}
	}
}

#pragma mark -

void scene::create()
{
	glGenTextures(TEXTURE_COUNT, texture_names);
	
	glBindTexture(GL_TEXTURE_2D, FONT_TEXTURE);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, (options&HIGH_QUALITY?GL_LINEAR:GL_NEAREST));
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, (options&HIGH_QUALITY?GL_LINEAR:GL_NEAREST));
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, FONT_IMG_WIDTH, FONT_IMG_HEIGHT,0, GL_ALPHA, GL_UNSIGNED_BYTE, scene::_fontTextureData);
	
	scene::_initializeFont();
	
	struct timeval tTime;
	gettimeofday(&tTime, NULL);
	
	_startTime=tTime.tv_sec*1000+tTime.tv_usec/1000;
	
	glClearColor(0.0, 0.0, 0.0, 1.0);
	
	
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
}

void scene::resize(int inWidth,int inHeight)
{
	glViewport(0, 0, inWidth, inHeight);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-inWidth/2.0, inWidth/2.0, -inHeight/2.0, inHeight/2.0, CLIP_NEAR, CLIP_FAR);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glTranslatef(0,0,-150);
	
	glDisable(GL_LIGHTING);
}

void scene::draw(void)
{
	struct timeval tTime;
	unsigned long long tCurentTime;
	
	gettimeofday(&tTime, NULL);
	
	tCurentTime=tTime.tv_sec*1000+tTime.tv_usec/1000;
	
	float ftime=(12.0*(tCurentTime-_startTime))/1000.0;
	
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	
	glColor4f((sin(ftime/256.0)+1.0)*.5, (sin(ftime/128.0)+1.0)*.5, (sin(ftime/64.0)+1.0)*.5, (sin(ftime/446.0)+1.0)*.5);
	
	glPushAttrib(GL_COLOR_BUFFER_BIT);
	
	for(uint32_t i=0;i<this->numberOfCircleDefinitions;i++)
	{
		circ_def tCircleDefinition=this->circleDefinitions[i];
		
		float s=(float)tCircleDefinition.scale/100.0;
		
		glPushMatrix();
		glTranslatef(tCircleDefinition.x,tCircleDefinition.y,0);
		
		glRotatef(ftime/((float)tCircleDefinition.speed/100.0),0,0,1);
		scene::_drawCircleText(tCircleDefinition.text, tCircleDefinition.radius, s);
		glPopMatrix();
	}
	
	glPopAttrib();
}
