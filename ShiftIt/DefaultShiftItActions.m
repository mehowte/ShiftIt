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

NSRect ShiftIt_Left(NSRect screen, NSRect window) {
	NSRect r = screen;
  r.size.width *= 2.0f/3.0f;

  if (equalRects(r,window)) {
    r.size.width = screen.size.width / 3.0f;
    return r;
  }
  
  r.size.width = screen.size.width / 2.0f;

  if (equalRects(r,window))
    r.size.width = screen.size.width * 2.0f / 3.0f;

  return r;
}

NSRect ShiftIt_Right(NSRect screen, NSRect window) {
	NSRect r = screen;
  r.origin.x = screen.origin.x + screen.size.width / 3.0f;
  r.size.width *= 2.0f/3.0f;
  
  if (equalRects(r,window)) {
    r.origin.x = screen.origin.x + screen.size.width * 2.0f / 3.0f;
    r.size.width = screen.size.width / 3.0f;
    return r;
  }

  r.origin.x = screen.origin.x + screen.size.width / 2.0f;
  r.size.width = screen.size.width / 2.0f;
  
  if (equalRects(r,window)) {
    r.origin.x = screen.origin.x + screen.size.width / 3.0f;
    r.size.width = screen.size.width * 2.0f / 3.0f;
  }
  
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
