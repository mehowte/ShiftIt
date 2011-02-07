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

BOOL equalRects(CGRect a, CGRect b) {
  return fabsf(a.origin.x - b.origin.x) < 16.0f &&
         fabsf(a.origin.y - b.origin.y) < 16.0f &&
         fabsf(a.size.width - b.size.width) < 16.0f &&
         fabsf(a.size.height - b.size.height) < 16.0f;
}

static int ratioCount = 5;
static float ratios[] = {
  1.0/2.0, 
  2.0/3.0, 
  3.0/4.0, 
  1.0/3.0, 
  2.0/5.0
};

NSRect ShiftIt_Left(NSRect screen, NSRect window) {
	NSRect r = screen;

  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];

    if (equalRects(r,window)) {
      r.size.width = screen.size.width * ratios[i+1];
      return r;
    }
  }
  
  r.size.width = screen.size.width * ratios[0];
  return r;
}

NSRect ShiftIt_Right(NSRect screen, NSRect window) {
	NSRect r = screen;
  
  for (int i = 0; i < ratioCount-1; i++) {
    r.size.width = screen.size.width * ratios[i];
    r.origin.x = screen.origin.x + screen.size.width - r.size.width;

    if (equalRects(r,window)) {
      r.size.width = screen.size.width * ratios[i+1];
      r.origin.x = screen.origin.x + screen.size.width - r.size.width;
      return r;
    }
  }
  
  r.size.width = screen.size.width * ratios[0];
  r.origin.x = screen.origin.x + screen.size.width - r.size.width;
  return r;
}

NSRect ShiftIt_Top(NSRect screen, NSRect window) {
	NSRect r = screen;
  r.size.height /= 2.0f;
	
	return r;
}

NSRect ShiftIt_Bottom(NSRect screen, NSRect window) {
	NSRect r = screen;

	r.origin.y = screen.origin.y + screen.size.height / 2.0f;
	r.size.height /= 2.0f;
	
	return r;
}

NSRect ShiftIt_TopLeft(NSRect screen, NSRect window) {
	NSRect r = screen;

	r.size.width /= 2.0f;
	r.size.height /= 2.0f;
	
	return r;
}

NSRect ShiftIt_TopRight(NSRect screen, NSRect window) {
	NSRect r = screen;

  r.origin.x += screen.size.width / 2.0f;

	r.size.width /= 2.0f;
	r.size.height /= 2.0f;
	
	return r;
}

NSRect ShiftIt_BottomLeft(NSRect screen, NSRect window) {
	NSRect r = screen;
	
	r.origin.y += screen.size.height / 2.0f;
	
	r.size.width /= 2.0f;
	r.size.height /= 2.0f;
	
	return r;
}

NSRect ShiftIt_BottomRight(NSRect screen, NSRect window) {
	NSRect r = screen;
	
	r.origin.x += screen.size.width / 2.0f;
	r.origin.y += screen.size.height / 2.0f;
	
	r.size.width /= 2.0f;
	r.size.height /= 2.0f;
	
	return r;
}

NSRect ShiftIt_FullScreen(NSRect screen, NSRect window) {
	return screen;
}

NSRect ShiftIt_Center(NSRect screen, NSRect window) {
	NSRect r;
	
	r.origin.x = screen.origin.x + (screen.size.width - window.size.width) / 2.0f;
	r.origin.y = screen.origin.y + (screen.size.height - window.size.height) / 2.0f;	
	
	r.size = window.size;
	
	return r;
}
