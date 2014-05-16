waxClass{"MyClass", NSObject, protocols = {"UIAlertViewDelegate"}}

function alertView_clickedButtonAtIndex(self, view, buttonIndex)
	print("click")
if buttonIndex==0 then
  return
end;
url = NSURL:URLWithString("http://itunes.apple.com/app/id577710538?ls=1&mt=8")
app = UIApplication:sharedApplication()
app:openURL(url)	
end

local delegate = MyClass:init()

x = wax.alert("更新提示","发现有新版本","跳过","确定")
x:setDelegate(delegate)


