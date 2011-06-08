/*
 ShiftIt: Resize windows with Hotkeys
 Copyright (C) 2010  Filip Krikava
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 */

#import "DefaultShiftItActions.h"
#import "FMTDefines.h"

BOOL almostEqualRects(CGRect a, CGRect b) {
  return fabsf(a.origin.x - b.origin.x) < 16.0f &&
         fabsf(a.origin.y - b.origin.y) < 16.0f &&
         fabsf(a.size.width - b.size.width) < 16.0f &&
         fabsf(a.size.height - b.size.height) < 16.0f;
}

NSPoint add(NSPoint a, NSPoint b) {
  NSPoint p = {
    a.x + b.x,
    a.y + b.y
  };
  return p;
}

NSPoint sub(NSPoint a, NSPoint b) {
  NSPoint p = {
    a.x - b.x,
    a.y - b.y
  };
  return p;
}

BOOL equalRects(NSRect a, NSRect b) {
  return a.origin.x    == b.origin.x &&
         a.origin.y    == b.origin.y &&
         a.size.width  == b.size.width &&
         a.size.height == b.size.height;
}

NSPoint bound(NSRect r) {
  NSPoint p = {
    r.origin.x + r.size.width,
    r.origin.y + r.size.height
  };
  return p;
}

static int ratioCount = 5;
static float ratios[] = {
  1.0/2.0, 
  2.0/3.0, 
  3.0/4.0, 
  1.0/3.0, 
  2.0/5.0
};

NSRect ShiftIt_Left(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;

  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];

    if (almostEqualRects(r,window)) {
      r.size.width = screen.size.width * ratios[i+1];
      return r;
    }
  }
  
  r.size.width = screen.size.width * ratios[0];
  return r;
}

NSRect ShiftIt_Right(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;
  
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;

    if (almostEqualRects(r,window)) {
      r.size.width = screen.size.width * ratios[i+1];
      r.origin.x = screen.origin.x + screen.size.width - r.size.width;
      return r;
    }
  }
  
  r.size.width = screen.size.width * ratios[0];
  r.origin.x = screen.origin.x + screen.size.width - r.size.width;
  return r;
}

NSRect ShiftIt_Top(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;

  for (int i = 0; i < ratioCount-1; i++) {
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      r.size.height = screen.size.height * ratios[i+1];
      return r;
    }
  }

  r.size.height = screen.size.height * ratios[0];
	return r;
}

NSRect ShiftIt_Bottom(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;

	for (int i = 0; i < ratioCount-1; i++) {
    r.size.height = screen.size.height * ratios[i];
    r.origin.y = screen.origin.y + screen.size.height - r.size.height;

    if (almostEqualRects(r,window)) {
      r.size.height = screen.size.height * ratios[i+1];
      r.origin.y = screen.origin.y + screen.size.height - r.size.height;
      return r;
    }
  }
  
  r.size.height = screen.size.height * ratios[0];
  r.origin.y = screen.origin.y + screen.size.height - r.size.height;
	
	return r;
}

NSRect ShiftIt_TopLeft(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;

	for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      r.size.width = screen.size.width * ratios[i+1];
      r.size.height = screen.size.height * ratios[i+1];
      return r;
    }
  }
  
  r.size.width = screen.size.width * ratios[0];
  r.size.height = screen.size.height * ratios[0];
	
	return r;
}

NSRect ShiftIt_TopRight(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;

  for (int i = 0; i < ratioCount-1; i++) {
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      r.origin.x = screen.origin.x + screen.size.width - r.size.width;
      r.size.width = screen.size.width * ratios[i+1];
      r.size.height = screen.size.height * ratios[i+1];
      return r;
    }
  }
  
  r.origin.x = screen.origin.x + screen.size.width - r.size.width;
  r.size.width = screen.size.width * ratios[0];
  r.size.height = screen.size.height * ratios[0];
	
	return r;
}

NSRect ShiftIt_BottomLeft(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;
	
	for (int i = 0; i < ratioCount-1; i++) {
    r.origin.y = screen.origin.y + screen.size.height - r.size.height;
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      r.origin.y = screen.origin.y + screen.size.height - r.size.height;
      r.size.width = screen.size.width * ratios[i+1];
      r.size.height = screen.size.height * ratios[i+1];
      return r;
    }
  }
  
  r.origin.y = screen.origin.y + screen.size.height - r.size.height;
  r.size.width = screen.size.width * ratios[0];
  r.size.height = screen.size.height * ratios[0];
	
	return r;
}

NSRect ShiftIt_BottomRight(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r = screen;
	
	for (int i = 0; i < ratioCount-1; i++) {
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;
    r.origin.y = screen.origin.y + screen.size.height - r.size.height;
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      r.origin.x = screen.origin.x + screen.size.width - r.size.width;
      r.origin.y = screen.origin.y + screen.size.height - r.size.height;
      r.size.width = screen.size.width * ratios[i+1];
      r.size.height = screen.size.height * ratios[i+1];
      return r;
    }
  }
  
  r.origin.x = screen.origin.x + screen.size.width - r.size.width;
  r.origin.y = screen.origin.y + screen.size.height - r.size.height;
  r.size.width = screen.size.width * ratios[0];
  r.size.height = screen.size.height * ratios[0];
	
	return r;
}

NSRect ShiftIt_FullScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	return screen;
}

NSRect ShiftIt_Center(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
	NSRect r;
	
	r.origin.x = screen.origin.x + (screen.size.width - window.size.width) / 2.0f;
	r.origin.y = screen.origin.y + (screen.size.height - window.size.height) / 2.0f;	
	
	r.size = window.size;
	
	return r;
}

NSRect changeScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount, int delta) {
  FMTDevLog(@"changeScreen screen=[%.02f %.02f %.02f %.02f]",
            screen.origin.x,screen.origin.y,screen.size.width,screen.size.height);
  
  int screenIndex;

  for (screenIndex = 0; screenIndex < screenCount; screenIndex++) {
    FMTDevLog(@"changeScreen screens[%i]=[%.02f %.02f %.02f %.02f]", screenIndex,
              screens[screenIndex].origin.x,screens[screenIndex].origin.y,
              screens[screenIndex].size.width,screens[screenIndex].size.height);

    if (equalRects(screens[screenIndex],screen))
      break;
  }
  
  if (screenIndex == screenCount) {
    FMTDevLog(@"screen not found");
    return window;
  }
  
  if (delta < 0) delta += screenCount;
  NSRect newScreen = screens[(screenIndex + delta) % screenCount];
  window.origin = add(sub(window.origin,screen.origin),newScreen.origin);

  NSPoint windowBound = bound(window);
  NSPoint screenBound = bound(newScreen);

  if (window.size.width > newScreen.size.width) {
    window.origin.x = newScreen.origin.x;
    window.size.width = newScreen.size.width;
  } else if (windowBound.x > screenBound.x) {
    window.origin.x -= windowBound.x - screenBound.x;
  }
  
  if (window.size.height > newScreen.size.height) {
    window.origin.y = newScreen.origin.y;
    window.size.height = newScreen.size.height;
  } else if (windowBound.y > screenBound.y) {
    window.origin.y -= windowBound.y - screenBound.y;
  }
  
  return window;
}

NSRect ShiftIt_PrevScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  return changeScreen(screen,window,screens,screenCount,-1);  
}

NSRect ShiftIt_NextScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  return changeScreen(screen,window,screens,screenCount,1);  
}


