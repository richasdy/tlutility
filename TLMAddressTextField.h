//
//  TLMAddressTextField.h
//  TeX Live Utility
//
//  Created by Adam R. Maxwell on 07/24/11.
/*
 This software is Copyright (c) 2011
 Adam Maxwell. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 - Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in
 the documentation and/or other materials provided with the
 distribution.
 
 - Neither the name of Adam Maxwell nor the names of any
 contributors may be used to endorse or promote products derived
 from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import <Cocoa/Cocoa.h>
#import "TLMFaviconCache.h"

@interface TLMMirrorFieldEditor : NSTextView
{
@private
    BOOL _dragChangedText;
    BOOL _isEditing;
}
@end



@interface TLMAddressTextField : NSTextField
{
@private
    BOOL   _dragChangedText;
    double _progressValue;
    double _maximum;
    double _minimum;    
}

@property (nonatomic) double progressValue;
@property (nonatomic) double maximumProgressValue;
@property (nonatomic) double minimumProgressValue;
- (void)incrementProgressBy:(double)value;

- (void)setButtonImage:(NSImage *)image;
- (void)setButtonAction:(SEL)action;
- (void)setButtonTarget:(id)target;

@end

@protocol BDSKFieldEditorDelegate <NSTextViewDelegate>
@optional
- (NSRange)textView:(NSTextView *)textView rangeForUserCompletion:(NSRange)charRange;
- (BOOL)textViewShouldAutoComplete:(NSTextView *)textView;
@end

// the above delegate methods could be implemented by calling these delegate methods for NSControl subclasses that actually have a delegate
// currently implemented for NSTableView
@protocol BDSKFieldEditorControlDelegate <BDSKFieldEditorDelegate>
@optional
- (NSRange)control:(NSControl *)control textView:(NSTextView *)textView rangeForUserCompletion:(NSRange)charRange;
- (BOOL)control:(NSControl *)control textViewShouldAutoComplete:(NSTextView *)textView;
@end
