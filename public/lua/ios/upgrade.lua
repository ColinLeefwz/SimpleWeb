waxClass{"MyClass", NSObject, protocols = {"UIAlertViewDelegate"}}

function alertView_clickedButtonAtIndex(view, buttonIndex)
	print("click")
	
end

local delegate = MyClass:init()

local x = wax.alert("更新提示","发现有新版本","跳过","确定")
x:setDelegate(delegate)
--local x = UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("title", "message", delegate, "取消", nil)
--x:show()
puts("hello test")
puts(wax.guid())


