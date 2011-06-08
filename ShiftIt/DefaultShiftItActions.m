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

static const int MAX_DIFFERENCE = 50.0f;
BOOL almostEqualRects(CGRect a, CGRect b) {
  
  return fabsf(a.origin.x - b.origin.x) < MAX_DIFFERENCE &&
         fabsf(a.origin.y - b.origin.y) < MAX_DIFFERENCE &&
         fabsf(a.size.width - b.size.width) < MAX_DIFFERENCE &&
         fabsf(a.size.height - b.size.height) < MAX_DIFFERENCE;
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

int findLeftCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findTopCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findRightCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findBottomCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.height = screen.size.height * ratios[i];
    r.origin.y = screen.origin.y + screen.size.height - r.size.height;

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findTopLeftCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findTopRightCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findBottomLeftCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.height = screen.size.height * ratios[i];
    r.size.width = screen.size.width * ratios[i];
    r.origin.y = screen.origin.y + screen.size.height - r.size.height;

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int findBottomRightCycleIndex(NSRect screen, NSRect window) {
	NSRect r = screen;
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.size.height = screen.size.height * ratios[i];
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;
    r.origin.y = screen.origin.y + screen.size.height - r.size.height;

    if (almostEqualRects(r,window)) {
      return i;
    }
  }
  return -1;
}
int nextCycleIndex(int cycleIndex) {
  return (cycleIndex + 1) % ratioCount;
}

NSRect computeRectangleWidthByCycleIndex(NSRect screen, NSRect alreadyComputedRectangle, int cycleIndex) {
  alreadyComputedRectangle.size.width = screen.size.width * ratios[cycleIndex];
  return alreadyComputedRectangle;
}
NSRect computeRectangleHeightByCycleIndex(NSRect screen, NSRect alreadyComputedRectangle, int cycleIndex) {
  alreadyComputedRectangle.size.height = screen.size.height * ratios[cycleIndex];
  return alreadyComputedRectangle;
}
NSRect adjustTop(NSRect screen, NSRect alreadyComputedRectangle) {
  alreadyComputedRectangle.origin.y = screen.origin.y + screen.size.height - alreadyComputedRectangle.size.height;
  return alreadyComputedRectangle;
}
NSRect adjustLeft(NSRect screen, NSRect alreadyComputedRectangle) {
  alreadyComputedRectangle.origin.x = screen.origin.x + screen.size.width - alreadyComputedRectangle.size.width;
  return alreadyComputedRectangle;
}

NSRect moveLeftByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleWidthByCycleIndex(screen, result, cycleIndex);
  return result;
}
NSRect moveTopByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleHeightByCycleIndex(screen, result, cycleIndex);
  return result;
}
NSRect moveRightByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleWidthByCycleIndex(screen, result, cycleIndex);
  result = adjustLeft(screen, result);
  return result;
}
NSRect moveBottomByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleHeightByCycleIndex(screen, result, cycleIndex);
  result = adjustTop(screen, result);
  return result;
}

NSRect moveTopLeftByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleWidthByCycleIndex(screen, result, cycleIndex);
  result = computeRectangleHeightByCycleIndex(screen, result, cycleIndex);
  return result;
}
NSRect moveTopRightByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleWidthByCycleIndex(screen, result, cycleIndex);
  result = computeRectangleHeightByCycleIndex(screen, result, cycleIndex);
  result = adjustLeft(screen, result);
  return result;
}
NSRect moveBottomLeftByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleWidthByCycleIndex(screen, result, cycleIndex);
  result = computeRectangleHeightByCycleIndex(screen, result, cycleIndex);
  result = adjustTop(screen, result);
  return result;
}
NSRect moveBottomRightByCycleIndex(NSRect screen, int cycleIndex) {
  NSRect result = screen;
  result = computeRectangleWidthByCycleIndex(screen, result, cycleIndex);
  result = computeRectangleHeightByCycleIndex(screen, result, cycleIndex);
  result = adjustLeft(screen, result);
  result = adjustTop(screen, result);
  return result;
}





