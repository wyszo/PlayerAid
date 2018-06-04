# PlayerAid

![PlayerAid screenshot](screenshot.jpg)

App for a business venture I was working on with 3 other guys. Didn't work out - after pivoting we dropped the project (hence the app is not on the store anymore).

You can see how it works on YouTube:

https://www.youtube.com/watch?v=GGfTUeMZVCk


## Tech details

Obj-C + Swift (mostly Objective-C). CoreData for persistance. Lots of the code (50%?) is in the TWCommonLib repo (wired as a Pod): https://github.com/wyszo/TWCommonLib

Certificates directory contains just public certificates, don't freak out, jeez. 


## Offline Demo compilation instructions


#### 1. Go to PlayerAid repo - `offlineDemo` branch

[https://github.com/wyszo/PlayerAid/tree/offlineDemo]()

#### 2. Clone or download it

You can either do it from GUI or type this in terminal:

```
mkdir ~/PlayerAid/
cd ~/PlayerAid
git clone git@github.com:wyszo/PlayerAid.git
```

Keep in mind it'll take a while to download (some videos are under version control unnecessarily).

```
cd PlayerAid
git checkout offlineDemo
```

Then

```
pod repo update
pod install
```

Only if the above commands fail, you first need to install cocoapods by typing

```
sudo gem install cocoapods
```

And then retry the two commands above.

#### 3. Install XCode from Mac App Store

#### 4. Run `PlayerAid.xcworkspace` file and compile `PlayerAid` target
