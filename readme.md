THPinViewController
===================

iOS 7 Style PIN Screen for iPhone and iPad

<!-- Features
--------

* Caches UIImage instances in a NSCache
* Saves UIImage representations on disk as JPGs and PNGs
* Performs disk writes in a background queue

Usage
-----

	// configure
    [[THPinViewController sharedCache] setMemoryCacheSize:100];
    [[THPinViewController sharedCache] setTimeout:(24 * 60 * 60)];
    [[THPinViewController sharedCache] setJpgQuality:0.8];
    
    // cache an image (in memory and/or on disk, as PNG or JPG)
    UIImage* img = [UIImage imageNamed:@"test"];
    NSString* imgKey = @"testImgKey";
    [[THPinViewController sharedCache] cacheImage:img forKey:imgKey inMemory:YES onDisk:YES hasTransparency:YES];
    
    // query the cache
    if ([[THPinViewController sharedCache] hasCacheForKey:imgKey onlyInMemory:YES])
        NSLog(@"image is cached in memory");
    if ([[THPinViewController sharedCache] hasCacheForKey:imgKey onlyInMemory:NO])
        NSLog(@"image is cached in memory or disk");
    
    // access cached images
    UIImage* imgFromMemoryCache = [[THPinViewController sharedCache] imageForKey:imgKey onlyFromMemory:YES];
    UIImage* imgFromMemoryOrDiskCache = [[THPinViewController sharedCache] imageForKey:imgKey onlyFromMemory:NO];
    
    // remove from cache
    [[THPinViewController sharedCache] removeCacheForKey:imgKey];
    
    // clean the cache (enforces the timeout)
    [[THPinViewController sharedCache] cleanCache];
    
    // clear the cache
    [[THPinViewController sharedCache] clearCache];
    
    // Override point for customization after application launch.
    [[THPinViewController sharedCache] cleanCache];

Installation
-------

###As a Git Submodule

	git submodule add git://github.com/antiraum/THPinViewController.git <local path>
	git submodule update

###Via Cocoapods

Add this line to your Podfile:

    pod 'THPinViewController', '~> 1.0.0' -->
	
Compatibility
-------

THPinViewController requires iOS 7.0 and above. 

THPinViewController uses ARC. If you are using THPinViewController in your non-ARC project, you need to set the `-fobjc-arc` compiler flag for the THPinViewController source files.

License
-------

Made available under the MIT License.

Collaboration
-------------

If you have any feature requests or bugfixes feel free to help out and send a pull request, or create a new issue.