NSRect ShiftIt_Left(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findLeftCycleIndex(screen, window);
  return moveLeftByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_Right(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findRightCycleIndex(screen, window);
  return moveRightByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_Top(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findTopCycleIndex(screen, window);
  return moveTopByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_Bottom(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findBottomCycleIndex(screen, window);
  return moveBottomByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_TopLeft(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findTopLeftCycleIndex(screen, window);
  return moveTopLeftByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_TopRight(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findTopRightCycleIndex(screen, window);
  return moveTopRightByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_BottomLeft(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findBottomLeftCycleIndex(screen, window);
  return moveBottomLeftByCycleIndex(screen, nextCycleIndex(cycleIndex));
}

NSRect ShiftIt_BottomRight(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  int cycleIndex = findBottomRightCycleIndex(screen, window);
  return moveBottomRightByCycleIndex(screen, nextCycleIndex(cycleIndex));
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

int findCurrentScreenIndex(NSRect screen, NSRect screens[], int screenCount) {
  for (int screenIndex = 0; screenIndex < screenCount; screenIndex++) {
    FMTDevLog(@"changeScreen screens[%i]=[%.02f %.02f %.02f %.02f]", screenIndex,
              screens[screenIndex].origin.x,screens[screenIndex].origin.y,
              screens[screenIndex].size.width,screens[screenIndex].size.height);

    if (equalRects(screens[screenIndex],screen))
      return screenIndex;
  }
  return -1;
}

int nextScreenIndex(int screenIndex, int screenCount) {
  return (screenIndex + 1) % screenCount;
}
int previousScreenIndex(int screenIndex, int screenCount) {
  return (screenIndex + screenCount - 1) % screenCount;
}

NSRect changeScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount, int delta) {
  FMTDevLog(@"changeScreen screen=[%.02f %.02f %.02f %.02f]",
            screen.origin.x,screen.origin.y,screen.size.width,screen.size.height);
  
  int screenIndex = findCurrentScreenIndex(screen, screens, screenCount);
  if (screenIndex == -1) {
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
NSRect tryToKeepAlignment(NSRect previousScreen, NSRect newScreen, NSRect window, NSRect alreadyComputedRectangle) {
  int cycleIndex = -1;
  NSRect result = alreadyComputedRectangle;
  if ( (cycleIndex = findLeftCycleIndex(previousScreen, window)) != -1) {
    result = moveLeftByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findRightCycleIndex(previousScreen, window)) != -1) {
    result = moveRightByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findTopCycleIndex(previousScreen, window)) != -1) {
    result = moveTopByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findBottomCycleIndex(previousScreen, window)) != -1) {
    result = moveBottomByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findTopLeftCycleIndex(previousScreen, window)) != -1) {
    result = moveTopLeftByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findTopRightCycleIndex(previousScreen, window)) != -1) {
    result = moveTopRightByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findBottomLeftCycleIndex(previousScreen, window)) != -1) {
    result = moveBottomLeftByCycleIndex(newScreen, cycleIndex);
  } else if ( (cycleIndex = findBottomRightCycleIndex(previousScreen, window)) != -1) {
    result = moveBottomRightByCycleIndex(newScreen, cycleIndex);
  } 
  return result;
}

NSRect ShiftIt_PrevScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  NSRect screenChangeRectangle = changeScreen(screen,window,screens,screenCount,-1);  
  NSRect result = screenChangeRectangle;
  int currentScreenIndex = findCurrentScreenIndex(screen, screens, screenCount);
  NSRect newScreen = screens[previousScreenIndex(currentScreenIndex, screenCount)];
  result = tryToKeepAlignment(screen, newScreen, window, result);
  return result;
}

NSRect ShiftIt_NextScreen(NSRect screen, NSRect window, NSRect screens[], int screenCount) {
  NSRect screenChangeRectangle = changeScreen(screen,window,screens,screenCount,1);  
  NSRect result = screenChangeRectangle;
  int currentScreenIndex = findCurrentScreenIndex(screen, screens, screenCount);
  NSRect newScreen = screens[nextScreenIndex(currentScreenIndex, screenCount)];
  result = tryToKeepAlignment(screen, newScreen, window, result);
  return result;
}


